import 'package:dermalyze/features/auth/view/login/Patient_SignUp.dart';
import 'package:dermalyze/features/auth/view/login/doctor_SignUp.dart';
import 'package:dermalyze/features/auth/view/login/register_view.dart';
import 'package:dermalyze/features/auth/view/login/signup_view.dart';
import 'package:dermalyze/features/auth/view/navigation/custom_bottom_nav_bar.dart';
import 'package:dermalyze/features/auth/view/on_boarding/on_boarding_view.dart';
import 'package:dermalyze/splash.dart';
import 'package:flutter/material.dart';

/// AUTH
import '../../features/auth/view/login/login_view.dart';
import '../../features/auth/view/forgot_password/forgot_password_view.dart';

/// NAVIGATION

/// FEATURES
import '../../features/auth/view/ProgressReport_view/progress_report_view.dart';
import '../../features/auth/view/notifications/notifications_view.dart';
import '../../features/auth/view/medication_list/medication_list_view.dart';
import '../../features/auth/view/disease_details_view/disease_details_view.dart';

import 'app_routes.dart';

class AppRouter {
  static Route generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.splash:
        return MaterialPageRoute(builder: (_) => const SplashView());

      case AppRoutes.onboarding:
        return MaterialPageRoute(builder: (_) => const OnBoardingView());

      case AppRoutes.login:
        return MaterialPageRoute(builder: (_) => const LoginView());
        
      case AppRoutes.signup:
        return MaterialPageRoute(builder: (_) => const SignupView());

      case AppRoutes.register:
        return MaterialPageRoute(builder: (_) => const RegisterView());

      case AppRoutes.patientSignup:
        return MaterialPageRoute(builder: (_) => const PatientSignup());

      case AppRoutes.doctorSignup:
        return MaterialPageRoute(builder: (_) => const DoctorSignup());

      case AppRoutes.forgotPassword:
        return MaterialPageRoute(builder: (_) => const ForgotPasswordView());

      case AppRoutes.bottomNavBar:
        return MaterialPageRoute(builder: (_) => const CustomBottomNavBar());

      case AppRoutes.progressReport:
        return MaterialPageRoute(builder: (_) => const ProgressReportView());

      case AppRoutes.notifications:
        return MaterialPageRoute(builder: (_) => const NotificationsView());

      case AppRoutes.medicationList:
        return MaterialPageRoute(builder: (_) => const MedicationListView());

      case AppRoutes.diseaseDetails:
        return MaterialPageRoute(builder: (_) => const DiseaseDetailsView());

      default:
        return MaterialPageRoute(builder: (_) => const CustomBottomNavBar());
    }
  }
}
