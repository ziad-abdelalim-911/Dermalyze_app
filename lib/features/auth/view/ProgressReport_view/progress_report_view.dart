import 'package:dermalyze/core/constants/app_assets.dart';
import 'package:dermalyze/core/storage/token_storage.dart';
import 'package:dermalyze/features/auth/view/ProgressReport_view/key_metrics_card.dart';
import 'package:dermalyze/features/auth/view/ProgressReport_view/next_steps_card.dart';
import 'package:dermalyze/features/auth/view/ProgressReport_view/progress_header_card.dart';
import 'package:dermalyze/features/auth/view/ProgressReport_view/quality_status_card.dart';
import 'package:dermalyze/features/auth/view/ProgressReport_view/recovery_timeline_card.dart';
import 'package:dermalyze/features/auth/view/ProgressReport_view/symptom_improvement_card.dart';
import 'package:dermalyze/features/auth/view/home/patient_home_repository.dart';
import 'package:flutter/material.dart';

class ProgressReportView extends StatefulWidget {
  const ProgressReportView({super.key});

  @override
  State<ProgressReportView> createState() => _ProgressReportViewState();
}

class _ProgressReportViewState extends State<ProgressReportView> {
  final _repo = PatientHomeRepository();
  final _tokenStorage = TokenStorage();

  bool _isLoading = true;
  String? _error;

  // الحقول اللي بنجيبها من الـ API
  int _recoveryPercent = 0;
  int _improvementPercent = 0;
  String _currentQuality = '—';
  String _lastQuality = '—';
  String _initialQuality = '—';
  List<TimelineItemModel> _timelineItems = [];
  List<MetricItem> _metricItems = [];
  List<SymptomModel> _symptoms = [];
  List<String> _nextSteps = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      // جيب التحاليل السابقة عشان نبني الـ timeline
      final user = await _tokenStorage.getUser();
      final patientId = user?['_id'] ?? user?['id'] ?? '';

      // جيب بيانات البروفايل من الـ API
      final profile = await _repo.getMyProfile(patientId);

      List<dynamic> analyses = [];
      if (patientId.isNotEmpty) {
        analyses = await _repo.getMyAnalyses(patientId);
      }

