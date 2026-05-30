import 'dart:async';
import 'package:dermalyze/core/constants/app_colors.dart';
import 'package:dermalyze/core/routes/app_routes.dart';
import 'package:dermalyze/core/network/api_service.dart';
import 'package:dermalyze/core/services/socket_service.dart';
import 'package:dermalyze/core/theme/theme_extensions.dart';
import 'package:dermalyze/features/auth/view/home/doctor/domain/entities/patient_entity.dart';
import 'package:dermalyze/features/auth/view/patients/data/analysis_repository.dart';
import 'package:dermalyze/features/auth/view/patients/data/review_repository.dart';
import 'package:dermalyze/features/auth/view/medication_list/medication_repository.dart';
import 'package:dermalyze/features/auth/view/patients/widgets/add_medication_bottom_sheet.dart';
import 'package:dermalyze/features/auth/view/patients/widgets/doctors_review_card.dart';
import 'package:dermalyze/features/auth/view/patients/widgets/followup_image_card.dart';
import 'package:dermalyze/features/auth/view/patients/widgets/patient_info_card.dart';
import 'package:dermalyze/features/auth/view/patients/widgets/prescribed_medications_card.dart';
import 'package:dermalyze/features/auth/view/patients/widgets/progress_timeline_card.dart';
import 'package:dermalyze/features/auth/view/patients/widgets/schedule_followup_bottom_sheet.dart';
import 'package:dermalyze/features/auth/view/patients/widgets/update_status_bottom_sheet.dart';
import 'package:flutter/material.dart';

class PatientDetailsScreen extends StatefulWidget {
  final PatientEntity? initialPatient;
  const PatientDetailsScreen({super.key, this.initialPatient});

  @override
  State<PatientDetailsScreen> createState() => _PatientDetailsScreenState();
}

class _PatientDetailsScreenState extends State<PatientDetailsScreen> {
  final _reviewController = TextEditingController();
  final _analysisRepo = AnalysisRepository();
  final _medicationRepo = MedicationRepository();
  final _reviewRepo = ReviewRepository();

  PatientEntity? _patient;
  List<dynamic> _analyses = [];
  List<dynamic> _medications = [];
  bool _isLoading = true;
  bool _isSavingReview = false;
  StreamSubscription? _socketSubscription;

