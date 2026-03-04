import 'package:dermalyze/features/auth/view/disease_details_view/TreatmentPla_card.dart';
import 'package:dermalyze/features/auth/view/disease_details_view/Warning_Card.dart';
import 'package:dermalyze/features/auth/view/disease_details_view/about_disease_card.dart';
import 'package:dermalyze/features/auth/view/disease_details_view/affected_areasCard.dart';
import 'package:dermalyze/features/auth/view/disease_details_view/diagnosis_info_card.dart';
import 'package:dermalyze/features/auth/view/disease_details_view/disease_header_card.dart';
import 'package:dermalyze/features/auth/view/disease_details_view/symptoms_card.dart';
import 'package:flutter/material.dart';

class DiseaseDetailsView extends StatelessWidget {
  const DiseaseDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F6F6),

      body: Column(
        children: [
          /// HEADER
          Container(
            padding: const EdgeInsets.fromLTRB(16, 50, 16, 16),

            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(24),
                bottomRight: Radius.circular(24),
              ),
            ),

            child: Row(
              children: [
                /// back button
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    width: 40,
                    height: 40,

                    decoration: BoxDecoration(
                      color: const Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.circular(12),
                    ),

                    child: const Icon(Icons.arrow_back),
                  ),
                ),

                const SizedBox(width: 12),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      "Disease Details",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    SizedBox(height: 2),

                    Text(
                      "Complete information",
                      style: TextStyle(color: Colors.grey, fontSize: 13),
                    ),
                  ],
                ),
              ],
            ),
          ),

          /// BODY
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                DiseaseHeaderCard(),

                SizedBox(height: 16),

                DiagnosisInfoCard(),

                SizedBox(height: 16),

                AboutDiseaseCard(),

                SizedBox(height: 16),

                AffectedAreasCard(),

                SizedBox(height: 16),

                SymptomsCard(),

                SizedBox(height: 16),

                /// ================= Treatment Plan =================
                Container(
                  padding: EdgeInsets.all(16),

                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Treatment Plan",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),

                      SizedBox(height: 16),

                      /// step 1
                      TreatmentStepCard(
                        stepNumber: 1,
                        title: "Topical Medications",
                        subtitle: "Apply corticosteroid cream twice daily",

                        backgroundColor: Color(0xFFE7F6EC),
                        circleColor: Color(0xFF22C55E),

                        textColor: Color(0xFF166534),
                        subtitleColor: Color(0xFF15803D),
                      ),

                      SizedBox(height: 12),

                      /// step 2
                      TreatmentStepCard(
                        stepNumber: 2,
                        title: "Moisturize Regularly",
                        subtitle:
                            "Use fragrance-free moisturizer 3-4 times daily",

                        backgroundColor: Color(0xFFE8F0FE),
                        circleColor: Color(0xFF3B82F6),

                        textColor: Color(0xFF1D4ED8),
                        subtitleColor: Color(0xFF2563EB),
                      ),

                      SizedBox(height: 12),

                      /// step 3
                      TreatmentStepCard(
                        stepNumber: 3,
                        title: "Lifestyle Adjustments",
                        subtitle:
                            "Avoid triggers, manage stress, use gentle soaps",

                        backgroundColor: Color(0xFFF3E8FF),
                        circleColor: Color(0xFF8B5CF6),

                        textColor: Color(0xFF6D28D9),
                        subtitleColor: Color(0xFF7C3AED),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 16),

                WarningCard(),

                SizedBox(height: 30),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
