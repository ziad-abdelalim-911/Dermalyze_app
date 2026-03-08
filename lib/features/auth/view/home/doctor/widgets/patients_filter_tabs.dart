import 'package:dermalyze/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

class PatientsFilterTabs extends StatelessWidget {
  final String selectedFilter;
  final ValueChanged<String> onFilterChanged;
  final Map<String, int> filterCounts;

  const PatientsFilterTabs({
    super.key,
    required this.selectedFilter,
    required this.onFilterChanged,
    required this.filterCounts,
  });

  @override
  Widget build(BuildContext context) {
    final filters = filterCounts.keys.toList();

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: filters.map((filter) {
          final isSelected = selectedFilter == filter;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: GestureDetector(
              onTap: () => onFilterChanged(filter),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.SkyBlue : Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected ? AppColors.SkyBlue : AppColors.Gray2,
                    width: 1.5,
                  ),
                ),
                child: Text(
                  '$filter (${filterCounts[filter]})',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: isSelected ? Colors.white : AppColors.Gray,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}