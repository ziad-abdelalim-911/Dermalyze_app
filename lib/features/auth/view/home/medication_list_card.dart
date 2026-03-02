import 'package:dermalyze/features/auth/view/login/Patient_SignUp.dart';
import 'package:dermalyze/features/auth/view/medication_list/medication_list_view.dart';
import 'package:flutter/material.dart';

class MedicationListCard extends StatelessWidget {
  const MedicationListCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => MedicationListView()),
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
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
              ),
            ],
          ),
          child: Column(
            children: [
              /// ===== Header
              Row(
                children: [
                  const Icon(
                    Icons.medication_outlined,
                    color: Color(0xFF3B82F6),
                  ),
                  const SizedBox(width: 8),
                  const Expanded(
                    child: Text(
                      "Medication List",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      "3 Active",
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              const _MedicationItem(
                title: "Hydrocortisone Cream 1%",
                subtitle: "Apply twice daily",
                tag: "Morning & Evening",
              ),
              SizedBox(height: 12),
              const _MedicationItem(
                title: "Cetirizine 10mg",
                subtitle: "1 tablet",
                tag: "Once daily at bedtime",
              ),
              SizedBox(height: 12),
              const _MedicationItem(
                title: "Moisturizing Lotion",
                subtitle: "Apply as needed",
                tag: "3-4 times daily",
              ),

              const SizedBox(height: 12),

              const Text(
                "Tap to view all medications",
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MedicationItem extends StatelessWidget {
  final String title;
  final String subtitle;
  final String tag;

  const _MedicationItem({
    required this.title,
    required this.subtitle,
    required this.tag,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(subtitle, style: const TextStyle(color: Colors.grey)),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 4,
            ),
            decoration: BoxDecoration(
              color: const Color(0xFFE6F6FA),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              tag,
              style: const TextStyle(
                fontSize: 12,
                color: Color(0xFF3B82F6),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
