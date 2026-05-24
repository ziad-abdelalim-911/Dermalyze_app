import 'package:dermalyze/core/constants/app_colors.dart';
import 'package:dermalyze/features/auth/view/home/doctor/data/repositories/clinical_resources_repository.dart';
import 'package:flutter/material.dart';

class DiseasesLibraryScreen extends StatefulWidget {
  const DiseasesLibraryScreen({super.key});

  @override
  State<DiseasesLibraryScreen> createState() => _DiseasesLibraryScreenState();
}

class _DiseasesLibraryScreenState extends State<DiseasesLibraryScreen> {
  final TextEditingController _searchController = TextEditingController();
  final ClinicalResourcesRepository _repo = ClinicalResourcesRepository();

  List<Map<String, dynamic>> _allDiseases = [];
  List<Map<String, dynamic>> _filteredDiseases = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
    _searchController.addListener(_onSearch);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    final data = await _repo.getDiseasesLibrary();
    if (mounted) {
      setState(() {
        _allDiseases = data;
        _filteredDiseases = data;
        _isLoading = false;
      });
    }
  }

  void _onSearch() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredDiseases = _allDiseases.where((disease) {
        final tags = (disease['tags'] as List? ?? []);
        return (disease['name'] as String? ?? '').toLowerCase().contains(query) ||
               (disease['type'] as String? ?? '').toLowerCase().contains(query) ||
               tags.any((tag) => tag.toString().toLowerCase().contains(query));
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final inputBg = isDark ? const Color(0xFF1E293B) : Colors.white;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: CustomScrollView(
        slivers: [
          _buildHeaderSliver(),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Container(
                decoration: BoxDecoration(
                  color: inputBg,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: TextField(
                  controller: _searchController,
                  style: TextStyle(color: isDark ? Colors.white : Colors.black87),
                  decoration: InputDecoration(
                    hintText: 'Search by disease name, tag, or...',
                    hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
                    prefixIcon: const Icon(Icons.search, color: Colors.grey),
                     border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ),
            ),
          ),
          if (_isLoading)
            SliverToBoxAdapter(
               child: Center(child: Padding(padding: const EdgeInsets.all(40), child: CircularProgressIndicator(color: AppColors.Turqouoise))),
            )
          else if (_filteredDiseases.isEmpty)
            const SliverToBoxAdapter(
               child: Center(child: Padding(padding: EdgeInsets.all(40), child: Text('No diseases found'))),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.only(left: 20, right: 20, bottom: 40),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final disease = _filteredDiseases[index];
                    return _buildDiseaseCard(disease);
                  },
                  childCount: _filteredDiseases.length,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildHeaderSliver() {
    return SliverAppBar(
      expandedHeight: 200.0,
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
              const SizedBox(height: 30),
              Container(
                 width: 60,
                 height: 60,
                 decoration: BoxDecoration(
                   color: Theme.of(context).cardColor.withOpacity(0.25),
                   borderRadius: BorderRadius.circular(16),
                   border: Border.all(color: Colors.white.withOpacity(0.5), width: 1),
                 ),
                 child: const Icon(Icons.library_books, color: Colors.white, size: 30),
              ),
              const SizedBox(height: 12),
              const Text(
                'Diseases Library',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Dermatology Reference Guide',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDiseaseCard(Map<String, dynamic> disease) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: () => _showDiseaseDetails(context, disease),
      child: Container(
        margin: const EdgeInsets.only(bottom: 20),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Stack
            Stack(
              children: [
                SizedBox(
                  height: 160,
                  width: double.infinity,
                  child: disease['imageUrl'] != null && disease['imageUrl'].toString().isNotEmpty
                    ? Image.network(
                        disease['imageUrl'] as String,
                        fit: BoxFit.cover,
                        errorBuilder: (ctx, err, stack) => Container(
                          color: Colors.grey.shade300,
                          child: const Center(child: Icon(Icons.image_not_supported, color: Colors.grey)),
                        ),
                      )
                    : Container(
                        color: Colors.grey.shade300,
                        child: const Center(child: Icon(Icons.image_not_supported, color: Colors.grey)),
                      ),
                ),
                Positioned(
                  top: 12,
                  right: 12,
                  child: Row(
                    children: (disease['tags'] as List? ?? []).map((tag) {
                      return Container(
                        margin: const EdgeInsets.only(left: 6),
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor.withOpacity(0.9),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          tag.toString(),
                          style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Theme.of(context).cardColor),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
            // Content
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        disease['name'] as String? ?? 'Unknown',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black87),
                      ),
                      const Icon(Icons.chevron_right, color: Colors.grey, size: 20),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    disease['type'] as String? ?? '',
                    style: TextStyle(fontSize: 13, color: Colors.grey.shade500),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Common Clinical Symptoms:',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 6),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: (disease['symptoms'] as List? ?? []).take(2).map((sym) {
                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: isDark ? Colors.white12 : const Color(0xFFF3F4F6),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          sym.toString(),
                          style: TextStyle(fontSize: 11, color: isDark ? Colors.grey.shade300 : Colors.grey.shade700),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDiseaseDetails(BuildContext context, Map<String, dynamic> disease) {
    showDialog(
      context: context,
      barrierColor: const Color(0xFF1E3A8A).withOpacity(0.85),
      builder: (BuildContext ctx) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.all(16),
          child: ConstrainedBox(
             constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.85),
             child: Container(
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(24),
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Header Image with close button
                    Stack(
                      children: [
                        SizedBox(
                          height: 200,
                          width: double.infinity,
                          child: disease['imageUrl'] != null && disease['imageUrl'].toString().isNotEmpty
                            ? Image.network(
                                disease['imageUrl'] as String,
                                fit: BoxFit.cover,
                                errorBuilder: (ctx, err, stack) => Container(
                                  color: Colors.grey.shade300,
                                ),
                              )
                            : Container(color: Colors.grey.shade300),
                        ),
                        // Dark gradient overlay for text readability
                        Positioned.fill(
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [Colors.transparent, Colors.black.withOpacity(0.6)],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          top: 16,
                          right: 16,
                          child: GestureDetector(
                            onTap: () => Navigator.pop(ctx),
                            child: Container(
                              padding: EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: Theme.of(context).cardColor,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.close, color: Colors.black87, size: 16),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 16,
                          left: 16,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                disease['name'] as String? ?? 'Unknown',
                                style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                '(${disease['type'] as String? ?? ''})',
                                style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 14),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    
                    // Tags Strip
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                           colors: [Color(0xFF4A90E2), Color(0xFF4ECDC4)],
                        ),
                      ),
                      child: Row(
                         children: (disease['tags'] as List? ?? []).map((tag) {
                           final tagStr = tag.toString();
                           return Container(
                             margin: const EdgeInsets.only(right: 8),
                             padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                             decoration: BoxDecoration(
                               color: Theme.of(context).cardColor.withOpacity(0.25),
                               borderRadius: BorderRadius.circular(16),
                               border: Border.all(color: Colors.white.withOpacity(0.5)),
                             ),
                             child: Row(
                               children: [
                                 if (tagStr == 'Moderate' || tagStr == 'Common')
                                    const Padding(
                                      padding: EdgeInsets.only(right: 4),
                                      child: Icon(Icons.info_outline, color: Colors.white, size: 14),
                                    ),
                                 Text(
                                   tagStr,
                                   style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w500),
                                 ),
                               ],
                             ),
                           );
                         }).toList(),
                      ),
                    ),
                    
                    // Main Content
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Clinical Description
                          Row(
                            children: const [
                              Icon(Icons.content_paste, color: Color(0xFF4A90E2), size: 18),
                              SizedBox(width: 8),
                              Text('Clinical Description', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Theme.of(context).cardColor, // Light blue box
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: const Color(0xFFBFDBFE)), // Light outline
                            ),
                            child: Text(
                              disease['description'] as String? ?? 'No description available.',
                              style: const TextStyle(fontSize: 14, height: 1.5, color: Color(0xFF1E3A8A)),
                            ),
                          ),
                          const SizedBox(height: 20),
            
                          // Common Clinical Symptoms
                          Row(
                            children: const [
                              Icon(Icons.info_outline, color: Color(0xFF4A90E2), size: 18),
                              SizedBox(width: 8),
                              Text('Common Clinical Symptoms', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                            ],
                          ),
                          const SizedBox(height: 12),
                          ...List.generate((disease['symptoms'] as List? ?? []).length, (index) {
                            final symptoms = disease['symptoms'] as List? ?? [];
                            return Container(
                               margin: const EdgeInsets.only(bottom: 10),
                               padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                               decoration: BoxDecoration(
                                 color: Theme.of(context).cardColor,
                                 borderRadius: BorderRadius.circular(12),
                                 border: Border.all(color: const Color(0xFFA5F3FC)),
                               ),
                               child: Row(
                                 children: [
                                   Container(
                                     width: 24,
                                     height: 24,
                                     decoration: const BoxDecoration(
                                       color: Color(0xFF5BAED0),
                                       shape: BoxShape.circle,
                                     ),
                                     child: Center(
                                       child: Text('${index + 1}', style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                                     ),
                                   ),
                                   const SizedBox(width: 12),
                                   Expanded(
                                      child: Text(
                                        symptoms[index].toString(),
                                        style: const TextStyle(fontSize: 14, color: Color(0xFF134E4A)),
                                      ),
                                   ),
                                 ],
                               ),
                            );
                          }),
                          const SizedBox(height: 16),
            
                          // Visual Pattern Recognition
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Theme.of(context).cardColor, // Light purple background
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: const Color(0xFFE9D5FF)), // Purple outline
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: const [
                                    Icon(Icons.camera_alt, color: Color(0xFF9333EA), size: 16),
                                    SizedBox(width: 6),
                                    Text('Visual Pattern Recognition:', style: TextStyle(color: Color(0xFF7E22CE), fontWeight: FontWeight.bold, fontSize: 13)),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  disease['pattern'] as String? ?? 'N/A',
                                  style: const TextStyle(fontSize: 13, height: 1.4, color: Color(0xFF6B21A8)),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
