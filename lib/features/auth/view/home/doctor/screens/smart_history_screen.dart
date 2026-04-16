import 'package:dermalyze/core/constants/app_colors.dart';
import 'package:dermalyze/features/auth/view/home/doctor/data/repositories/clinical_resources_repository.dart';
import 'package:flutter/material.dart';

class SmartHistoryScreen extends StatefulWidget {
  const SmartHistoryScreen({super.key});

  @override
  State<SmartHistoryScreen> createState() => _SmartHistoryScreenState();
}

class _SmartHistoryScreenState extends State<SmartHistoryScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;
  Map<String, dynamic>? _insights;
  final ClinicalResourcesRepository _repo = ClinicalResourcesRepository();

  bool _hasSearched = false;

  void _performSearch(String query) async {
    if (query.trim().isEmpty) return;

    setState(() {
      _isSearching = true;
      _hasSearched = true;
      _insights = null;
      _searchController.text = query;
    });

    final data = await _repo.getSmartHistoryInsights(query.trim());

    if (mounted) {
      setState(() {
        _isSearching = false;
        _insights = data;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFC),
      body: CustomScrollView(
        slivers: [
          _buildHeaderSliver(),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Column(
                children: [
                  _buildSearchCard(),
                  const SizedBox(height: 20),
                  if (!_hasSearched) _buildEmptyState(),
                  if (_isSearching)
                    Padding(
                      padding: const EdgeInsets.only(top: 50),
                      child: CircularProgressIndicator(color: AppColors.Turqouoise),
                    ),
                  if (_hasSearched && !_isSearching && _insights != null)
                    _buildResults(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderSliver() {
    return SliverAppBar(
      expandedHeight: 220.0,
      floating: false,
      pinned: true,
      backgroundColor: const Color(0xFF4FA8D2),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => Navigator.pop(context),
      ),
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF4A90E2), Color(0xFF4ECDC4)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 40),
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.25),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: Colors.white.withOpacity(0.5), width: 1),
                ),
                child: const Icon(Icons.psychology, color: Colors.white, size: 36),
              ),
              const SizedBox(height: 12),
              const Text(
                'My Smart History',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'AI-Powered Treatment Insights',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: const [
              Icon(Icons.radar, color: Color(0xFF4A90E2), size: 20),
              SizedBox(width: 8),
              Text(
                'Search My Past Treatments',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
              ),
            ],
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Enter disease name (e.g., Psoriasis)',
              hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
              prefixIcon: const Icon(Icons.search, color: Colors.grey),
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(vertical: 14),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFF4A90E2)),
              ),
            ),
            onSubmitted: _performSearch,
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton.icon(
              onPressed: () => _performSearch(_searchController.text),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF5BAED0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              icon: const Icon(Icons.search, color: Colors.white, size: 20),
              label: const Text(
                'Search My History',
                style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w600),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFEFF6FF),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFBFDBFE)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'How it works:',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF1E3A8A)),
                ),
                SizedBox(height: 4),
                Text(
                  'This feature analyzes only YOUR patient history to show which medications worked best for specific diseases you\'ve treated.',
                  style: TextStyle(fontSize: 13, color: Color(0xFF1E3A8A), height: 1.4),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    final chips = ['Psoriasis', 'Atopic Dermatitis', 'Acne Vulgaris', 'Seborrheic Dermatitis'];
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: Color(0xFF5BAED0),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.psychology, color: Colors.white, size: 36),
          ),
          const SizedBox(height: 20),
          const Text(
            'AI-Powered Insights',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'Search for a disease to discover\nwhich medications worked best\nin YOUR practice.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey, fontSize: 14, height: 1.4),
          ),
          const SizedBox(height: 24),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFEFF6FF),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFBFDBFE)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Try searching for:',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF1E3A8A)),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: chips.map((c) => GestureDetector(
                    onTap: () => _performSearch(c),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: const Color(0xFF93C5FD)),
                      ),
                      child: Text(
                        c,
                        style: const TextStyle(color: Color(0xFF3B82F6), fontSize: 13),
                      ),
                    ),
                  )).toList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResults() {
    final drugName = _insights!['bestPerformingDrug']['name'];
    final drugRecovery = _insights!['bestPerformingDrug']['avgRecovery'];
    final casesUsed = _insights!['bestPerformingDrug']['casesUsed'];
    final patients = _insights!['patientEvidence'] as List;

    return Column(
      children: [
        // My Success Insights
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF3A8FA8), Color(0xFF4ECDC4)],
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                   Container(
                     padding: const EdgeInsets.all(6),
                     decoration: BoxDecoration(
                       color: Colors.white.withOpacity(0.2),
                       borderRadius: BorderRadius.circular(8),
                     ),
                     child: const Icon(Icons.trending_up, color: Colors.white, size: 20),
                   ),
                   const SizedBox(width: 12),
                   Column(
                     crossAxisAlignment: CrossAxisAlignment.start,
                     children: [
                       const Text(
                         'My Success Insights',
                         style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                       ),
                       Text(
                         'For: ${_insights!['disease']}',
                         style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 13),
                       ),
                     ],
                   ),
                ],
              ),
              const SizedBox(height: 20),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.white.withOpacity(0.3)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Total Patients Treated:',
                      style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 13),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${_insights!['totalPatientsTreated']} Patients',
                      style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        
        // Best Performing Drug
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 15,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFF9500),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.military_tech, color: Colors.white, size: 20),
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Best Performing Drug',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Based on your patient outcomes',
                        style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFFDF5),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFFFEAA7)),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.medication, color: Color(0xFFFF5722), size: 24),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                drugName,
                                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                'Used in $casesUsed case(s)',
                                style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                              ),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              '$drugRecovery%',
                              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF00C853)),
                            ),
                            Text(
                              'Avg\nRecovery',
                              textAlign: TextAlign.right,
                              style: TextStyle(fontSize: 10, color: Colors.grey.shade500),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: drugRecovery / 100,
                        backgroundColor: Colors.grey.shade200,
                        color: const Color(0xFF00C853),
                        minHeight: 8,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        // Patient Evidence
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 15,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: const [
                  Icon(Icons.person_outline, color: Color(0xFF4A90E2), size: 22),
                  SizedBox(width: 8),
                  Text(
                    'Patient Evidence',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                '${patients.length} patient(s) treated with $drugName',
                style: TextStyle(fontSize: 13, color: Colors.grey.shade500),
              ),
              const SizedBox(height: 16),
              ...patients.map((p) => _buildPatientEvidenceCard(p)).toList(),
            ],
          ),
        ),
        const SizedBox(height: 20),

        // Quick Statistics
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF4A90E2), Color(0xFF5BAED0)],
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Quick Statistics',
                style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.white.withOpacity(0.3)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Highest Recovery',
                            style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 11),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${_insights!['highestRecovery']}%',
                            style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                         color: Colors.white.withOpacity(0.15),
                         borderRadius: BorderRadius.circular(12),
                         border: Border.all(color: Colors.white.withOpacity(0.3)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Average Recovery',
                            style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 11),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${_insights!['averageRecovery']}%',
                            style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPatientEvidenceCard(Map<String, dynamic> patient) {
    bool isBest = patient['recoveryRate'] > 92;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isBest ? const Color(0xFF6EE7B7) : const Color(0xFF93C5FD)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
               Container(
                 width: 40,
                 height: 40,
                 decoration: const BoxDecoration(
                   color: Color(0xFF5BAED0),
                   shape: BoxShape.circle,
                 ),
                 child: Center(
                   child: Text(
                     _getInitials(patient['patientName']),
                     style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                   ),
                 ),
               ),
               const SizedBox(width: 12),
               Expanded(
                 child: Column(
                   crossAxisAlignment: CrossAxisAlignment.start,
                   children: [
                     Text(
                       patient['patientName'],
                       style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                     ),
                     Text(
                       patient['treatmentDuration'],
                       style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                     ),
                   ],
                 ),
               ),
               Container(
                 padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                 decoration: BoxDecoration(
                   color: const Color(0xFFD1FAE5),
                   borderRadius: BorderRadius.circular(20),
                 ),
                 child: Text(
                   '${patient['recoveryRate']}%',
                   style: const TextStyle(color: Color(0xFF059669), fontSize: 12, fontWeight: FontWeight.bold),
                 ),
               ),
            ],
          ),
          const Padding(
             padding: EdgeInsets.symmetric(vertical: 12),
             child: Divider(height: 1, color: Color(0xFFF3F4F6)),
          ),
          Row(
            children: [
              const Icon(Icons.link, color: Color(0xFF4A90E2), size: 16),
              const SizedBox(width: 8),
              RichText(
                text: TextSpan(
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
                  children: [
                    const TextSpan(text: 'Treated with: '),
                    TextSpan(
                      text: patient['drugUsed'],
                      style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (isBest) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFFECFDF5),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFF6EE7B7)),
              ),
              child: Row(
                children: const [
                  Icon(Icons.military_tech, color: Color(0xFF10B981), size: 16),
                  SizedBox(width: 6),
                  Text(
                    'Best Result',
                    style: TextStyle(color: Color(0xFF059669), fontSize: 12, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
          ]
        ],
      ),
    );
  }

  String _getInitials(String name) {
    List<String> p = name.split(' ');
    if (p.isEmpty) return '?';
    if (p.length == 1) return p[0][0].toUpperCase();
    return '${p[0][0]}${p[1][0]}'.toUpperCase();
  }
}
