import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';

class DescriptionBoxWidget extends StatelessWidget {
  final String description;

  const DescriptionBoxWidget({super.key, required this.description});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.descBoxBg,
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: IntrinsicHeight(
        child: Row(
          children: [
            // ── Orange Accent Line ──
            Container(
              width: 4.w,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(10.r),
                  bottomRight: Radius.circular(10.r),
                ),
              ),
            ),

            // ── Description Text ──
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
                child: Text(
                  description,
                  style: AppTextStyles.placeDescription,
                  textAlign: TextAlign.right,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
