import 'dart:io';
import 'package:dermalyze/core/constants/app_colors.dart';
import 'package:dermalyze/core/theme/theme_extensions.dart';
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

  bool get _isFirstScan =>
      _result?['isFirstScan'] == true || _result?['previousScan'] == null;

  String get _confidence {
    final raw = _result?['confidence'];
    if (raw == null) return 'N/A';
    final num val = raw is num ? raw : num.tryParse(raw.toString()) ?? 0;
    return '${(val * 100).toStringAsFixed(0)}%';
  }

  String get _diagnosis    => _result?['diagnosis'] ?? 'Analysis Complete';
  String get _severity     => _result?['severity'] ?? 'N/A';
  String get _recommendation => _result?['recommendation'] ?? 'Continue current treatment plan.';
  String get _improvement  => _result?['improvement'] ?? 'No change';
  String get _patientId    => _result?['patientId']?.toString() ?? '';

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
    if (args is Map) {
      setState(() => _result = Map<String, dynamic>.from(args));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
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
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 24, 16, 30),
                    child: Column(
                      children: [
                        // 1. Patient Info — دايماً بتتظهر
                        _buildPatientInfoCard(),
                        const SizedBox(height: 16),

                        // 2. Improvement + Comparison — بس لو في صورة قديمة
                        if (!_isFirstScan) ...[
                          ImprovementDetectedCard(
                            percentage: _confidence,
                            message: _recommendation,
                          ),
                          const SizedBox(height: 16),
                          _buildToggleTabs(),
                          const SizedBox(height: 16),
                          _isSideBySide
                              ? ImageComparisonCard(
                                  currentImageFile: _result?['currentImageFile'] as File?,
                                  previousImageUrl: (_result?['previousScan'] as Map?)?['imageUrl'] as String?,
                                  previousSeverity: (_result?['previousScan'] as Map?)?['severity'] as String? ?? 'N/A',
                                  currentSeverity: _severity,
                                )
                              : SliderComparisonCard(
                                  currentImageFile: _result?['currentImageFile'] as File?,
                                  previousImageUrl: (_result?['previousScan'] as Map?)?['imageUrl'] as String?,
                                  previousSeverity: (_result?['previousScan'] as Map?)?['severity'] as String? ?? 'N/A',
                                  currentSeverity: _severity,
                                ),
                          const SizedBox(height: 16),
                          ProgressStatisticsCard(
                            previousSeverity: (_result?['previousScan'] as Map?)?['severity'] as String? ?? 'N/A',
                            previousDate: 'Previous scan',
                            currentSeverity: _severity,
                            affectedAreaPrevious: 'N/A',
                            affectedAreaCurrent: 'N/A',
                            improvementRate: _improvement,
                          ),
                          const SizedBox(height: 16),
                        ],

                        // 3. Banner لو أول صورة
                        if (_isFirstScan) ...[
                          Container(
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: AppColors.Turqouoise.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(color: AppColors.Turqouoise.withOpacity(0.4)),
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.info_outline, color: AppColors.Turqouoise, size: 20),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    'This is the first scan for this patient. '
                                    'A comparison will be available after the next scan.',
                                    style: TextStyle(fontSize: 13, color: AppColors.Turqouoise),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                        ],

                        // 4. دايماً بيتظهروا
                        DetailedAnalysisCard(items: _analysisItems),
                        const SizedBox(height: 16),
                        AiRecommendationCard(
                          recommendation: _recommendation,
                        ),
                      ],
                    ),
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
            style: TextStyle(fontSize: 13, color: context.dynamicTextColorSecondary),
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
                      style: const TextStyle(
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
                          fontSize: 12, color: context.dynamicTextColorSecondary),
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
                color: selected ? Colors.white : context.dynamicTextColorSecondary,
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
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                        color: Colors.white, strokeWidth: 2),
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
        Navigator.popUntil(context, ModalRoute.withName(AppRoutes.patientDetails)); // ارجع لشاشة المريض عشان يعمل ريفريش
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