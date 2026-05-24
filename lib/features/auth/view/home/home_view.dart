import 'package:dermalyze/core/constants/app_colors.dart';
import 'package:dermalyze/core/storage/token_storage.dart';
import 'package:dermalyze/features/auth/view/home/diagnosis_card.dart';
import 'package:dermalyze/features/auth/view/home/home_header.dart';
import 'package:dermalyze/features/auth/view/home/medication_list_card.dart';
import 'package:dermalyze/features/auth/view/home/patient_home_repository.dart';
import 'package:dermalyze/features/auth/view/home/recovery_progress_card.dart';
import 'dart:async';
import 'package:dermalyze/core/services/socket_service.dart' as dermalyze_socket;
import 'package:flutter/material.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final _tokenStorage = TokenStorage();
  final _repo = PatientHomeRepository();

  // بيانات المستخدم
  String _userName = '';
  String _patientId = '';

  // بيانات التشخيص
  String _diagnosis = '—';
  String _quality = '—';

  // نسبة التعافي
  double _recoveryRate = 0.0;

  // الأدوية
  List<Map<String, dynamic>> _medications = [];

  // آخر زيارة والزيارة الجاية
  String _lastCheckup = '—';
  String _nextVisit = '—';

  bool _isLoading = true;

  StreamSubscription? _socketSubscription;

  @override
  void initState() {
    super.initState();
    _loadAll();
    _listenToRealTimeUpdates();
  }

  void _listenToRealTimeUpdates() {
    _socketSubscription = dermalyze_socket.SocketService().profileStream.listen((data) {
      if (!mounted) return;
      setState(() {
        if (data.containsKey('nextAppointment') || data.containsKey('nextVisit')) {
          _nextVisit = data['nextAppointment'] ?? data['nextVisit'] ?? _nextVisit;
        }
        if (data.containsKey('lastVisit') || data.containsKey('lastCheckup')) {
          _lastCheckup = data['lastVisit'] ?? data['lastCheckup'] ?? _lastCheckup;
        }
        if (data.containsKey('diagnosis') || data.containsKey('currentDiagnosis')) {
          _diagnosis = data['diagnosis'] ?? data['currentDiagnosis'] ?? _diagnosis;
        }
        if (data.containsKey('status')) {
          // If status changes, you might update it here if displayed
        }
      });

      if (data.containsKey('message')) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(data['message']),
            backgroundColor: AppColors.SkyBlue,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _socketSubscription?.cancel();
    super.dispose();
  }

  Future<void> _loadAll() async {
    setState(() => _isLoading = true);
    try {
      // جيب بيانات المستخدم من الـ storage أولاً (سريعة)
      final user = await _tokenStorage.getUser();
      if (user != null) {
        _userName = user['name'] ?? '';
        _patientId = user['id'] ?? user['_id'] ?? '';
      }

      // جيب بيانات المريض من الـ API باستخدام الـ ID
      final profile = await _repo.getMyProfile(_patientId);

      if (profile.isNotEmpty) {
        _diagnosis = profile['diagnosis'] ?? profile['currentDiagnosis'] ?? '—';
        _quality = profile['quality'] ?? profile['recoveryQuality'] ?? '—';

        final recovery = profile['recoveryProgress'] ?? profile['recoveryRate'];
        if (recovery != null) {
          _recoveryRate = (recovery is int)
              ? recovery / 100.0
              : (recovery as double).clamp(0.0, 1.0);
        }

        _lastCheckup = profile['lastCheckup'] ?? profile['lastVisit'] ?? '—';
        _nextVisit = profile['nextVisit'] ?? profile['nextAppointment'] ?? '—';
      }

      // جيب الأدوية
      if (_patientId.isNotEmpty) {
        final meds = await _repo.getMyMedications(_patientId);
        _medications = meds
            .map((m) => m as Map<String, dynamic>)
            .toList();
      }
    } catch (_) {
      // في حالة error نفضل بالقيم الـ default
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SingleChildScrollView(
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: isDark ? null : AppColors.primaryGradient1,
          color: isDark ? Theme.of(context).scaffoldBackgroundColor : null,
        ),
        child: _isLoading
            ? const SizedBox(
                height: 400,
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              )
            : Column(
                children: [
                  HomeHeader(
                    userName: _userName.isNotEmpty ? _userName : 'Patient',
                    lastCheckup: _lastCheckup,
                    nextVisit: _nextVisit,
                  ),
                  const SizedBox(height: 16),
                  DiagnosisCard(
                    diagnosis: _diagnosis,
                    quality: _quality,
                  ),
                  const SizedBox(height: 16),
                  RecoveryProgressCard(
                    recoveryRate: _recoveryRate,
                  ),
                  const SizedBox(height: 16),
                  MedicationListCard(
                    medications: _medications,
                  ),
                  const SizedBox(height: 120),
                ],
              ),
      ),
    );
  }
}
