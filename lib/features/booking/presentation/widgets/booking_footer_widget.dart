// lib/features/booking/presentation/widgets/booking_footer_widget.dart

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_translation_keys.dart';

class BookingFooterWidget extends StatelessWidget {
  final int personCount;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final VoidCallback onConfirm;
  final bool isLoading;
  final num pricePerPerson;

  // ── التكلفة التقريبية لكل الأماكن ──
  final num estimatedTotalCost;

  const BookingFooterWidget({
    super.key,
    required this.personCount,
    required this.onIncrement,
    required this.onDecrement,
    required this.onConfirm,
    required this.isLoading,
    this.pricePerPerson = 0,
    this.estimatedTotalCost = 0,
  });

  @override
  Widget build(BuildContext context) {
    final langCode = context.locale.languageCode;

    // ── حساب التكلفة المتوقعة للحجز ──
    final expectedTotal = pricePerPerson * personCount;

    // ── التحقق من تجاوز التكلفة التقريبية ──
    final isExceeded = pricePerPerson > 0 && expectedTotal > estimatedTotalCost;

    return Container(
      padding: EdgeInsets.all(20.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 10.r,
            offset: Offset(0, 4.h),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Person Count Label ──
          Text(
            AppTranslationKeys.bookingPersonCount.tr(),
            style: TextStyle(
              fontSize: 15.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.textDark,
            ),
          ),

          SizedBox(height: 12.h),

          // ── Counter ──
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _CounterBtn(icon: Icons.remove, onTap: onDecrement),
              SizedBox(width: 24.w),
              Text(
                '$personCount',
                style: TextStyle(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark,
                ),
              ),
              SizedBox(width: 24.w),
              _CounterBtn(icon: Icons.add, onTap: onIncrement),
            ],
          ),

          // ── التكلفة المتوقعة ──
          if (pricePerPerson > 0) ...[
            SizedBox(height: 16.h),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(12.r),
              decoration: BoxDecoration(
                color: isExceeded
                    ? Colors.red.withOpacity(0.08)
                    : Colors.green.withOpacity(0.08),
                borderRadius: BorderRadius.circular(10.r),
                border: Border.all(
                  color: isExceeded
                      ? Colors.red.withOpacity(0.3)
                      : Colors.green.withOpacity(0.3),
                ),
              ),
              child: Column(
                children: [
                  // ── التكلفة الإجمالية للحجز ──
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        AppTranslationKeys.bookingTotalPrice.tr(),
                        style: TextStyle(
                          fontSize: 13.sp,
                          color: AppColors.textLight,
                        ),
                      ),
                      Text(
                        langCode == 'ar'
                            ? '$expectedTotal جنيه'
                            : '$expectedTotal EGP',
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.bold,
                          color: isExceeded
                              ? Colors.red
                              : Colors.green.shade600,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 6.h),

                  // ── التكلفة التقريبية للأماكن ──
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        AppTranslationKeys.placesCostLabel.tr(),
                        style: TextStyle(
                          fontSize: 13.sp,
                          color: AppColors.textLight,
                        ),
                      ),
                      Text(
                        langCode == 'ar'
                            ? '$estimatedTotalCost جنيه'
                            : '$estimatedTotalCost EGP',
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textDark,
                        ),
                      ),
                    ],
                  ),

                  // ── تحذير لو تجاوز التكلفة التقريبية ──
                  if (isExceeded) ...[
                    SizedBox(height: 8.h),
                    Row(
                      children: [
                        Icon(
                          Icons.warning_rounded,
                          color: Colors.red,
                          size: 14.sp,
                        ),
                        SizedBox(width: 4.w),
                        Expanded(
                          child: Text(
                            langCode == 'ar'
                                ? 'التكلفة تتجاوز التكلفة التقريبية للرحلة'
                                : 'Cost exceeds the estimated trip cost',
                            style: TextStyle(
                              fontSize: 11.sp,
                              color: Colors.red,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ],

          SizedBox(height: 20.h),

          // ── Confirm Button ──
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: isLoading || isExceeded ? null : onConfirm,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.white,
                disabledBackgroundColor: Colors.grey.shade300,
                disabledForegroundColor: Colors.grey.shade500,
                padding: EdgeInsets.symmetric(vertical: 14.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
                elevation: 3,
              ),
              child: isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : Text(
                      AppTranslationKeys.bookingConfirm.tr(),
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CounterBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _CounterBtn({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40.w,
        height: 40.h,
        decoration: BoxDecoration(
          color: AppColors.primaryLight,
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.primary.withOpacity(0.3)),
        ),
        child: Icon(icon, color: AppColors.primary, size: 20.sp),
      ),
    );
  }
}
