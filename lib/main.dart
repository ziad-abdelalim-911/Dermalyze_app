import 'package:dermalyze/core/constants/app_colors.dart';
import 'package:dermalyze/core/routes/app_router.dart';
import 'package:dermalyze/core/routes/app_routes.dart';
import 'package:dermalyze/features/auth/view/patients/screens/add_new_patient_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      title: 'Dermalyze',

      theme: ThemeData(primaryColor: AppColors.primaryColor),

      // initialRoute: AppRoutes.splash,

      // onGenerateRoute: AppRouter.generateRoute,

      home: AddNewPatientScreen(),

      // onUnknownRoute: (settings) {
      //   return MaterialPageRoute(
      //     builder: (_) =>
      //         const Scaffold(body: Center(child: Text("Page Not Found"))),
      //   );
      // },
    );
  }
}
