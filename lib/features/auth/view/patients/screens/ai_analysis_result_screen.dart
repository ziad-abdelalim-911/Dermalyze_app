import 'package:dermalyze/core/constants/app_colors.dart';
import 'package:dermalyze/features/auth/view/patients/data/review_repository.dart';
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
  bool _isSaving = false;
  Map<String, dynamic>? _result; // ✅ النتيجة الحقيقية من الـ API

  // fallback لو مفيش result
  String get _diagnosis => _result?['diagnosis'] ?? _result?['condition'] ?? 'Analysis Complete';
  String get _confidence => _result?['confidence'] != null
      ? '${(_result!['confidence'] * 100).toStringAsFixed(0)}%'
      : 'N/A';
  String get _recommendation =>
      _result?['recommendation'] ?? _result?['treatment'] ?? 'Continue current treatment plan.';
  String get _severity => _result?['severity'] ?? _result?['stage'] ?? 'Moderate';

  /// يبني قائمة التحليل التفصيلي من الـ API result ديناميكياً
  List<DetailedAnalysisItem> get _analysisItems {
    // لو الـ API رجّع details list استخدمها
    final details = _result?['details'] ?? _result?['analysisDetails'];
    if (details is List && details.isNotEmpty) {
      return details.map((d) {
        if (d == null) return null;
        final map = d as Map<String, dynamic>;
        return DetailedAnalysisItem(
          label: map['label'] ?? map['metric'] ?? 'Feature',
          oldValue: (map['previous'] ?? map['oldValue'] ?? '—').toString(),
          newValue: (map['current'] ?? map['newValue'] ?? '—').toString(),
        );
      }).whereType<DetailedAnalysisItem>().toList();
    }

    // fallback — بنبني من الحقول الرئيسية الموجودة في الـ result
    final items = <DetailedAnalysisItem>[];
    if (_result?['severity'] != null || _result?['stage'] != null) {
      items.add(DetailedAnalysisItem(
        label: 'Severity',
        oldValue: _result?['previousSeverity']?.toString() ?? '—',
        newValue: _severity,
      ));
    }
    if (_result?['confidence'] != null) {
      items.add(DetailedAnalysisItem(
        label: 'Confidence',
        oldValue: '—',
        newValue: _confidence,
      ));
    }
    if (_result?['affectedArea'] != null || _result?['currentArea'] != null) {
      items.add(DetailedAnalysisItem(
        label: 'Affected Area',
        oldValue: (_result?['affectedArea'] ?? '—').toString(),
        newValue: (_result?['currentArea'] ?? '—').toString(),
      ));
    }
    if (_result?['diagnosis'] != null) {
      items.add(DetailedAnalysisItem(
        label: 'Condition',
        oldValue: '—',
        newValue: _diagnosis,
      ));
    }
    // لو مفيش بيانات كافية نرجع placeholder
    if (items.isEmpty) {
      return const [
        DetailedAnalysisItem(label: 'Analysis', oldValue: '—', newValue: 'Complete'),
      ];
    }
    return items;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // نقرأ الـ arguments من الـ navigation
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is Map<String, dynamic>) {
      setState(() => _result = args);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
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
                padding: EdgeInsets.fromLTRB(20, 12, 20, 40),
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Icon(Icons.arrow_back,
                            color: Theme.of(context).cardColor, size: 22),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      width: 72,
                      height: 72,
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor.withOpacity(0.2),
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
                  ImprovementDetectedCard(
                    percentage: _confidence,
                    message: _recommendation,
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
                  ProgressStatisticsCard(
                    previousSeverity: _severity,
                    previousDate: _result?['date'] ?? 'Previous scan',
                    currentSeverity: _severity,
                    affectedAreaPrevious: _result?['affectedArea'] ?? 'N/A',
                    affectedAreaCurrent: _result?['currentArea'] ?? 'N/A',
                    improvementRate: _confidence,
                  ),
                  const SizedBox(height: 16),

                  // Detailed Analysis
                  DetailedAnalysisCard(items: _analysisItems),
                  const SizedBox(height: 16),

                  // AI Recommendation
                  AiRecommendationCard(
                    recommendation: _recommendation,
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
        color: Theme.of(context).cardColor,
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
              color: Theme.of(context).cardColor,
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
                  child: Center(
                    child: Text(
                      // initials من اسم المريض الحقيقي
                      _getInitials(_result?['patientName'] ?? ''),
                      style: TextStyle(
                        color: Theme.of(context).cardColor,
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
                      _result?['patientName'] ?? 'Patient',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    Text(
                      _diagnosis,
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.Turqouoise,
                      ),
                    ),
                    Text(
                      'Confidence: $_confidence',
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
        color: Theme.of(context).cardColor,
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
      color: Theme.of(context).scaffoldBackgroundColor,
      child: SizedBox(
        width: double.infinity,
        height: 52,
        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient: _isSaving ? null : AppColors.primaryGradient2,
            color: _isSaving ? Colors.grey.shade400 : null,
            borderRadius: BorderRadius.circular(16),
          ),
          child: ElevatedButton.icon(
            onPressed: _isSaving ? null : _saveToPatientRecord,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            icon: _isSaving
                ? SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                        color: Theme.of(context).cardColor, strokeWidth: 2),
                  )
                : const Icon(Icons.save_outlined, color: Colors.white, size: 20),
            label: Text(
              _isSaving ? 'Saving...' : 'Save to Patient Record',
              style: const TextStyle(
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

  /// يحوّل اسم المريض لـ initials (مثلاً "Sarah Johnson" → "SJ")
  String _getInitials(String name) {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty || parts[0].isEmpty) return '?';
    if (parts.length == 1) return parts[0][0].toUpperCase();
    return '${parts[0][0]}${parts[parts.length - 1][0]}'.toUpperCase();
  }

  /// يحفظ نتيجة التحليل في سجل المريض عبر الـ API
  Future<void> _saveToPatientRecord() async {
    final patientId = _result?['patientId']?.toString() ?? '';
    if (patientId.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Cannot save: patient ID not found in result'),
            backgroundColor: Colors.orange,
          ),
        );
      }
      return;
    }

    setState(() => _isSaving = true);
    try {
      // نستخدم ReviewRepository لحفظ ملاحظة تلخيصية بالتحليل
      final summary =
          'AI Analysis: $_diagnosis | Severity: $_severity | Confidence: $_confidence';
      await ReviewRepository().saveReview(
        patientId: patientId,
        review: summary,
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Analysis saved to patient record ✓'),
            backgroundColor: Color(0xFF4ECDC4),
          ),
        );
        Navigator.pop(context); // ارجع للشاشة السابقة بعد الحفظ
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error saving: ${e.toString()}'),
            backgroundColor: Colors.red.shade400,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }
}