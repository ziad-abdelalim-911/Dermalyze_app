import 'package:dermalyze/core/storage/token_storage.dart';
import 'package:dermalyze/features/auth/view/medication_list/medication_model.dart';
import 'package:dermalyze/features/auth/view/medication_list/medication_repository.dart';
import 'package:dermalyze/features/auth/view/medication_list/widgets/medication_card.dart';
import 'package:dermalyze/features/auth/view/medication_list/widgets/medication_reminders_card.dart';
import 'package:flutter/material.dart';

class MedicationListView extends StatefulWidget {
  const MedicationListView({super.key});

  @override
  State<MedicationListView> createState() => _MedicationListViewState();
}

class _MedicationListViewState extends State<MedicationListView> {
  final _repo = MedicationRepository();
  final _tokenStorage = TokenStorage();

  List<MedicationModel> _activeMedications = [];
  List<MedicationModel> _completedMedications = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadMedications();
  }

  Future<void> _loadMedications() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      // جيب الـ patient ID من الـ storage
      final user = await _tokenStorage.getUser();
      final patientId = user?['_id'] ?? user?['id'] ?? '';

      if (patientId.isEmpty) {
        setState(() {
          _error = 'Could not identify patient. Please log in again.';
          _isLoading = false;
        });
        return;
      }

      final raw = await _repo.getMedications(patientId);
      final all = raw
          .map((m) => m == null ? null : _fromApi(m as Map<String, dynamic>))
          .whereType<MedicationModel>()
          .toList();

      setState(() {
        _activeMedications = all.where((m) => !m.isCompleted).toList();
        _completedMedications = all.where((m) => m.isCompleted).toList();
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  /// يحوّل الـ Map الجاية من الـ API لـ MedicationModel
  MedicationModel _fromApi(Map<String, dynamic> m) {
    final status = (m['status'] ?? '').toString().toLowerCase();
    final isCompleted = status == 'completed' || status == 'done';

    return MedicationModel(
      name: m['name'] ?? '—',
      dose: m['dosage'] ?? m['dose'] ?? '—',
      frequency: m['frequency'] ?? '—',
      duration: m['duration'] ?? '—',
      whenToTake: m['whenToTake'] ?? m['instructions'] ?? '—',
      warning: m['notes'] ?? m['warning'] ?? '',
      startDate: m['startDate'] ?? m['createdAt'] ?? '—',
      endDate: m['endDate'] ?? '—',
      isCompleted: isCompleted,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Theme.of(context).iconTheme.color),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'My Medications',
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurface,
            fontSize: 17,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh, color: Theme.of(context).iconTheme.color),
            onPressed: _loadMedications,
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? _buildError()
              : _buildContent(),
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
              onPressed: _loadMedications,
              icon: const Icon(Icons.refresh),
              label: const Text('Try Again'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent() {
    final hasNone = _activeMedications.isEmpty && _completedMedications.isEmpty;

    if (hasNone) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.medication_outlined, size: 64, color: Colors.grey.shade300),
            const SizedBox(height: 16),
            const Text(
              'No medications prescribed yet',
              style: TextStyle(color: Colors.grey, fontSize: 15),
            ),
          ],
        ),
      );
    }

    return ListView(
      children: [
        const SizedBox(height: 16),

        if (_activeMedications.isNotEmpty) ...[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Active Medications',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Theme.of(context).colorScheme.onSurface),
            ),
          ),
          ..._activeMedications.map((e) => MedicationCard(medication: e)),
          const SizedBox(height: 16),
        ],

        if (_completedMedications.isNotEmpty) ...[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Completed',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Theme.of(context).colorScheme.onSurface),
            ),
          ),
          ..._completedMedications.map((e) => MedicationCard(medication: e)),
          const SizedBox(height: 16),
        ],

        const ImportantRemindersCard(),
        const SizedBox(height: 24),
      ],
    );
  }
}
