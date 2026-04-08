// lib/features/home/presentation/widgets/badge_widget.dart

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_translation_keys.dart';
import '../../../../core/constants/app_text_styles.dart';

class BadgeWidget extends StatelessWidget {
  const BadgeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: AppColors.primaryLight,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: AppColors.primaryBorder.withOpacity(0.4)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.star_rounded, color: AppColors.primary, size: 16.sp),
          SizedBox(width: 6.w),
          Text(
            AppTranslationKeys.homeBadgeText.tr(),
            style: AppTextStyles.badge,
          ),
        ],
      ),
    );
  }
}
