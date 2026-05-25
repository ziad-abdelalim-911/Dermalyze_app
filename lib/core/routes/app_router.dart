import 'package:dermalyze/features/auth/view/home/doctor/screens/all_patients_screen.dart';
import 'package:dermalyze/features/auth/view/home/doctor/screens/critical_patients_screen.dart';
import 'package:dermalyze/features/auth/view/home/doctor/screens/doctor_home_screen.dart';
import 'package:dermalyze/features/auth/view/home/doctor/screens/doctor_profile_screen.dart';
import 'package:dermalyze/features/auth/view/home/doctor/data/repositories/doctor_home_repository_impl.dart';
import 'package:dermalyze/features/auth/view/home/doctor/domain/usecases/get_critical_patients_usecase.dart';
import 'package:dermalyze/features/auth/view/home/doctor/domain/usecases/get_doctor_stats_usecase.dart';
import 'package:dermalyze/features/auth/view/home/doctor/domain/usecases/get_patients_usecase.dart';
import 'package:dermalyze/features/auth/view/home/doctor/presentation/bloc/doctor_home_bloc.dart';
import 'package:dermalyze/features/auth/view/home/doctor/presentation/bloc/doctor_home_event.dart';
import 'package:dermalyze/features/auth/view/home/doctor/domain/entities/patient_entity.dart';
import 'package:dermalyze/features/auth/view/home/doctor/screens/smart_history_screen.dart';
import 'package:dermalyze/features/auth/view/home/doctor/screens/medications_guide_screen.dart';
import 'package:dermalyze/features/auth/view/chat/view/chat_view.dart';
import 'package:dermalyze/features/auth/view/home/doctor/screens/diseases_library_screen.dart';
import 'package:dermalyze/features/settings/view/settings_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dermalyze/features/auth/view/login/Patient_SignUp.dart';
import 'package:dermalyze/features/auth/view/login/doctor_SignUp.dart';
import 'package:dermalyze/features/auth/view/login/register_view.dart';
import 'package:dermalyze/features/auth/view/login/signup_view.dart';
import 'package:dermalyze/features/auth/view/navigation/custom_bottom_nav_bar.dart';
import 'package:dermalyze/features/auth/view/on_boarding/on_boarding_view.dart';
import 'package:dermalyze/features/auth/view/patients/screens/add_new_patient_screen.dart';
import 'package:dermalyze/features/auth/view/patients/screens/ai_analysis_result_screen.dart';
import 'package:dermalyze/features/auth/view/patients/screens/patient_details_screen.dart';
import 'package:dermalyze/features/auth/view/patients/screens/upload_analyze_screen.dart';
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
        return MaterialPageRoute(builder: (_) => NotificationsView());

      case AppRoutes.medicationList:
        return MaterialPageRoute(builder: (_) => const MedicationListView());

      case AppRoutes.diseaseDetails:
        final diseaseName = settings.arguments as String? ?? 'Skin Condition';
        return MaterialPageRoute(builder: (_) => DiseaseDetailsView(diseaseName: diseaseName));

      case AppRoutes.addNewPatient:
        return MaterialPageRoute(builder: (_) => const AddNewPatientScreen());

      case AppRoutes.patientDetails:
        // PatientEntity يتمرر من الـ patients list
        final patient = settings.arguments as PatientEntity?;
        return MaterialPageRoute(
          builder: (_) => PatientDetailsScreen(initialPatient: patient),
        );

      case AppRoutes.uploadAnalyze:
        final uploadArgs = settings.arguments as Map<String, dynamic>? ?? {};
        return MaterialPageRoute(
          builder: (_) => UploadAnalyzeScreen(
            patientId: uploadArgs['patientId'] as String? ?? '',
            patientName: uploadArgs['patientName'] as String?,
            diagnosis: uploadArgs['diagnosis'] as String?,
          ),
        );

      case AppRoutes.aiAnalysisResult:
        return MaterialPageRoute(
            settings: settings,
            builder: (_) => const AiAnalysisResultScreen());

      case AppRoutes.doctorHome:
        return MaterialPageRoute(builder: (_) => const DoctorHomeScreen());

      case AppRoutes.allPatients:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => DoctorHomeBloc(
              getDoctorStatsUseCase: GetDoctorStatsUseCase(DoctorHomeRepositoryImpl()),
              getPatientsUseCase: GetPatientsUseCase(DoctorHomeRepositoryImpl()),
              getCriticalPatientsUseCase: GetCriticalPatientsUseCase(DoctorHomeRepositoryImpl()),
            )..add(LoadDoctorHomeEvent()),
            child: const AllPatientsScreen(),
          ),
        );

      case AppRoutes.criticalPatients:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => DoctorHomeBloc(
              getDoctorStatsUseCase: GetDoctorStatsUseCase(DoctorHomeRepositoryImpl()),
              getPatientsUseCase: GetPatientsUseCase(DoctorHomeRepositoryImpl()),
              getCriticalPatientsUseCase: GetCriticalPatientsUseCase(DoctorHomeRepositoryImpl()),
            )..add(LoadDoctorHomeEvent()),
            child: const CriticalPatientsScreen(),
          ),
        );

      case AppRoutes.doctorProfile:
        return MaterialPageRoute(builder: (_) => const DoctorProfileScreen());

      case AppRoutes.smartHistory:
        return MaterialPageRoute(builder: (_) => const SmartHistoryScreen());
        
      case AppRoutes.medicationsGuide:
        return MaterialPageRoute(builder: (_) => const MedicationsGuideScreen());

      case AppRoutes.diseasesLibrary:
        return MaterialPageRoute(builder: (_) => const DiseasesLibraryScreen());

      case AppRoutes.Settings:
        return MaterialPageRoute(builder: (_) => const SettingsScreen());

      case AppRoutes.chat:
        final args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (_) => ChatView(
            receiverId: args['receiverId'] as String,
            receiverName: args['receiverName'] as String,
            receiverRole: args['receiverRole'] as String,
          ),
        );

      default:
        return MaterialPageRoute(
          builder: (_) => const CustomBottomNavBar(isDoctor: false),
        );
    }
  }
}