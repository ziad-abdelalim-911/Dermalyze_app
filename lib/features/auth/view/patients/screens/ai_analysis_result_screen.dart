import 'package:dermalyze/core/constants/app_colors.dart';
import 'package:dermalyze/features/auth/view/patients/widgets/ai_recommendation_card.dart';
import 'package:dermalyze/features/auth/view/patients/widgets/detailed_analysis_card.dart';
import 'package:dermalyze/features/auth/view/patients/widgets/image_comparison_card.dart';
import 'package:dermalyze/features/auth/view/patients/widgets/improvement_detected_card.dart';
import 'package:dermalyze/features/auth/view/patients/widgets/progress_statistics_card.dart';
import 'package:dermalyze/features/auth/view/patients/widgets/slider_comparison_card.dart';
import 'package:flutter/material.dart';

class AiAnalysisResultScreen extends StatefulWidget {
  const AiAnalysisResultScreen({super.key});

  @override
  State<AiAnalysisResultScreen> createState() =>
      _AiAnalysisResultScreenState();
}

class _AiAnalysisResultScreenState extends State<AiAnalysisResultScreen> {
  bool _isSideBySide = true;

  final _analysisItems = const [
    DetailedAnalysisItem(
        label: 'Redness', oldValue: 'High', newValue: 'Medium'),
    DetailedAnalysisItem(
        label: 'Inflammation', oldValue: 'Severe', newValue: 'Moderate'),
    DetailedAnalysisItem(
        label: 'Texture', oldValue: 'Rough', newValue: 'Smooth'),
    DetailedAnalysisItem(
        label: 'Color Match', oldValue: '45%', newValue: '68%'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F4F8),
      body: Column(
        children: [
          // ── Header ──
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient2,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(32),
                bottomRight: Radius.circular(32),
              ),
            ),
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 40),
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: const Icon(Icons.arrow_back,
                            color: Colors.white, size: 22),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      width: 72,
                      height: 72,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Icon(Icons.auto_awesome,
                          color: Colors.white, size: 34),
                    ),
                    const SizedBox(height: 14),
                    const Text(
                      'AI Analysis Result',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Automated Skin Condition Comparison',
                      style:
                          TextStyle(color: Colors.white70, fontSize: 13),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // ── Content ──
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 100),
              child: Column(
                children: [
                  // Patient Info
                  _buildPatientInfoCard(),
                  const SizedBox(height: 16),

                  // Improvement
                  const ImprovementDetectedCard(
                    percentage: '+15%',
                    message:
                        'Patient showing positive response to treatment',
                  ),
                  const SizedBox(height: 16),

                  // Toggle Tabs
                  _buildToggleTabs(),
                  const SizedBox(height: 16),

                  // Comparison View
                  _isSideBySide
                      ? const ImageComparisonCard()
                      : const SliderComparisonCard(),
                  const SizedBox(height: 16),

                  // Progress Statistics
                  const ProgressStatisticsCard(
                    previousSeverity: '65%',
                    previousDate: 'Jan 15, 2025',
                    currentSeverity: '50%',
                    affectedAreaPrevious: '24.5 cm²',
                    affectedAreaCurrent: '18.2 cm²',
                    improvementRate: '15%',
                  ),
                  const SizedBox(height: 16),

                  // Detailed Analysis
                  DetailedAnalysisCard(items: _analysisItems),
                  const SizedBox(height: 16),

                  // AI Recommendation
                  const AiRecommendationCard(
                    recommendation:
                        'Continue current treatment plan. Patient showing positive response to medication.',
                  ),
                ],
              ),
            ),
          ),

          // ── Save Button ──
          _buildSaveButton(),
        ],
      ),
    );
  }

  Widget _buildPatientInfoCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.blueGrey.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Analysis for:',
            style: TextStyle(fontSize: 13, color: AppColors.Gray),
          ),
          const SizedBox(height: 12),
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: const Color(0xFFF0FDFA),
              borderRadius: BorderRadius.circular(14),
              border:
                  Border.all(color: AppColors.Turqouoise, width: 1),
            ),
            child: Row(
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    gradient: AppColors.primaryGradient2,
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: Text(
                      'SJ',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Sarah Johnson',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.Black,
                      ),
                    ),
                    Text(
                      'Atopic Dermatitis',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.Turqouoise,
                      ),
                    ),
                    Text(
                      'Previous Recovery Rate: 68%',
                      style: TextStyle(
                          fontSize: 12, color: AppColors.Gray),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildToggleTabs() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.blueGrey.withOpacity(0.08),
            blurRadius: 8,
          ),
        ],
      ),
      child: Row(
        children: [
          _buildTab('Side by Side', _isSideBySide,
              () => setState(() => _isSideBySide = true)),
          _buildTab('Slider View', !_isSideBySide,
              () => setState(() => _isSideBySide = false)),
        ],
      ),
    );
  }

  Widget _buildTab(String label, bool selected, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            gradient: selected ? AppColors.primaryGradient2 : null,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: selected ? Colors.white : AppColors.Gray,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSaveButton() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 28),
      color: const Color(0xFFF0F4F8),
      child: SizedBox(
        width: double.infinity,
        height: 52,
        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient: AppColors.primaryGradient2,
            borderRadius: BorderRadius.circular(16),
          ),
          child: ElevatedButton.icon(
            onPressed: () {
              // TODO: save to patient record
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            icon: const Icon(Icons.save_outlined,
                color: Colors.white, size: 20),
            label: const Text(
              'Save to Patient Record',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }
}