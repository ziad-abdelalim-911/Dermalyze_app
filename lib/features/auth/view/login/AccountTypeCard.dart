import 'package:dermalyze/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:dermalyze/core/theme/theme_extensions.dart';

class AccountTypeCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final List<String> features;
  final String iconPath;
  final Widget navigateTo;

  const AccountTypeCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.features,
    required this.iconPath,
    required this.navigateTo,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 260,
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: context.dynamicBorderColor, width: 1),
        boxShadow: [
          BoxShadow(
            blurRadius: 10,
            color: Colors.black.withValues(alpha: context.isDarkMode ? 0.30 : 0.15),
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          ListTile(
            leading: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient2,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.20),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Center(
                child: SvgPicture.asset(
                  iconPath,
                  height: 40,
                  width: 40,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            title: Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: context.dynamicTextColorPrimary,
              ),
            ),
            subtitle: Text(
              subtitle,
              style: TextStyle(
                color: context.dynamicTextColorSecondary,
              ),
            ),
            trailing: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => navigateTo),
                );
              },
              child: Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: context.dynamicTextColorSecondary,
              ),
            ),
          ),

          const SizedBox(height: 40),

          Wrap(
            spacing: 20,
            runSpacing: 8,
            children: features
                .map(
                  (e) => Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.check,
                        size: 16,
                        color: Colors.blue,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        e,
                        style: TextStyle(
                          fontSize: 12,
                          color: context.dynamicTextColorPrimary,
                        ),
                      ),
                    ],
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}
