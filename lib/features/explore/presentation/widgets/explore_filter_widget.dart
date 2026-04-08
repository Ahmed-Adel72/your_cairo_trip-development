// lib/features/explore/presentation/widgets/explore_filter_widget.dart

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_translation_keys.dart';

class ExploreFilterWidget extends StatelessWidget {
  final String activeFilter;
  final ValueChanged<String> onFilterChanged;

  const ExploreFilterWidget({
    super.key,
    required this.activeFilter,
    required this.onFilterChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _FilterChip(
          label: AppTranslationKeys.exploreAll.tr(),
          isActive: activeFilter == 'all',
          onTap: () => onFilterChanged('all'),
        ),
        SizedBox(width: 8.w),
        _FilterChip(
          label: AppTranslationKeys.exploreFree.tr(),
          isActive: activeFilter == 'free',
          onTap: () => onFilterChanged('free'),
          activeColor: Colors.green.shade600,
        ),
        SizedBox(width: 8.w),
        _FilterChip(
          label: AppTranslationKeys.explorePaid.tr(),
          isActive: activeFilter == 'paid',
          onTap: () => onFilterChanged('paid'),
          activeColor: Colors.red.shade600,
        ),
      ],
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isActive;
  final VoidCallback onTap;
  final Color? activeColor;

  const _FilterChip({
    required this.label,
    required this.isActive,
    required this.onTap,
    this.activeColor,
  });

  @override
  Widget build(BuildContext context) {
    final color = activeColor ?? AppColors.primary;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: isActive ? color : Colors.white,
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(
            color: isActive ? color : Colors.grey.withOpacity(0.3),
          ),
          boxShadow: isActive
              ? [
                  BoxShadow(
                    color: color.withOpacity(0.3),
                    blurRadius: 8.r,
                    offset: Offset(0, 2.h),
                  ),
                ]
              : [],
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13.sp,
            fontWeight: FontWeight.w600,
            color: isActive ? Colors.white : AppColors.textLight,
          ),
        ),
      ),
    );
  }
}
