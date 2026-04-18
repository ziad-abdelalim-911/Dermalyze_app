import 'package:dermalyze/core/constants/app_assets.dart';
import 'package:dermalyze/features/auth/view/medication_list/medication_model.dart';
import 'package:flutter/material.dart';


class MedicationCard extends StatelessWidget {

  final MedicationModel medication;

  const MedicationCard({
    super.key,
    required this.medication,
  });

  @override
  Widget build(BuildContext context) {

    /// COMPLETED DESIGN
    if (medication.isCompleted) {
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: const EdgeInsets.all(16),

        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(16),
        ),

        child: Row(
          children: [

            Container(
              width: 44,
              height: 44,

              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(12),
              ),

              child: Center(
                child: Image.asset(
                  AppAssets.medication_icon,
                  width: 22,
                ),
              ),
            ),

            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Text(
                    medication.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  Text(
                    medication.dose,
                    style: const TextStyle(
                      color: Colors.grey,
                    ),
                  ),

                ],
              ),
            ),

            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 6,
              ),

              decoration: BoxDecoration(
                color: const Color(0xFFD1FAE5),
                borderRadius: BorderRadius.circular(20),
              ),

              child: const Text(
                "Completed",
                style: TextStyle(
                  color: Color(0xFF059669),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),

          ],
        ),
      );
    }

    /// ACTIVE DESIGN
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.05),
            blurRadius: 10,
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          /// TOP
          Row(
            children: [

              Container(
                width: 44,
                height: 44,

                decoration: BoxDecoration(
                  color: const Color(0xFFD1FAE5),
                  borderRadius: BorderRadius.circular(12),
                ),

                child: Center(
                  child: Image.asset(
                    AppAssets.medication_icon,
                    width: 22,
                  ),
                ),
              ),

              const SizedBox(width: 12),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Text(
                    medication.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),

                  Text(
                    medication.dose,
                    style: const TextStyle(
                      color: Color(0xFF14B8A6),
                    ),
                  ),

                ],
              ),

            ],
          ),

          const SizedBox(height: 16),

          /// FREQUENCY + DURATION
          Row(
            children: [

              Expanded(
                child: infoBox(
                  context,
                  AppAssets.time_icon,
                  "Frequency",
                  medication.frequency,
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: infoBox(
                  context,
                  AppAssets.calendarIcon,
                  "Duration",
                  medication.duration,
                ),
              ),

            ],
          ),

          const SizedBox(height: 16),

          /// WHEN TO TAKE
          Container(
            padding: const EdgeInsets.all(12),

            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(12),
            ),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                const Text(
                  "When to take:",
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),

                Text(
                  medication.whenToTake,
                  style: const TextStyle(
                    color: Color(0xFF2563EB),
                    fontWeight: FontWeight.w500,
                  ),
                ),

              ],
            ),
          ),

          const SizedBox(height: 12),

          /// WARNING
          Container(
            padding: const EdgeInsets.all(12),

            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: const Color(0xFFFACC15),
              ),
            ),

            child: Row(
              children: [

                Image.asset(
                  AppAssets.i_icon,
                  width: 20,
                ),

                const SizedBox(width: 8),

                Expanded(
                  child: Text(
                    medication.warning,
                    style: const TextStyle(
                      color: Color(0xFF92400E),
                    ),
                  ),
                ),

              ],
            ),
          ),

          const SizedBox(height: 12),

          /// DATES
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [

              Text(
                "Started: ${medication.startDate}",
                style: const TextStyle(color: Colors.grey),
              ),

              Text(
                "Ends: ${medication.endDate}",
                style: const TextStyle(color: Colors.grey),
              ),

            ],
          ),

        ],
      ),
    );
  }

  Widget infoBox(BuildContext context, String icon, String title, String value) {
    return Container(
      padding: const EdgeInsets.all(12),

      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
      ),

      child: Row(
        children: [

          Image.asset(icon, width: 18),

          const SizedBox(width: 8),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Text(
                title,
                style: const TextStyle(
                  color: Colors.grey,
                ),
              ),

              Text(
                value,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),

            ],
          ),

        ],
      ),
    );
  }

}
