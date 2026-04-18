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
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.05), blurRadius: 10),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// ===== Header
              const Row(
                children: [
                  Icon(Icons.trending_up, color: Color(0xFF3B82F6)),
                  SizedBox(width: 8),
                  Text(
                    "Recovery Progress",
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              /// ===== Recovery Rate
              Row(
                children: [
                  const Expanded(
                    child: Text(
                      "Recovery Rate",
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                  Text(
                    percent,
                    style: const TextStyle(
                      color: Color(0xFF3B82F6),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              /// ===== Linear Progress
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: LinearProgressIndicator(
                  value: widget.recoveryRate,
                  minHeight: 8,
                  backgroundColor: Colors.grey.shade300,
                  valueColor:
                      const AlwaysStoppedAnimation(Color(0xFF3B82F6)),
                ),
              ),
              const SizedBox(height: 20),

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
                          value: widget.recoveryRate,
                          strokeWidth: 12,
                          backgroundColor: Colors.grey.shade300,
                          valueColor: const AlwaysStoppedAnimation(
                            Color(0xFF3B82F6),
                          ),
                        ),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            percent,
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF3B82F6),
                            ),
                          ),
                          const Text("Recovery",
                              style: TextStyle(fontSize: 12)),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),

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
