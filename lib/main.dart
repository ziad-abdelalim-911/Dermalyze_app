import 'dart:async';
import 'dart:ui' as ui;
import 'package:app_links/app_links.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import 'package:dermalyze/core/routes/app_router.dart';
import 'package:dermalyze/core/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:dermalyze/core/theme/app_theme.dart';
import 'package:dermalyze/core/theme/cubit/theme_cubit.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:dermalyze/firebase_options.dart';
import 'package:dermalyze/core/services/push_notification_service.dart';
import 'package:dermalyze/features/auth/view/notifications/notifications_cubit.dart';
import 'package:dermalyze/features/auth/view/notifications/notifications_repository.dart';
import 'package:dermalyze/features/auth/view/chat/logic/conversations_cubit.dart';
import 'package:dermalyze/features/auth/view/chat/data/repositories/chat_repository.dart';
import 'package:dermalyze/core/network/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dermalyze/core/services/biometric_service.dart' as dermalyze_bio;
import 'package:dermalyze/core/widgets/offline_banner.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  
  // Initialize Offline Storage (Hive)
  await Hive.initFlutter();
  await Hive.openBox('offline_chats');
  await Hive.openBox('offline_patients');
  
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    await PushNotificationService.initialize(navigatorKey);
  } catch (e) {
    print("⚠️ Firebase initialization failed: $e");
    print("⚠️ Please make sure you have run 'flutterfire configure' and provided google-services.json");
  }

  final prefs = await SharedPreferences.getInstance();
  final isDark = prefs.getBool('app_theme_mode') ?? false;
  
  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('ar')],
      path: 'assets/translations',
      fallbackLocale: const Locale('en'),
      child: MyApp(isDark: isDark),
    ),
  );
}

class MyApp extends StatefulWidget {
  final bool isDark;
  const MyApp({super.key, required this.isDark});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  bool _isLocked = false;
  final _biometricService = dermalyze_bio.BiometricService();
  
  late AppLinks _appLinks;
  StreamSubscription<Uri>? _linkSubscription;
  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;
  bool _isOffline = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initDeepLinks();
    _initConnectivity();
  }

  void _initConnectivity() {
    _connectivitySubscription = Connectivity().onConnectivityChanged.listen((List<ConnectivityResult> results) {
      if (mounted) {
        setState(() {
          _isOffline = results.contains(ConnectivityResult.none) && results.length == 1;
        });
      }
    });
  }

  Future<void> _initDeepLinks() async {
    _appLinks = AppLinks();

    // Check initial link if app was cold-started from a link
    try {
      final initialUri = await _appLinks.getInitialLink();
      if (initialUri != null) {
        _handleDeepLink(initialUri);
      }
    } catch (e) {
      print("Failed to get initial deep link: $e");
    }

    // Listen for links while the app is running
    _linkSubscription = _appLinks.uriLinkStream.listen((uri) {
      _handleDeepLink(uri);
    }, onError: (err) {
      print("Deep link stream error: $err");
    });
  }

  void _handleDeepLink(Uri uri) {
    if (uri.path == '/activate') {
      final token = uri.queryParameters['token'];
      if (token != null && token.isNotEmpty) {
        // We use addPostFrameCallback to ensure Navigator is ready
        WidgetsBinding.instance.addPostFrameCallback((_) {
          navigatorKey.currentState?.pushNamed(
            AppRoutes.setPassword,
            arguments: token,
          );
        });
      }
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _linkSubscription?.cancel();
    _connectivitySubscription?.cancel();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // When the app goes to background, we lock it
    if (state == AppLifecycleState.paused) {
      _isLocked = true;
    }
    // When the app resumes, we show the biometric prompt
    if (state == AppLifecycleState.resumed && _isLocked) {
      _authenticate();
    }
  }

  Future<void> _authenticate() async {
    final canAuth = await _biometricService.isBiometricAvailable();
    if (!canAuth) {
      if (mounted) {
        setState(() {
          _isLocked = false;
        });
      }
      return;
    }

    // Show biometric prompt
    final authenticated = await _biometricService.authenticate();
    if (authenticated) {
      setState(() {
        _isLocked = false;
      });
    } else {
      // If failed, they can't see the app content.
      // Usually, you'd show a lock screen widget here, but for simplicity we keep it locked.
      // They can tap a button to retry on the lock screen.
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => ThemeCubit(isDark: widget.isDark)),
        BlocProvider(
          create: (_) => NotificationsCubit(NotificationsRepository())..fetchNotifications(),
        ),
        BlocProvider(
          create: (_) => ConversationsCubit(ChatRepository(ApiService())),
        ),
      ],
      child: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (context, themeMode) {
          return MaterialApp(
            navigatorKey: navigatorKey,
            debugShowCheckedModeBanner: false,
            title: 'Dermalyze',
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeMode,
            initialRoute: AppRoutes.splash,
            onGenerateRoute: AppRouter.generateRoute,
            localizationsDelegates: context.localizationDelegates,
            supportedLocales: context.supportedLocales,
            locale: context.locale,
            builder: (context, child) {
              Widget mainContent = child ?? const SizedBox.shrink();
              
              if (_isLocked) {
                mainContent = Scaffold(
                  body: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.lock_outline, size: 80, color: Colors.blueGrey),
                        const SizedBox(height: 20),
                        const Text('App Locked', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: _authenticate,
                          child: const Text('Unlock with Biometrics'),
                        ),
                      ],
                    ),
                  ),
                );
              }
              
              return Directionality(
                textDirection: ui.TextDirection.ltr,
                child: Stack(
                  children: [
                    mainContent,
                    if (_isOffline)
                      const Positioned(
                        top: 0,
                        left: 0,
                        right: 0,
                        child: Material(child: OfflineBanner()),
                      ),
                  ],
                ),
              );
            },
            onUnknownRoute: (settings) {
              return MaterialPageRoute(
                builder: (_) => const Scaffold(
                  body: Center(child: Text("Page Not Found")),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
