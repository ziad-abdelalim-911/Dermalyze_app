import 'package:dermalyze/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

enum RiskLevel { high, severe }

class CriticalPatientCard extends StatelessWidget {
  final String name;
  final String diagnosis;
  final int age;
  final String lastVisit;
  final String updatedAgo;
  final String currentSymptoms;
  final double recoveryRate;
  final String nextAppointment;
  final RiskLevel riskLevel;
  final VoidCallback onView;
  final VoidCallback onCall;
  final VoidCallback onMessage;

  const CriticalPatientCard({
    super.key,
    required this.name,
    required this.diagnosis,
    required this.age,
    required this.lastVisit,
    required this.updatedAgo,
    required this.currentSymptoms,
    required this.recoveryRate,
    required this.nextAppointment,
    required this.riskLevel,
    required this.onView,
    required this.onCall,
    required this.onMessage,
  });

  Color get _riskColor =>
      riskLevel == RiskLevel.severe ? const Color(0xFFD32F2F) : const Color(0xFFE05252);

  String get _riskLabel =>
      riskLevel == RiskLevel.severe ? 'SEVERE RISK' : 'HIGH RISK';

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _riskColor.withOpacity(0.3), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: _riskColor.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Risk Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: _riskColor.withOpacity(0.08),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.warning_amber_rounded,
                        color: _riskColor, size: 16),
                    const SizedBox(width: 6),
                    Text(
                      _riskLabel,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: _riskColor,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
                Text(
                  'Updated: $updatedAgo',
                  style: TextStyle(fontSize: 11, color: AppColors.Gray),
                ),
              ],
            ),
          ),
          // Content
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Name + View Button
                Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: _riskColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(Icons.person_outline,
                          color: _riskColor, size: 24),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            name,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: isDark ? Colors.white : AppColors.Black,
                            ),
                          ),
                          Text(
                            diagnosis,
                            style: TextStyle(
                                fontSize: 12, color: isDark ? Colors.grey.shade400 : AppColors.Gray),
                          ),
                        ],
                      ),
                    ),
                    // View Button
                    SizedBox(
                      height: 34,
                      child: ElevatedButton(
                        onPressed: onView,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _riskColor,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: EdgeInsets.symmetric(horizontal: 14),
                        ),
                        child: Text(
                          'View',
                          style: TextStyle(
                              color: Theme.of(context).cardColor,
                              fontSize: 13,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                // Age + Last Visit
                Row(
                  children: [
                    Text('Age: $age',
                        style:
                            TextStyle(fontSize: 12, color: isDark ? Colors.grey.shade400 : AppColors.Gray)),
                    const SizedBox(width: 6),
                    Container(
                        width: 4,
                        height: 4,
                        decoration: BoxDecoration(
                            color: isDark ? Colors.grey.shade400 : AppColors.Gray, shape: BoxShape.circle)),
                    const SizedBox(width: 6),
                    Text('Last visit: $lastVisit',
                        style:
                            TextStyle(fontSize: 12, color: isDark ? Colors.grey.shade400 : AppColors.Gray)),
                  ],
                ),
                const SizedBox(height: 10),
                // Symptoms Box
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: _riskColor.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                        color: _riskColor.withOpacity(0.2), width: 1),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Current Symptoms:',
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: isDark ? Colors.grey.shade400 : AppColors.Gray3),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        currentSymptoms,
                        style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: _riskColor),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                // Recovery Rate
                Row(
                  children: [
                    Icon(Icons.trending_down, color: _riskColor, size: 16),
                    const SizedBox(width: 6),
                    Text('Recovery Rate',
                        style:
                            TextStyle(fontSize: 12, color: isDark ? Colors.grey.shade400 : AppColors.Gray)),
                    const Spacer(),
                    Text(
                      '${(recoveryRate * 100).toInt()}%',
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: _riskColor),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: recoveryRate,
                    minHeight: 5,
                    backgroundColor: AppColors.Gray2.withOpacity(0.4),
                    valueColor:
                        AlwaysStoppedAnimation<Color>(_riskColor),
                  ),
                ),
                const SizedBox(height: 12),
                // Call + Message Buttons
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: onCall,
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(
                              color: AppColors.SkyBlue, width: 1.5),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          padding:
                              const EdgeInsets.symmetric(vertical: 10),
                        ),
                        icon: Icon(Icons.phone_outlined,
                            color: AppColors.SkyBlue, size: 16),
                        label: Text('Call',
                            style: TextStyle(
                                color: AppColors.SkyBlue,
                                fontWeight: FontWeight.w600)),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: onMessage,
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(
                              color: AppColors.SkyBlue, width: 1.5),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          padding:
                              const EdgeInsets.symmetric(vertical: 10),
                        ),
                        icon: Icon(Icons.message_outlined,
                            color: AppColors.SkyBlue, size: 16),
                        label: Text('Message',
                            style: TextStyle(
                                color: AppColors.SkyBlue,
                                fontWeight: FontWeight.w600)),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                // Next Appointment
                Row(
                  children: [
                    Text(
                      'Next Appointment: ',
                      style:
                          TextStyle(fontSize: 12, color: isDark ? Colors.grey.shade400 : AppColors.Gray),
                    ),
                    Text(
                      nextAppointment,
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: _riskColor),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}