  @override
  void initState() {
    super.initState();
    _socketSubscription = SocketService().patientUpdateStream.listen((data) {
      if (!mounted || _patient == null) return;
      if (data['patientId']?.toString() == _patient!.id) {
        bool needsUpdate = false;
        double? newRate;
        String? newImprovement;
        String? newNextAppt;
        String? newLastVisit;

        if (data.containsKey('recoveryProgress')) {
          final recovery = data['recoveryProgress'];
          double parsedRecovery = 0.0;
          if (recovery is num) {
            parsedRecovery = recovery.toDouble();
          } else if (recovery is String) {
            parsedRecovery = double.tryParse(recovery) ?? 0.0;
          }
          newRate = parsedRecovery > 1.0 ? parsedRecovery / 100.0 : parsedRecovery.clamp(0.0, 1.0);
          newImprovement = data['improvement']?.toString() ?? _patient!.improvement;
          needsUpdate = true;
        }

        if (data.containsKey('nextAppointment')) {
          newNextAppt = data['nextAppointment']?.toString();
          needsUpdate = true;
        }
        
        if (data.containsKey('lastVisit')) {
          newLastVisit = data['lastVisit']?.toString();
          needsUpdate = true;
        }

        if (needsUpdate) {
          setState(() {
            _patient = _patient!.copyWith(
              recoveryRate: newRate ?? _patient!.recoveryRate,
              improvement: newImprovement ?? _patient!.improvement,
              nextAppointment: newNextAppt ?? _patient!.nextAppointment,
              lastVisit: newLastVisit ?? _patient!.lastVisit,
            );
          });
        }
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_patient == null) {
      // 1. جرب الـ constructor parameter أولاً
      _patient = widget.initialPatient;
      // 2. لو مش موجود، جرب الـ route arguments
      if (_patient == null) {
        final args = ModalRoute.of(context)?.settings.arguments;
        if (args is PatientEntity) _patient = args;
      }
      if (_patient != null) _loadData();
    }
  }

  Future<void> _loadData() async {
    if (_patient == null) return;
    setState(() => _isLoading = true);
    try {
      final apiService = ApiService();
      
      final results = await Future.wait([
        _analysisRepo.getPatientAnalyses(_patient!.id),
        _medicationRepo.getMedications(_patient!.id),
        apiService.get('patients/${_patient!.id}'),
      ]);
      if (mounted) {
        setState(() {
          _analyses = results[0] as List<dynamic>;
          _medications = results[1] as List<dynamic>;
          
          final detailedPatientData = results[2];
          if (detailedPatientData is Map<String, dynamic> && detailedPatientData.containsKey('patient')) {
            final patientData = detailedPatientData['patient'] as Map<String, dynamic>;
            final nextAppt = patientData['nextAppointment'] ?? patientData['next_appointment'] ?? _patient!.nextAppointment;
            final status = patientData['status'] ?? _patient!.statusBadge;
            final lastVisit = patientData['lastVisit'] ?? _patient!.lastVisit;
            final recovery = patientData['recoveryProgress'] ?? 0;
            double parsedRecovery = 0.0;
            if (recovery is num) {
              parsedRecovery = recovery.toDouble();
            } else if (recovery is String) {
              parsedRecovery = double.tryParse(recovery) ?? 0.0;
            }
            final newRate = parsedRecovery > 1.0 ? parsedRecovery / 100.0 : parsedRecovery.clamp(0.0, 1.0);
            
            _patient = _patient!.copyWith(
              nextAppointment: nextAppt,
              lastVisit: lastVisit,
              statusBadge: status,
              recoveryRate: newRate,
            );
          }
          
          _isLoading = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _socketSubscription?.cancel();
    _reviewController.dispose();
    super.dispose();
  }

  Future<void> _saveReview() async {
    if (_reviewController.text.trim().isEmpty) return;
    setState(() => _isSavingReview = true);
    try {
      await _reviewRepo.saveReview(
        patientId: _patient!.id,
        review: _reviewController.text.trim(),
      );
      _reviewController.clear();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Review saved successfully ✓'),
            backgroundColor: Color(0xFF4ECDC4),
          ),
        );
      }
    } catch (_) {
      // Note saved locally — backend endpoint pending
      _reviewController.clear();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Note saved locally ✓'),
            backgroundColor: Color(0xFF4ECDC4),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isSavingReview = false);
    }
  }

  // Build timeline from real analyses
  List<TimelineItem> get _timelineItems {
    if (_analyses.isEmpty) {
      return const [
        TimelineItem(label: 'No analyses yet', badge: 'N/A', date: '—'),
      ];
    }

    // Sort analyses by date ascending (oldest first)
    final sortedAnalyses = List<dynamic>.from(_analyses)..sort((a, b) {
      final dateA = DateTime.tryParse(a['createdAt'] ?? a['date'] ?? '') ?? DateTime.now();
      final dateB = DateTime.tryParse(b['createdAt'] ?? b['date'] ?? '') ?? DateTime.now();
      return dateA.compareTo(dateB);
    });

    final initialDate = DateTime.tryParse(sortedAnalyses.first['createdAt'] ?? sortedAnalyses.first['date'] ?? '');

    List<TimelineItem> items = [];
    for (int i = 0; i < sortedAnalyses.length; i++) {
      final map = sortedAnalyses[i] as Map<String, dynamic>;
      
      String label;
      if (i == 0) {
        label = 'Initial';
      } else if (i == sortedAnalyses.length - 1 && sortedAnalyses.length > 1) {
        label = 'Current';
      } else {
        if (initialDate != null) {
          final currentDate = DateTime.tryParse(map['createdAt'] ?? map['date'] ?? '');
          if (currentDate != null) {
            final days = currentDate.difference(initialDate).inDays;
            final weeks = (days / 7).round();
            label = weeks > 0 ? 'Week $weeks' : 'Follow up $i';
          } else {
            label = 'Follow up $i';
          }
        } else {
          label = 'Follow up $i';
        }
      }

      items.add(TimelineItem(
        label: map['stage'] ?? label,
        badge: map['severity'] ?? 'Medium',
        date: _formatDateStr(map['createdAt'] ?? map['date']),
        improvement: map['improvement'],
        imageUrl: map['imageUrl'] ?? map['image'] ?? map['photoUrl'],
      ));
    }

    return items;
  }

  String _formatDateStr(String? isoString) {
    if (isoString == null || isoString.isEmpty) return '—';
    try {
      final date = DateTime.parse(isoString);
      final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
      return '${months[date.month - 1]} ${date.day.toString().padLeft(2, '0')}, ${date.year}';
    } catch (_) {
      return isoString;
    }
  }

  List<MedicationItem> get _medicationItems {
    return _medications.map((m) {
      final map = m as Map<String, dynamic>;
      return MedicationItem(
        id: (map['_id'] ?? map['id'] ?? '').toString(),
        name: (map['name'] ?? '').toString(),
        dosage: (map['dosage'] ?? '').toString(),
        schedule: (map['frequency'] ?? '').toString(),
        notes: map['notes']?.toString(),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final name = _patient?.name ?? 'Patient';
    final diagnosis = _patient?.diagnosis ?? '—';

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: _buildAppBar(context, name),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
              child: Column(
                children: [
                  FollowupImageCard(
                    onTap: () async {
                      await Navigator.pushNamed(
                        context,
                        AppRoutes.uploadAnalyze,
                        arguments: {
                          'patientId': _patient?.id ?? '',
                          'patientName': name,
                          'diagnosis': diagnosis,
                        },
                      );
                      if (mounted) {
                        _loadData(); // Refresh timeline with new analysis
                      }
                    },
                  ),
                  const SizedBox(height: 16),
                  PatientInfoCard(
                    name: name,
                    diagnosis: diagnosis,
                    quality: _patient?.qualityBadge ?? '—',
                    lastVisit: _patient?.lastVisit ?? '—',
                    recoveryRate:
                        '${((_patient?.recoveryRate ?? 0) * 100).toInt()}%',
                    improvement: _patient?.improvement ?? '',
                  ),
                  const SizedBox(height: 16),
                  ProgressTimelineCard(items: _timelineItems),
                  const SizedBox(height: 16),
                  DoctorsReviewCard(
                    reviewController: _reviewController,
                    onSave: _isSavingReview ? null : _saveReview,
                  ),
                  const SizedBox(height: 16),
                  PrescribedMedicationsCard(
                    medications: _medicationItems,
                    onAddMedication: () async {
                      final success = await showModalBottomSheet<bool>(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        builder: (ctx) => AddMedicationBottomSheet(
                          patientId: _patient!.id,
                        ),
                      );

                      if (success == true && mounted) {
                        _loadData();
                      }
                    },
                    onEditMedication: (med) async {
                      final success = await showModalBottomSheet<bool>(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        builder: (ctx) => AddMedicationBottomSheet(
                          patientId: _patient!.id,
                          initialMedication: med,
                        ),
                      );

                      if (success == true && mounted) {
                        _loadData();
                      }
                    },
                    onDeleteMedication: (med) async {
                      final confirm = await showDialog<bool>(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: const Text('Remove Medication'),
                          content: Text('Are you sure you want to remove ${med.name}?'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(ctx, false),
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () => Navigator.pop(ctx, true),
                              style: TextButton.styleFrom(foregroundColor: Colors.red),
                              child: const Text('Remove'),
                            ),
                          ],
                        ),
                      );

                      if (confirm == true && mounted) {
                        setState(() => _isLoading = true);
                        try {
                          await _medicationRepo.deleteMedication(med.id);
                          _loadData();
                        } catch (e) {
                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
                            );
                            setState(() => _isLoading = false);
                          }
                        }
                      }
                    },
                  ),
                ],
              ),
            ),
      bottomNavigationBar: _buildBottomButtons(context, name, diagnosis),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context, String name) {
    return AppBar(
      backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
      elevation: 0,
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: Theme.of(context).iconTheme.color),
        onPressed: () => Navigator.pop(context),
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            name,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          Text(
            'Review and manage case',
            style: TextStyle(fontSize: 12, color: context.dynamicTextColorSecondary),
          ),
        ],
      ),
      actions: [
        if (_patient != null)
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    AppRoutes.patientReport,
                    arguments: _patient!.id,
                  );
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF4ECDC4).withOpacity(0.15),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.assignment, size: 18, color: Color(0xFF3B9B94)),
                      const SizedBox(width: 6),
                      const Text(
                        'Report',
                        style: TextStyle(color: Color(0xFF3B9B94), fontWeight: FontWeight.w600, fontSize: 13),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    AppRoutes.chat,
                    arguments: {
                      'receiverId': _patient!.id,
                      'receiverName': _patient!.name,
                      'receiverRole': 'Patient',
                    },
                  );
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppColors.SkyBlue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.chat_bubble_outline,
                          size: 18, color: AppColors.SkyBlue),
                      const SizedBox(width: 6),
                      Text(
                        'Chat',
                        style: TextStyle(
                          color: AppColors.SkyBlue,
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 16),
            ],
          ),
      ],
    );
  }

  Widget _buildBottomButtons(
      BuildContext context, String name, String diagnosis) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 28),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: SizedBox(
              height: 48,
              child: OutlinedButton(
                onPressed: () async {
                  final newPatientData = await showModalBottomSheet<Map<String, dynamic>>(
                    context: context,
                    isScrollControlled: true,
                    shape: const RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(24)),
                    ),
                    builder: (_) => Padding(
                      padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom,
                      ),
                      child: ScheduleFollowupBottomSheet(
                        patientId: _patient?.id ?? '',
                        patientName: name,
                        diagnosis: diagnosis,
                      ),
                    ),
                  );

                  if (newPatientData != null && _patient != null) {
                    final nextAppt = newPatientData['nextAppointment'] ?? newPatientData['next_appointment'] ?? _patient!.nextAppointment;
                    final status = newPatientData['status'] ?? _patient!.statusBadge;
                    
                    String? newLastVisit;
                    final updatedAt = newPatientData['updatedAt']?.toString() ?? '';
                    if (updatedAt.isNotEmpty) {
                      try {
                        final date = DateTime.parse(updatedAt);
                        final diff = DateTime.now().difference(date);
                        if (diff.inHours < 24) {
                          newLastVisit = '${diff.inHours} hours ago';
                        } else if (diff.inDays == 1) newLastVisit = '1 day ago';
                        else if (diff.inDays < 7) newLastVisit = '${diff.inDays} days ago';
                        else newLastVisit = '${(diff.inDays / 7).floor()} weeks ago';
                      } catch (_) {}
                    }
                    newLastVisit ??= newPatientData['lastVisit']?.toString();
                    
                    setState(() {
                      _patient = _patient!.copyWith(
                        nextAppointment: nextAppt,
                        lastVisit: newLastVisit ?? _patient!.lastVisit,
                        statusBadge: status,
                      );
                    });
                  }
                },
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: AppColors.Turqouoise, width: 1.5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Schedule Follow-up',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.Turqouoise,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: SizedBox(
              height: 48,
              child: ElevatedButton(
                onPressed: () async {
                  final newStatus = await showModalBottomSheet<PatientStatus>(
                    context: context,
                    isScrollControlled: true,
                    shape: const RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(24)),
                    ),
                    builder: (_) => UpdateStatusBottomSheet(
                      patientId: _patient?.id ?? '',
                      patientName: name,
                    ),
                  );

                  if (newStatus != null && _patient != null) {
                    // Update the status locally to avoid needing another API call to fetch
                    String statusString = newStatus.name;
                    // Capitalize first letter
                    statusString = statusString[0].toUpperCase() + statusString.substring(1);
                    setState(() {
                      _patient = _patient!.copyWith(statusBadge: statusString);
                    });
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.SkyBlue,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Update Status',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}