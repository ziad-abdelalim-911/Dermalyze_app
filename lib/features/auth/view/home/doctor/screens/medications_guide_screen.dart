import 'dart:async';
import 'package:dermalyze/core/constants/app_colors.dart';
import 'package:dermalyze/features/auth/view/home/doctor/data/repositories/clinical_resources_repository.dart';
import 'package:flutter/material.dart';

class MedicationsGuideScreen extends StatefulWidget {
  const MedicationsGuideScreen({super.key});

  @override
  State<MedicationsGuideScreen> createState() => _MedicationsGuideScreenState();
}

class _MedicationsGuideScreenState extends State<MedicationsGuideScreen> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final ClinicalResourcesRepository _repo = ClinicalResourcesRepository();

  List<Map<String, dynamic>> _filteredMedications = [];
  bool _isLoading = true;
  bool _isFetchingMore = false;
  bool _hasMore = true;
  int _currentPage = 1;
  static const int _limit = 20;
  Timer? _debounce;
  String _currentQuery = '';

  @override
  void initState() {
    super.initState();
    _loadData(isRefresh: true);
    _searchController.addListener(_onSearch);
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
      if (!_isFetchingMore && _hasMore && !_isLoading) {
        _loadData(isRefresh: false);
      }
    }
  }

  Future<void> _loadData({required bool isRefresh}) async {
    if (isRefresh) {
      setState(() {
        _isLoading = true;
        _currentPage = 1;
        _hasMore = true;
      });
    } else {
      setState(() {
        _isFetchingMore = true;
      });
    }

    final data = await _repo.getMedicationsGuide(
      query: _currentQuery,
      page: _currentPage,
      limit: _limit,
    );

    if (mounted) {
      setState(() {
        if (isRefresh) {
          _filteredMedications = data;
        } else {
          _filteredMedications.addAll(data);
        }
        
        // If we got less than the limit, we've reached the end
        if (data.length < _limit) {
          _hasMore = false;
        } else {
          _currentPage++;
        }

        _isLoading = false;
        _isFetchingMore = false;
      });
    }
  }

  void _onSearch() {
    if (_currentQuery == _searchController.text) return;
    
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (mounted) {
        _currentQuery = _searchController.text;
        _loadData(isRefresh: true);
      }
    });
  }

  Color _getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'corticosteroid': return const Color(0xFFC084FC); // Purple
      case 'antihistamine': return const Color(0xFF60A5FA); // Blue
      case 'immunosuppressant': return const Color(0xFFFB923C); // Orange
      case 'antifungal': return const Color(0xFF34D399); // Green
      case 'retinoid': return const Color(0xFFF472B6); // Pink
      default: return const Color(0xFF9CA3AF); // Gray
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = Theme.of(context).cardColor;
    final inputBg = isDark ? const Color(0xFF1E293B) : Colors.white;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: CustomScrollView(
        controller: _scrollController,
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
                    hintText: 'Search by drug name, ingredient, or category...',
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
          if (_isLoading && _filteredMedications.isEmpty)
            SliverToBoxAdapter(
               child: Center(child: Padding(padding: const EdgeInsets.all(40), child: CircularProgressIndicator(color: AppColors.Turqouoise))),
            )
          else if (_filteredMedications.isEmpty)
            const SliverToBoxAdapter(
               child: Center(child: Padding(padding: EdgeInsets.all(40), child: Text('No medications found'))),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.only(left: 20, right: 20, bottom: 10),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final med = _filteredMedications[index];
                    return _buildMedicationCard(med);
                  },
                  childCount: _filteredMedications.length,
                ),
              ),
            ),
            
          if (_isFetchingMore)
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.only(bottom: 40, top: 10),
                child: Center(
                  child: SizedBox(
                    width: 30, 
                    height: 30, 
                    child: CircularProgressIndicator(strokeWidth: 3, color: AppColors.Turqouoise)
                  )
                ),
              ),
            )
          else
            const SliverToBoxAdapter(child: SizedBox(height: 40)),
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
                child: const Icon(Icons.medication, color: Colors.white, size: 32),
              ),
              const SizedBox(height: 12),
              const Text(
                'Medications Guide',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Dermatology Drug Database',
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

  Widget _buildMedicationCard(Map<String, dynamic> med) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    Color catColor = _getCategoryColor(med['category'] as String? ?? '');
    
    return GestureDetector(
      onTap: () => _showMedicationDetails(context, med, catColor),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    med['name'] as String? ?? 'Unknown',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black87),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const Icon(Icons.chevron_right, color: Colors.grey, size: 20),
              ],
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: catColor.withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                med['category'] as String? ?? 'General',
                style: TextStyle(color: catColor, fontSize: 11, fontWeight: FontWeight.w600),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Divider(height: 1, color: isDark ? Colors.white24 : const Color(0xFFF3F4F6)),
            ),
            _buildInfoRow('Active Ingredient', med['activeIngredient'] as String? ?? 'N/A'),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 100,
          child: Text(
            label,
            style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            value,
            style: TextStyle(color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black87, fontSize: 12),
          ),
        ),
      ],
    );
  }

  void _showMedicationDetails(BuildContext context, Map<String, dynamic> med, Color catColor) {
    showDialog(
      context: context,
      barrierColor: const Color(0xFF1E3A8A).withOpacity(0.85), // Dark blue overlay
      builder: (BuildContext ctx) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.all(20),
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF4A90E2), Color(0xFF4ECDC4)],
                    ),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(24),
                      topRight: Radius.circular(24),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              med['name'] as String? ?? 'Unknown',
                              style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                          ),
                          GestureDetector(
                            onTap: () => Navigator.pop(ctx),
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: Theme.of(context).cardColor.withOpacity(0.3),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.close, color: Colors.white, size: 18),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Theme.of(context).cardColor.withOpacity(0.5)),
                        ),
                        child: Text(
                          med['category'] as String? ?? 'General',
                          style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w500),
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Content
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildDetailSection(
                        icon: Icons.science,
                        iconColor: const Color(0xFF4A90E2),
                        title: 'Active Ingredient',
                        content: med['activeIngredient'] as String? ?? 'N/A',
                        bgColor: const Color(0xFFEFF6FF),
                        borderColor: const Color(0xFFBFDBFE),
                      ),
                      const SizedBox(height: 16),
                      _buildDetailSection(
                        icon: Icons.info_outline,
                        iconColor: const Color(0xFF4A90E2),
                        title: 'Description',
                        content: med['description'] as String? ?? 'N/A',
                        bgColor: const Color(0xFFEFF6FF),
                        borderColor: const Color(0xFFBFDBFE),
                      ),
                      const SizedBox(height: 16),
                      _buildDetailSection(
                        icon: Icons.check_circle_outline,
                        iconColor: const Color(0xFF4A90E2),
                        title: 'Common Uses',
                        content: (med['uses'] as List<dynamic>?)?.join(', ') ?? 'N/A',
                        bgColor: const Color(0xFFEFF6FF),
                        borderColor: const Color(0xFFBFDBFE),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDetailSection({required IconData icon, required Color iconColor, required String title, required String content, required Color bgColor, required Color borderColor}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: iconColor, size: 18),
            const SizedBox(width: 8),
            Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: borderColor),
          ),
          child: Text(
            content,
            style: const TextStyle(fontSize: 14, color: Color(0xFF1E2D3D), height: 1.4),
          ),
        ),
      ],
    );
  }
}
