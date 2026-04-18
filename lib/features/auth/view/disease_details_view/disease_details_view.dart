import 'package:dermalyze/features/auth/view/home/doctor/data/repositories/clinical_resources_repository.dart';
import 'package:flutter/material.dart';

class DiseaseDetailsView extends StatefulWidget {
  final String diseaseName;
  const DiseaseDetailsView({super.key, required this.diseaseName});

  @override
  State<DiseaseDetailsView> createState() => _DiseaseDetailsViewState();
}

class _DiseaseDetailsViewState extends State<DiseaseDetailsView> {
  final ClinicalResourcesRepository _repo = ClinicalResourcesRepository();
  bool _isLoading = true;
  Map<String, dynamic>? _disease;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchDetails();
  }

  Future<void> _fetchDetails() async {
    try {
      final diseases = await _repo.getDiseasesLibrary();
      final disease = diseases.firstWhere(
        (d) => d['name'].toString().toLowerCase().contains(widget.diseaseName.toLowerCase()),
        orElse: () => {},
      );

      if (mounted) {
        setState(() {
          if (disease.isEmpty) {
            _error = "Disease details not found.";
          } else {
            _disease = disease;
          }
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = "Failed to load disease details.";
          _isLoading = false;
        });
      }
    }
  }

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
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.diseaseName,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      const Text(
                        "Complete Information",
                        style: TextStyle(color: Colors.grey, fontSize: 13),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          /// BODY
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _error != null
                    ? Center(child: Text(_error!, style: const TextStyle(color: Colors.grey)))
                    : _buildContent(),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    final d = _disease!;
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        if (d['image'] != null)
          Container(
            height: 200,
            width: double.infinity,
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              image: DecorationImage(
                image: NetworkImage(d['image']),
                fit: BoxFit.cover,
              )
            ),
          ),
          
        /// OVERVIEW CARD
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                d['description'] ?? 'No description available.',
                style: TextStyle(fontSize: 15, color: Theme.of(context).colorScheme.onSurface, height: 1.5),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                       color: Theme.of(context).cardColor,
                       borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      d['type'] ?? 'Condition',
                      style: const TextStyle(color: Color(0xFF894B00), fontSize: 12),
                    ),
                  )
                ],
              )
            ],
          ),
        ),

        const SizedBox(height: 16),

        /// SYMPTOMS CARD
        if (d['symptoms'] != null && (d['symptoms'] as List).isNotEmpty)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.info_outline, color: Color(0xFF10B981)),
                    const SizedBox(width: 8),
                    Text("Symptoms", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Theme.of(context).colorScheme.onSurface)),
                  ]
                ),
                const SizedBox(height: 12),
                ...List.generate((d['symptoms'] as List).length, (index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("• ", style: TextStyle(fontSize: 16, color: Colors.grey)),
                        Expanded(
                          child: Text(d['symptoms'][index].toString(), style: TextStyle(fontSize: 14, color: Theme.of(context).colorScheme.onSurfaceVariant)),
                        )
                      ],
                    ),
                  );
                }),
              ],
            ),
          ),
          
        const SizedBox(height: 16),
        
        /// PATTERN CARD
        if (d['pattern'] != null)
           Container(
             padding: const EdgeInsets.all(16),
             decoration: BoxDecoration(
               color: Theme.of(context).cardColor,
               borderRadius: BorderRadius.circular(16),
               border: Border.all(color: const Color(0xFF818CF8)),
             ),
             child: Column(
               crossAxisAlignment: CrossAxisAlignment.start,
               children: [
                 Row(
                   children: const [
                     Icon(Icons.pattern, color: Color(0xFF4338CA)),
                     SizedBox(width: 8),
                     Text("Visual Pattern", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF312E81))),
                   ],
                 ),
                 const SizedBox(height: 8),
                 Text(d['pattern'], style: const TextStyle(color: Color(0xFF3730A3), fontSize: 14)),
               ]
             )
           )

      ],
    );
  }
}

