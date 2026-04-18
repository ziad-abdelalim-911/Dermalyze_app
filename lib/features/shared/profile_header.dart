import 'package:dermalyze/core/constants/app_colors.dart';
import 'package:dermalyze/features/shared/custom_text.dart';
import 'package:flutter/material.dart';

class ProfileHeader extends StatelessWidget {
  final String name;
  final String accountType;

  const ProfileHeader({
    super.key,
    required this.name,
    required this.accountType,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 40),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient2,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
      ),
      child: Column(
        children: [
          if (Navigator.canPop(context))
            Align(
              alignment: Alignment.centerLeft,
              child: IconButton(
                icon: Icon(Icons.arrow_back, color: Theme.of(context).cardColor),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          const SizedBox(height: 16),
          CircleAvatar(
            radius: 42,
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            child: Icon(
              Icons.person_outline,
              size: 42,
              color: AppColors.primaryColor,
            ),
          ),
          const SizedBox(height: 12),
          CustomText(
            text: name,
            color: Colors.white,
            size: 20,
            weight: FontWeight.w600,
          ),
          const SizedBox(height: 4),
          CustomText(
            text: accountType,
            color: Colors.white70,
            size: 14,
          ),
        ],
      ),
    );
  }
}
