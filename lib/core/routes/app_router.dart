import 'package:dermalyze/features/auth/view/home/doctor/screens/all_patients_screen.dart';
import 'package:dermalyze/features/auth/view/home/doctor/screens/critical_patients_screen.dart';
import 'package:dermalyze/features/auth/view/home/doctor/screens/doctor_home_screen.dart';
import 'package:dermalyze/features/auth/view/home/doctor/screens/doctor_profile_screen.dart';
import 'package:dermalyze/features/auth/view/login/Patient_SignUp.dart';
import 'package:dermalyze/features/auth/view/login/doctor_SignUp.dart';
import 'package:dermalyze/features/auth/view/login/register_view.dart';
import 'package:dermalyze/features/auth/view/login/signup_view.dart';
import 'package:dermalyze/features/auth/view/navigation/custom_bottom_nav_bar.dart';
import 'package:dermalyze/features/auth/view/on_boarding/on_boarding_view.dart';
import 'package:dermalyze/features/auth/view/patients/screens/add_new_patient_screen.dart';
import 'package:dermalyze/features/auth/view/patients/screens/patient_details_screen.dart';
import 'package:dermalyze/splash.dart';
import 'package:flutter/material.dart';

/// AUTH
import '../../features/auth/view/login/login_view.dart';
import '../../features/auth/view/forgot_password/forgot_password_view.dart';

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
        final isDoctor = settings.arguments as bool? ?? false;
        return MaterialPageRoute(
          builder: (_) => CustomBottomNavBar(isDoctor: isDoctor),
        );

      case AppRoutes.progressReport:
        return MaterialPageRoute(builder: (_) => const ProgressReportView());

      case AppRoutes.notifications:
        return MaterialPageRoute(builder: (_) => const NotificationsView());

      case AppRoutes.medicationList:
        return MaterialPageRoute(builder: (_) => const MedicationListView());

      case AppRoutes.diseaseDetails:
        return MaterialPageRoute(builder: (_) => const DiseaseDetailsView());

      case AppRoutes.addNewPatient:
        return MaterialPageRoute(builder: (_) => const AddNewPatientScreen());

      case AppRoutes.patientDetails:
        return MaterialPageRoute(builder: (_) => const PatientDetailsScreen());

      case AppRoutes.doctorHome:
        return MaterialPageRoute(builder: (_) => const DoctorHomeScreen());

      case AppRoutes.allPatients:
        return MaterialPageRoute(builder: (_) => const AllPatientsScreen());

      case AppRoutes.criticalPatients:
        return MaterialPageRoute(
          builder: (_) => const CriticalPatientsScreen(),
        );

      case AppRoutes.doctorProfile:
        return MaterialPageRoute(builder: (_) => const DoctorProfileScreen());

      default:
        return MaterialPageRoute(
          builder: (_) => const CustomBottomNavBar(isDoctor: false),
        );
    }
  }
}
