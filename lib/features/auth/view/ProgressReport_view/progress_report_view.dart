import 'package:dermalyze/core/constants/app_assets.dart';
import 'package:dermalyze/features/auth/view/ProgressReport_view/key_metrics_card.dart';
import 'package:dermalyze/features/auth/view/ProgressReport_view/next_steps_card.dart';
import 'package:dermalyze/features/auth/view/ProgressReport_view/progress_header_card.dart';
import 'package:dermalyze/features/auth/view/ProgressReport_view/quality_status_card.dart';
import 'package:dermalyze/features/auth/view/ProgressReport_view/recovery_timeline_card.dart';
import 'package:dermalyze/features/auth/view/ProgressReport_view/symptom_improvement_card.dart';
import 'package:flutter/material.dart';

class ProgressReportView extends StatefulWidget {
  const ProgressReportView({super.key});

  @override
  State<ProgressReportView> createState() => _ProgressReportViewState();
}

class _ProgressReportViewState extends State<ProgressReportView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F6F6),

      body: Column(
        children: [
          /// ================= HEADER =================
          Container(
            padding: const EdgeInsets.fromLTRB(16, 50, 16, 16),

            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(24),
                bottomRight: Radius.circular(24),
              ),
            ),

            child: Row(
              children: [
                /// back button
                GestureDetector(
                  onTap: () => Navigator.pop(context),

                  child: Container(
                    width: 40,
                    height: 40,

                    decoration: BoxDecoration(
                      color: const Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.circular(12),
                    ),

                    child: const Icon(Icons.arrow_back),
                  ),
                ),

                const SizedBox(width: 12),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      "Progress Report",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    SizedBox(height: 2),

                    Text(
                      "Your recovery journey",
                      style: TextStyle(color: Colors.grey, fontSize: 13),
                    ),
                  ],
                ),
              ],
            ),
          ),

          /// ================= BODY =================
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),

              children: [
                /// recovery header
                const ProgressHeaderCard(
                  recoveryPercent: 76,
                  improvementPercent: 12,
                ),

                const SizedBox(height: 16),

                /// quality status
                const QualityStatusCard(
                  current: "High Quality",
                  lastMonth: "Medium Quality",
                  initial: "Low Quality",
                ),

                const SizedBox(height: 16),

                /// timeline
                RecoveryTimelineCard(
                  items: [
                    TimelineItemModel(
                      title: "Current Status",
                      date: "Jan 1, 2026",
                      recoveryRate: "76%",
                      description:
                          "Significant improvement in symptoms. Continue treatment plan.",

                      color: const Color(0xFF22C55E),
                      bgColor: const Color(0xFFE7F6EC),
                    ),

                    TimelineItemModel(
                      title: "Week 2 Check",
                      date: "Dec 25, 2025",
                      recoveryRate: "48%",
                      description:
                          "Moderate improvement. Adjusted medication dosage.",

                      color: const Color(0xFFF59E0B),
                      bgColor: const Color(0xFFFEF3C7),
                    ),

                    TimelineItemModel(
                      title: "Initial Diagnosis",
                      date: "Dec 15, 2025",
                      recoveryRate: "0%",
                      description:
                          "Treatment plan initiated. Baseline assessment completed.",

                      color: const Color(0xFFEF4444),
                      bgColor: const Color(0xFFFEE2E2),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                /// metrics
                KeyMetricsCard(
                  MetricItems: [
                    MetricItem(
                      iconPath: AppAssets.calendarIcon,
                      value: "17",
                      label: "Days in Treatment",

                      iconColor: const Color(0xFF0F766E),
                      textColor: const Color(0xFF0F766E),
                      backgroundColor: const Color(0xFFE6F4F1),
                    ),

                    MetricItem(
                      iconPath: AppAssets.progress_icon,
                      value: "+28%",
                      label: "Overall Improvement",

                      iconColor: const Color(0xFF166534),
                      textColor: const Color(0xFF166534),
                      backgroundColor: const Color(0xFFE7F6EC),
                    ),

                    MetricItem(
                      iconPath: AppAssets.pulse_icon,
                      value: "3",
                      label: "Doctor Checkups",

                      iconColor: const Color(0xFF1D4ED8),
                      textColor: const Color(0xFF1D4ED8),
                      backgroundColor: const Color(0xFFE8F0FE),
                    ),

                    MetricItem(
                      iconPath: AppAssets.award_Icon,
                      value: "95%",
                      label: "Medication Adherence",

                      iconColor: const Color(0xFF6D28D9),
                      textColor: const Color(0xFF6D28D9),
                      backgroundColor: const Color(0xFFF3E8FF),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                /// symptom improvement
                SymptomImprovementCard(
                  symptoms: [
                    SymptomModel(name: "Itching", percent: 65),

                    SymptomModel(name: "Redness", percent: 52),

                    SymptomModel(name: "Dryness", percent: 48),

                    SymptomModel(name: "Swelling", percent: 70),
                  ],
                ),

                const SizedBox(height: 16),

                /// next steps
                const NextStepsCard(
                  steps: [
                    "Continue current medication regimen",

                    "Next checkup scheduled: January 15, 2026",

                    "Upload progress photos weekly",

                    "Track daily symptoms in app",
                  ],
                ),

                const SizedBox(height: 30),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
