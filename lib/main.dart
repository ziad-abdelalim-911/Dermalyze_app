
import 'package:dermalyze/core/routes/app_router.dart';
import 'package:dermalyze/core/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dermalyze/core/theme/app_theme.dart';
import 'package:dermalyze/core/theme/cubit/theme_cubit.dart';

import 'package:dermalyze/features/auth/view/notifications/notifications_cubit.dart';
import 'package:dermalyze/features/auth/view/notifications/notifications_repository.dart';
import 'package:dermalyze/features/auth/view/chat/logic/conversations_cubit.dart';
import 'package:dermalyze/features/auth/view/chat/data/repositories/chat_repository.dart';
import 'package:dermalyze/core/network/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // try {
  //   await Firebase.initializeApp();
  //   await PushNotificationService.initialize(navigatorKey);
  // } catch (e) {
  //   print("⚠️ Firebase initialization failed: $e");
  //   print("⚠️ Please make sure you have run 'flutterfire configure' and provided google-services.json");
  // }

  final prefs = await SharedPreferences.getInstance();
  final isDark = prefs.getBool('app_theme_mode') ?? false;
  
  runApp(MyApp(isDark: isDark));
}

class MyApp extends StatelessWidget {
  final bool isDark;
  const MyApp({super.key, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => ThemeCubit(isDark: isDark)),
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
