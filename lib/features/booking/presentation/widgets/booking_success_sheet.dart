// lib/features/booking/presentation/widgets/booking_success_sheet.dart

import 'dart:ui' as ui;

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_translation_keys.dart';
import '../../data/models/booking_response_model.dart';

class BookingSuccessSheet extends StatelessWidget {
  final BookingResponseModel bookingResponse;

  const BookingSuccessSheet({super.key, required this.bookingResponse});

  // ── بقت ترجع Future عشان نعرف لما اليوزر يقفلها ──
  static Future<void> show(
    BuildContext context, {
    required BookingResponseModel bookingResponse,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: false,
      backgroundColor: Colors.transparent,
      builder: (_) => BookingSuccessSheet(bookingResponse: bookingResponse),
    );
  }

  @override
  Widget build(BuildContext context) {
    final langCode = context.locale.languageCode;
    final data = bookingResponse.data;

    return Directionality(
      textDirection: langCode == 'ar'
          ? ui.TextDirection.rtl
          : ui.TextDirection.ltr,
      child: Container(
        padding: EdgeInsets.all(24.r),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28.r)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ── Handle ──
            Container(
              width: 40.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.3),
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),

            SizedBox(height: 24.h),

            // ── Success Icon ──
            Container(
              width: 80.w,
              height: 80.h,
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.check_circle_rounded,
                color: Colors.green.shade600,
                size: 50.sp,
              ),
            ),

            SizedBox(height: 16.h),

            // ── Success Message ──
            Text(
              bookingResponse.message.localized(langCode),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.textDark,
              ),
            ),

            SizedBox(height: 24.h),

            // ── Booking Details ──
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(16.r),
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.05),
                borderRadius: BorderRadius.circular(16.r),
                border: Border.all(color: Colors.grey.withOpacity(0.15)),
              ),
              child: Column(
                children: [
                  // ── Place Name ──
                  _DetailRow(
                    icon: Icons.location_on_outlined,
                    label: AppTranslationKeys.bookingPlaceName.tr(),
                    value: data.place.name.localized(langCode),
                  ),

                  _Divider(),

                  // ── Booking Date ──
                  _DetailRow(
                    icon: Icons.calendar_today_outlined,
                    label: AppTranslationKeys.bookingDate.tr(),
                    value: data.bookingDate,
                  ),

                  _Divider(),

                  // ── Person Count ──
                  _DetailRow(
                    icon: Icons.people_outline_rounded,
                    label: AppTranslationKeys.bookingPersonCount.tr(),
                    value: '${data.personCount}',
                  ),

                  _Divider(),

                  // ── Total Price ──
                  _DetailRow(
                    icon: Icons.payments_outlined,
                    label: AppTranslationKeys.bookingTotalPrice.tr(),
                    value: data.totalPrice.localized(langCode),
                    valueColor: AppColors.primary,
                  ),

                  _Divider(),

                  // ── Status ──
                  _DetailRow(
                    icon: Icons.hourglass_empty_rounded,
                    label: AppTranslationKeys.bookingStatusPending.tr(),
                    value: data.statusLabel.localized(langCode),
                    valueColor: Colors.orange.shade700,
                  ),
                ],
              ),
            ),

            SizedBox(height: 24.h),

            // ── زرار "متابعة الحجوزات" بدل "العودة للرئيسية" ──
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  // ── بس نقفل الشيت ونرجع للـ places ──
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.white,
                  padding: EdgeInsets.symmetric(vertical: 14.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  elevation: 3,
                ),
                icon: Icon(Icons.explore_rounded, size: 20.sp),
                // ── label بدل child ──
                label: Text(
                  langCode == 'ar' ? 'متابعة الحجوزات' : 'Continue Booking',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            SizedBox(height: 16.h),
          ],
        ),
      ),
    );
  }
}

// ─── Detail Row ───────────────────────────────────────────────────────────────

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color? valueColor;

  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primary, size: 18.sp),
          SizedBox(width: 10.w),
          Expanded(
            child: Text(
              label,
              style: TextStyle(fontSize: 13.sp, color: AppColors.textLight),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.bold,
              color: valueColor ?? AppColors.textDark,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Divider ─────────────────────────────────────────────────────────────────

class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Divider(color: Colors.grey.withOpacity(0.15), height: 1);
  }
}