      setState(() {
        // Recovery
        var recovery = profile['recoveryProgress'] ?? profile['recoveryRate'];
        if (recovery == null || recovery == 0 || recovery == '0') {
           recovery = profile['improvementPercent'] ?? profile['improvement'];
        }
        if (recovery != null) {
          if (recovery is num) {
             _recoveryPercent = (recovery <= 1.0 && recovery > 0) ? (recovery * 100).toInt() : recovery.toInt();
          } else if (recovery is String) {
             final parsed = double.tryParse(recovery) ?? 0.0;
             _recoveryPercent = (parsed <= 1.0 && parsed > 0) ? (parsed * 100).toInt() : parsed.toInt();
          }
        } else {
          _recoveryPercent = 0;
        }

        final improvementRaw = profile['improvementPercent'] ?? profile['improvement'] ?? 0;
        if (improvementRaw is num) {
           _improvementPercent = improvementRaw.toInt();
        } else if (improvementRaw is String) {
           final cleanStr = improvementRaw.replaceAll('%', '').replaceAll('+', '').trim();
           _improvementPercent = (double.tryParse(cleanStr) ?? 0.0).toInt();
        } else {
           _improvementPercent = 0;
        }

        // Quality
        _currentQuality = _capitalize(
            profile['quality'] ?? profile['recoveryQuality'] ?? '—');
        _lastQuality = _capitalize(
            profile['lastQuality'] ?? profile['previousQuality'] ?? '—');
        _initialQuality = _capitalize(
            profile['initialQuality'] ?? 'Low Quality');

        // Timeline من التحاليل الحقيقية
        _timelineItems = _buildTimeline(analyses, profile);

        // Metrics
        _metricItems = _buildMetrics(profile, analyses);

        // Symptoms من الـ profile
        _symptoms = _buildSymptoms(profile);

        // Next Steps من الـ profile
        _nextSteps = _buildNextSteps(profile);

        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  // ── Helpers ──────────────────────────────────────────────────────────────

  String _capitalize(String s) {
    if (s.isEmpty || s == '—') return s;
    return s[0].toUpperCase() + s.substring(1);
  }

  List<TimelineItemModel> _buildTimeline(
      List<dynamic> analyses, Map<String, dynamic> profile) {
    if (analyses.isNotEmpty) {
      return analyses.take(4).map((a) {
        if (a == null) return null;
        final m = a as Map<String, dynamic>;
        final rate = m['recoveryRate'] ?? m['improvement'] ?? 0;
        final rateStr = rate != 0 ? '$rate%' : '—';
        return TimelineItemModel(
          title: m['stage'] ?? m['condition'] ?? 'Analysis',
          date: m['createdAt'] ?? m['date'] ?? '—',
          recoveryRate: rateStr,
          description: m['recommendation'] ?? m['notes'] ?? 'Scan completed.',
          color: const Color(0xFF22C55E),
          bgColor: const Color(0xFFE7F6EC),
        );
      }).whereType<TimelineItemModel>().toList();
    }

    // fallback — من بيانات الـ profile
    return [
      TimelineItemModel(
        title: 'Current Status',
        date: profile['lastCheckup'] ?? profile['lastVisit'] ?? '—',
        recoveryRate: '$_recoveryPercent%',
        description: 'Continue your current treatment plan.',
        color: const Color(0xFF22C55E),
        bgColor: const Color(0xFFE7F6EC),
      ),
    ];
  }

  List<MetricItem> _buildMetrics(
      Map<String, dynamic> profile, List<dynamic> analyses) {
    return [
      MetricItem(
        iconPath: AppAssets.calendarIcon,
        value: (profile['daysInTreatment'] ??
                profile['treatmentDays'] ??
                analyses.length)
            .toString(),
        label: 'Days in Treatment',
        iconColor: const Color(0xFF0F766E),
        textColor: const Color(0xFF0F766E),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      MetricItem(
        iconPath: AppAssets.progress_icon,
        value: '+$_improvementPercent%',
        label: 'Overall Improvement',
        iconColor: const Color(0xFF166534),
        textColor: const Color(0xFF166534),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      MetricItem(
        iconPath: AppAssets.pulse_icon,
        value: (profile['doctorCheckups'] ?? profile['checkups'] ?? analyses.length).toString(),
        label: 'Doctor Checkups',
        iconColor: const Color(0xFF1D4ED8),
        textColor: const Color(0xFF1D4ED8),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      MetricItem(
        iconPath: AppAssets.award_Icon,
        value: '${profile['adherence'] ?? profile['medicationAdherence'] ?? 0}%',
        label: 'Medication Adherence',
        iconColor: const Color(0xFF6D28D9),
        textColor: const Color(0xFF6D28D9),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
    ];
  }

  List<SymptomModel> _buildSymptoms(Map<String, dynamic> profile) {
    final raw = profile['symptoms'] ?? profile['symptomImprovement'];
    if (raw is List && raw.isNotEmpty) {
      return raw.map((s) {
        if (s == null) return null;
        final m = s as Map<String, dynamic>;
        
        final rawPercent = m['improvement'] ?? m['percent'] ?? 0;
        int finalPercent = 0;
        if (rawPercent is num) {
           finalPercent = rawPercent.toInt();
        } else if (rawPercent is String) {
           final cleanStr = rawPercent.replaceAll('%', '').replaceAll('+', '').trim();
           finalPercent = (double.tryParse(cleanStr) ?? 0.0).toInt();
        }

        return SymptomModel(
          name: m['name'] ?? 'Symptom',
          percent: finalPercent,
        );
      }).whereType<SymptomModel>().toList();
    }
    // لو مفيش بيانات symptoms من الـ API نرجع قائمة فارغة (مش mock)
    return [];
  }

  List<String> _buildNextSteps(Map<String, dynamic> profile) {
    final raw = profile['nextSteps'] ?? profile['recommendations'];
    if (raw is List && raw.isNotEmpty) {
      return raw.map((s) => s.toString()).toList();
    }
    // fallback بسيط
    return [
      'Continue your current treatment plan',
      if ((profile['nextVisit'] ?? '').isNotEmpty)
        'Next checkup: ${profile['nextVisit']}',
      'Upload progress photos weekly',
    ];
  }

  // ── Build ──────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Column(
        children: [
          /// HEADER
          Container(
            padding: const EdgeInsets.fromLTRB(16, 50, 16, 16),
            decoration: BoxDecoration(
              color: Theme.of(context).appBarTheme.backgroundColor,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(24),
                bottomRight: Radius.circular(24),
              ),
            ),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(Icons.arrow_back, color: Theme.of(context).colorScheme.onSurface),
                  ),
                ),
                const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Progress Report',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                    SizedBox(height: 2),
                    Text(
                      'Your recovery journey',
                      style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant, fontSize: 13),
                    ),
                  ],
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.refresh, color: Colors.grey),
                  onPressed: _loadData,
                  tooltip: 'Refresh',
                ),
              ],
            ),
          ),

          /// BODY
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _error != null
                    ? _buildError()
                    : _buildContent(),
          ),
        ],
      ),
    );
  }

  Widget _buildError() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline, size: 48, color: Colors.red.shade300),
            const SizedBox(height: 12),
            Text(
              _error!,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.grey, fontSize: 14),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _loadData,
              icon: const Icon(Icons.refresh),
              label: const Text('Try Again'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        ProgressHeaderCard(
          recoveryPercent: _recoveryPercent,
          improvementPercent: _improvementPercent,
        ),

        const SizedBox(height: 16),

        QualityStatusCard(
          current: _currentQuality,
          lastMonth: _lastQuality,
          initial: _initialQuality,
        ),

        const SizedBox(height: 16),

        RecoveryTimelineCard(items: _timelineItems),

        const SizedBox(height: 16),

        KeyMetricsCard(MetricItems: _metricItems),

        if (_symptoms.isNotEmpty) ...[
          const SizedBox(height: 16),
          SymptomImprovementCard(symptoms: _symptoms),
        ],

        const SizedBox(height: 16),

        NextStepsCard(steps: _nextSteps),

        const SizedBox(height: 30),
      ],
    );
  }
}
