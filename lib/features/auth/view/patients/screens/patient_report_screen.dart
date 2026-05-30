import 'package:dermalyze/features/auth/view/patients/data/reports_repository.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class PatientReportScreen extends StatefulWidget {
  final String? patientId;

  const PatientReportScreen({super.key, this.patientId});

  @override
  State<PatientReportScreen> createState() => _PatientReportScreenState();
}

class _PatientReportScreenState extends State<PatientReportScreen> {
  final ReportsRepository _repo = ReportsRepository();
  bool _isLoading = true;
  Map<String, dynamic>? _reportData;

  @override
  void initState() {
    super.initState();
    _loadReport();
  }

  Future<void> _loadReport() async {
    setState(() => _isLoading = true);
    final response = widget.patientId != null
        ? await _repo.getPatientReport(widget.patientId!)
        : await _repo.getMyReport();
    if (mounted) {
      setState(() {
        _reportData = response['data'] as Map<String, dynamic>?;
        _isLoading = false;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      appBar: AppBar(
        title: const Text('Patient Comprehensive Report', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 1,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _reportData == null
              ? const Center(child: Text('Failed to load report data.'))
              : _buildReportContent(),
    );
  }

  Widget _buildReportContent() {
    final patientName = _reportData!['patientName'] as String? ?? 'Unknown Patient';
    final diagnosis = _reportData!['diagnosis'] as String? ?? 'No Diagnosis';
    final recoveryProgress = _reportData!['recoveryProgress'] as num? ?? 0;
    final diseaseInfo = _reportData!['diseaseInfo'] as Map<String, dynamic>? ?? {};
    final medications = _reportData!['medications'] as List<dynamic>? ?? [];
    final latestAnalysis = _reportData!['latestAnalysis'] as Map<String, dynamic>?;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          // Header Section
          _buildCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Medical Report', style: TextStyle(color: Colors.grey.shade600, fontSize: 12, letterSpacing: 1)),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE0F2FE),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        '${recoveryProgress.toInt()}% Recovery',
                        style: const TextStyle(color: Color(0xFF0369A1), fontWeight: FontWeight.bold, fontSize: 12),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(patientName, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF111827))),
                const SizedBox(height: 4),
                Text('Diagnosis: $diagnosis', style: const TextStyle(fontSize: 16, color: Color(0xFF4B5563))),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Disease Info Section
          if (diseaseInfo.isNotEmpty)
            _buildCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle(Icons.coronavirus, 'Disease Information'),
                  const SizedBox(height: 12),
                  if (diseaseInfo['tags'] != null)
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: (diseaseInfo['tags'] as List).map((t) => Chip(
                        label: Text(t.toString(), style: const TextStyle(fontSize: 12, color: Color(0xFF1E40AF))),
                        backgroundColor: const Color(0xFFDBEAFE),
                        side: BorderSide.none,
                      )).toList(),
                    ),
                  const SizedBox(height: 16),
                  
                  if (diseaseInfo['about'] != null && diseaseInfo['about']['common_triggers'] != null) ...[
                    const Text('Common Triggers', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                    const SizedBox(height: 4),
                    ...((diseaseInfo['about']['common_triggers'] as List).map((t) => Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('• ', style: TextStyle(fontSize: 16, color: Colors.grey)),
                        Expanded(child: Text(t.toString(), style: TextStyle(color: Colors.grey.shade700))),
                      ],
                    ))),
                    const SizedBox(height: 12),
                  ],

                  if (diseaseInfo['current_symptoms'] != null) ...[
                    const Text('Current Symptoms', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                    const SizedBox(height: 4),
                    ...((diseaseInfo['current_symptoms'] as List).map((s) {
                      final sym = s as Map<String, dynamic>;
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('• ', style: TextStyle(fontSize: 16, color: Colors.grey)),
                          Expanded(child: Text('${sym['name']} - ${sym['severity']}', style: TextStyle(color: Colors.grey.shade700))),
                        ],
                      );
                    })),
                    const SizedBox(height: 12),
                  ],

                  if (diseaseInfo['treatment_plan'] != null) ...[
                    const Text('Treatment Plan', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                    const SizedBox(height: 4),
                    ...((diseaseInfo['treatment_plan'] as List).map((tp) {
                      final plan = tp as Map<String, dynamic>;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(plan['title'] ?? '', style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                            Text(plan['description'] ?? '', style: TextStyle(color: Colors.grey.shade700, fontSize: 13)),
                          ],
                        ),
                      );
                    })),
                  ],
                ],
              ),
            ),
          
          if (diseaseInfo.isNotEmpty) const SizedBox(height: 16),

          // Medications
          _buildCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionTitle(Icons.medication, 'Prescribed Medications'),
                const SizedBox(height: 12),
                if (medications.isEmpty)
                  Text('No medications prescribed.', style: TextStyle(color: Colors.grey.shade500)),
                ...medications.map((m) {
                  final med = m as Map<String, dynamic>;
                  return Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF9FAFB),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: const Color(0xFFE5E7EB)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.vaccines, color: Color(0xFF6B7280), size: 20),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('${med['name']} ${med['dosage']}', style: const TextStyle(fontWeight: FontWeight.bold)),
                              Text(med['frequency'] ?? '', style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Latest Analysis
          _buildCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionTitle(Icons.analytics, 'Latest AI Skin Scan'),
                const SizedBox(height: 12),
                if (latestAnalysis == null)
                  Text('No skin scan records available yet.', style: TextStyle(color: Colors.grey.shade500))
                else
                  Column(
                    children: [
                      if (latestAnalysis['imageUrl'] != null)
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: CachedNetworkImage(
                            imageUrl: latestAnalysis['imageUrl'],
                            width: double.infinity,
                            height: 200,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Container(
                              width: double.infinity,
                              height: 200,
                              color: Colors.grey.shade200,
                              child: const Center(child: CircularProgressIndicator()),
                            ),
                            errorWidget: (context, url, error) => Container(
                              width: double.infinity,
                              height: 200,
                              color: Colors.grey.shade200,
                              child: const Icon(Icons.image_not_supported, color: Colors.grey),
                            ),
                          ),
                        ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Scan Result', style: TextStyle(fontSize: 12, color: Colors.grey)),
                              Text(latestAnalysis['diagnosisLabel'] ?? 'Unknown', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFEF2F2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              latestAnalysis['severity'] ?? 'N/A',
                              style: const TextStyle(color: Color(0xFFDC2626), fontWeight: FontWeight.bold, fontSize: 12),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
              ],
            ),
          ),
          
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildCard({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _buildSectionTitle(IconData icon, String title) {
    return Row(
      children: [
        Icon(icon, color: const Color(0xFF3A8FA8), size: 20),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1F2937),
          ),
        ),
      ],
    );
  }
}
