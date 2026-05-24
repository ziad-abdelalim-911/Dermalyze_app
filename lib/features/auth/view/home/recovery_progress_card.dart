import 'package:dermalyze/core/constants/app_colors.dart';
import 'package:dermalyze/features/auth/view/ProgressReport_view/progress_report_view.dart';
import 'package:flutter/material.dart';

class RecoveryProgressCard extends StatefulWidget {
  final double recoveryRate;

  const RecoveryProgressCard({
    super.key,
    this.recoveryRate = 0.0,
  });

  @override
  State<RecoveryProgressCard> createState() => _RecoveryProgressCardState();
}

class _RecoveryProgressCardState extends State<RecoveryProgressCard> {
  @override
  Widget build(BuildContext context) {
    final percent = '${(widget.recoveryRate * 100).toInt()}%';
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ProgressReportView()),
          );
        },
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(isDark ? 0.2 : 0.05),
                  blurRadius: 10),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// ===== Header
              Row(
                children: [
                  Icon(Icons.trending_up, color: AppColors.SkyBlue),
                  const SizedBox(width: 8),
                  Text(
                    "Recovery Progress",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),

              /// ===== Recovery Rate
              Row(
                children: [
                  Expanded(
                    child: Text(
                      "Recovery Rate",
                      style: TextStyle(
                        fontSize: 14,
                        color: isDark ? Colors.white70 : Colors.black87,
                      ),
                    ),
                  ),
                  Text(
                    percent,
                    style: TextStyle(
                      color: AppColors.Turqouoise,
                      fontWeight: FontWeight.w500,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              /// ===== Linear Progress
              Stack(
                children: [
                  Container(
                    height: 10,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: isDark ? Colors.white12 : Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  FractionallySizedBox(
                    widthFactor: widget.recoveryRate,
                    child: Container(
                      height: 10,
                      decoration: BoxDecoration(
                        gradient: AppColors.primaryGradient2,
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              /// ===== Trending Text
              Row(
                children: [
                  Icon(Icons.trending_up, size: 16, color: AppColors.Turqouoise),
                  const SizedBox(width: 4),
                  Text(
                    "+12% from last month",
                    style: TextStyle(fontSize: 12, color: AppColors.Turqouoise),
                  ),
                ],
              ),
              const SizedBox(height: 32),

              /// ===== Circle Progress
              Center(
                child: SizedBox(
                  width: 140,
                  height: 140,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        width: 140,
                        height: 140,
                        child: CircularProgressIndicator(
                          value: 1.0,
                          strokeWidth: 14,
                          color: isDark ? Colors.white12 : Colors.grey.shade200,
                        ),
                      ),
                      SizedBox(
                        width: 140,
                        height: 140,
                        child: ShaderMask(
                          shaderCallback: (bounds) => AppColors.primaryGradient2
                              .createShader(bounds),
                          child: CircularProgressIndicator(
                            value: widget.recoveryRate,
                            strokeWidth: 14,
                            backgroundColor: Colors.transparent,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            percent,
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.w500,
                              color: AppColors.SkyBlue,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            "Recovery",
                            style: TextStyle(
                              fontSize: 13,
                              color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              const Center(
                child: Text(
                  "Tap to view full progress report",
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
