// lib/features/home/presentation/widgets/top_bar_widget.dart

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_translation_keys.dart';
import '../../../../core/constants/app_text_styles.dart';

class TopBarWidget extends StatelessWidget {
  const TopBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 18.h),
      color: AppColors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // ── Title ──
          Row(
            children: [
              Icon(Icons.mosque_rounded, color: AppColors.primary, size: 26.sp),
              SizedBox(width: 8.w),
              Text(
                AppTranslationKeys.homeAppTitle.tr(),
                style: AppTextStyles.appTitle,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
