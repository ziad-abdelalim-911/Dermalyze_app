import 'package:dermalyze/core/constants/app_colors.dart';
import 'package:dermalyze/features/auth/view/home/home_header.dart';
import 'package:dermalyze/features/auth/view/home/recovery_progress_card.dart';
import 'package:flutter/material.dart';

import 'diagnosis_card.dart';
import 'medication_list_card.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

int _currentIndex = 0;

class _HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: AppColors.primaryGradient1,
        ),
        child: Column(
          children: const [
            /// الهيدر
            HomeHeader(userName: "ziad"),

            SizedBox(height: 16),

            /// التشخيص
            DiagnosisCard(),

            SizedBox(height: 16),

            /// الريكفري
            RecoveryProgressCard(),

            SizedBox(height: 16),

            /// الادوية
            MedicationListCard(),

            SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
