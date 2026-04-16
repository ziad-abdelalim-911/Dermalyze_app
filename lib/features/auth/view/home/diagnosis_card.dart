import 'package:dermalyze/features/auth/view/disease_details_view/disease_details_view.dart';
import 'package:flutter/material.dart';

class DiagnosisCard extends StatelessWidget {
  final String diagnosis;
  final String quality;

  const DiagnosisCard({
    super.key,
    this.diagnosis = '—',
    this.quality = '—',
  });

  Color _qualityColor() {
    switch (quality.toLowerCase()) {
      case 'high':
        return Colors.green;
      case 'medium':
        return Colors.amber;
      case 'low':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const DiseaseDetailsView(diseaseName: 'Skin Condition')),
          );
        },
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 10,
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Expanded(
                    child: Text(
                      "Current Diagnosis",
                      style: TextStyle(color: Colors.grey, fontSize: 13),
                    ),
                  ),
                  if (quality != '—')
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: _qualityColor()),
                      ),
                      child: Text(
                        "Quality: $quality",
                        style:
                            TextStyle(color: _qualityColor(), fontSize: 12),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                diagnosis,
                style: const TextStyle(
                  fontSize: 18,
                  color: Color(0xFF3B82F6),
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 6),
              const Center(
                child: Text(
                  "Tap to view disease details",
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
