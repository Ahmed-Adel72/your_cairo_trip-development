// lib/features/places/presentation/widgets/content_section_widget.dart

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:your_cairo_trip/features/places/data/model/budget_response_model.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/constants/app_translation_keys.dart';
import '../../../booking/presentation/screens/booking_screen.dart';
import '../cubit/places_cubit.dart';
import '../cubit/places_state.dart';
import 'free_badge_widget.dart';
import 'description_box_widget.dart';
import 'place_details_bottom_sheet.dart';

class ContentSectionWidget extends StatelessWidget {
  final PlaceItemResponseModel place;
  final bool isBooked;

  const ContentSectionWidget({
    super.key,
    required this.place,
    this.isBooked = false,
  });

  @override
  Widget build(BuildContext context) {
    final langCode = context.locale.languageCode;
    final priceText = place.getPrice(langCode);
    final booked = isBooked || place.isBooked;

    return Padding(
      padding: EdgeInsets.all(14.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Title + Details ──
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  place.name.localized(langCode),
                  style: AppTextStyles.placeTitle,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              SizedBox(width: 8.w),
              GestureDetector(
                onTap: () => PlaceDetailsBottomSheet.show(context, place),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline_rounded,
                      color: AppColors.primary,
                      size: 16.sp,
                    ),
                    SizedBox(width: 2.w),
                    Text(
                      AppTranslationKeys.placesDetails.tr(),
                      style: TextStyle(
                        fontSize: 13.sp,
                        color: AppColors.primary,
                        decoration: TextDecoration.underline,
                        decorationColor: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          SizedBox(height: 8.h),

          // ── Free Badge + Rating ──
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              FreeBadgeWidget(isFree: place.isFree),
              _StarRating(rating: place.ratingAvg),
            ],
          ),

          SizedBox(height: 8.h),

          // ── Total Bookings ──
          Row(
            children: [
              Icon(
                Icons.bookmark_rounded,
                color: AppColors.primary.withOpacity(0.7),
                size: 14.sp,
              ),
              SizedBox(width: 4.w),
              Text(
                langCode == 'ar'
                    ? '${place.totalBookings} حجز'
                    : '${place.totalBookings} bookings',
                style: TextStyle(fontSize: 12.sp, color: AppColors.textLight),
              ),
            ],
          ),

          // ── Price ──
          if (priceText != null) ...[
            SizedBox(height: 8.h),
            Row(
              children: [
                Icon(
                  Icons.attach_money_rounded,
                  color: Colors.red,
                  size: 16.sp,
                ),
                SizedBox(width: 2.w),
                Text(
                  priceText,
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: Colors.red,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ],

          // ── Description ──
          if (place.description != null) ...[
            SizedBox(height: 10.h),
            DescriptionBoxWidget(
              description: place.description!.localized(langCode),
            ),
          ],

          SizedBox(height: 12.h),

          // ── Book Button ──
          SizedBox(
            width: double.infinity,
            child: booked
                // ── تم الحجز ──
                ? ElevatedButton.icon(
                    onPressed: null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green.shade50,
                      foregroundColor: Colors.green.shade700,
                      disabledBackgroundColor: Colors.green.shade50,
                      disabledForegroundColor: Colors.green.shade700,
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                        side: BorderSide(color: Colors.green.shade300),
                      ),
                      elevation: 0,
                    ),
                    icon: Icon(Icons.check_circle_rounded, size: 18.sp),
                    label: Text(
                      langCode == 'ar' ? 'تم الحجز ✓' : 'Booked ✓',
                      style: TextStyle(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                // ── احجز رحلتك ──
                : ElevatedButton.icon(
                    onPressed: () {
                      // ── نمسك الـ PlacesCubit قبل الـ navigation ──
                      final placesCubit = context.read<PlacesCubit>();

                      // ── نحسب التكلفة التقريبية المتبقية ──
                      // ── التكلفة الأصلية - إجمالي ما تم حجزه ──
                      final state = placesCubit.state;
                      final remainingEstimatedCost = state is PlacesSuccess
                          ? state.budgetResponse.budgetInfo.totalCost.number -
                                state.totalBookedCost
                          : 0;

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => BookingScreen(
                            placeId: place.id,
                            placeName: place.name.localized(langCode),
                            placeImage: place.imageUrl,
                            totalCost: place.totalCost,
                            pricePerPerson: place.pricePerPerson,
                            estimatedTotalCost: remainingEstimatedCost,
                            // ── نمرر الـ PlacesCubit عشان يعمل markAsBooked ──
                            placesCubit: placesCubit,
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: AppColors.white,
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      elevation: 0,
                    ),
                    icon: Icon(Icons.calendar_month_rounded, size: 18.sp),
                    label: Text(
                      AppTranslationKeys.placesBookTrip.tr(),
                      style: TextStyle(
                        fontSize: 15.sp,
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

// ─── Star Rating Widget ───────────────────────────────────────────────────────

class _StarRating extends StatelessWidget {
  final double rating;

  const _StarRating({required this.rating});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: List.generate(5, (i) {
            final starValue = i + 1;
            if (rating >= starValue) {
              return Icon(
                Icons.star_rounded,
                color: AppColors.rating,
                size: 18.sp,
              );
            } else if (rating >= starValue - 0.5) {
              return Icon(
                Icons.star_half_rounded,
                color: AppColors.rating,
                size: 18.sp,
              );
            } else {
              return Icon(
                Icons.star_outline_rounded,
                color: AppColors.rating,
                size: 18.sp,
              );
            }
          }),
        ),
        SizedBox(width: 4.w),
        Text(
          rating > 0 ? rating.toStringAsFixed(1) : '0.0',
          style: TextStyle(
            fontSize: 12.sp,
            color: AppColors.textLight,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
