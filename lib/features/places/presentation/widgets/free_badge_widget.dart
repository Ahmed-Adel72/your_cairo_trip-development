// lib/features/places/presentation/widgets/free_badge_widget.dart

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_translation_keys.dart';
import '../../../../core/constants/app_text_styles.dart';

class FreeBadgeWidget extends StatelessWidget {
  final bool isFree;

  const FreeBadgeWidget({super.key, required this.isFree});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: isFree ? AppColors.freeBadgeBg : AppColors.paidBadgeBg,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: isFree
              ? AppColors.freeBadgeBorder.withOpacity(0.4)
              : AppColors.paidBadgeBorder.withOpacity(0.4),
        ),
      ),
      child: Text(
        // ── استخدمنا الترجمة بدل AppStrings ──
        isFree
            ? AppTranslationKeys.placesFree.tr()
            : AppTranslationKeys.placesPaid.tr(),
        style: isFree ? AppTextStyles.freeBadge : AppTextStyles.paidBadge,
      ),
    );
  }
}
