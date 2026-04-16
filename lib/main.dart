
import 'package:dermalyze/core/routes/app_router.dart';
import 'package:dermalyze/core/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dermalyze/core/theme/app_theme.dart';
import 'package:dermalyze/core/theme/cubit/theme_cubit.dart';

import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final isDark = prefs.getBool('app_theme_mode') ?? false;
  
  runApp(MyApp(isDark: isDark));
}

class MyApp extends StatelessWidget {
  final bool isDark;
  const MyApp({super.key, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ThemeCubit(isDark: isDark),
      child: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (context, themeMode) {
          return MaterialApp(
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
