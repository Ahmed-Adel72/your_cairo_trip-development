// lib/features/profile/presentation/widgets/trip_card_widget.dart

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_translation_keys.dart';
import '../../data/models/trip_model.dart';

class TripCardWidget extends StatelessWidget {
  final TripModel trip;
  final bool isCompleted;
  final VoidCallback? onRate;

  const TripCardWidget({
    super.key,
    required this.trip,
    required this.isCompleted,
    this.onRate,
  });

  @override
  Widget build(BuildContext context) {
    final langCode = context.locale.languageCode;

    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.07),
            blurRadius: 12.r,
            offset: Offset(0, 4.h),
          ),
        ],
      ),
      child: Column(
        children: [
          // ── Image + Status Badge ──
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
                child: Image.network(
                  _fixImageUrl(trip.place.imageUrl),
                  height: 150.h,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    height: 150.h,
                    color: const Color(0xFFE8D5B0),
                    child: Center(
                      child: Icon(
                        Icons.image_not_supported,
                        color: Colors.grey,
                        size: 30.sp,
                      ),
                    ),
                  ),
                ),
              ),

              // ── Status Badge ──
              Positioned(
                top: 10.h,
                left: langCode == 'ar' ? null : 10.w,
                right: langCode == 'ar' ? 10.w : null,
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10.w,
                    vertical: 4.h,
                  ),
                  decoration: BoxDecoration(
                    color: isCompleted ? Colors.green : AppColors.primary,
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isCompleted
                            ? Icons.check_circle_rounded
                            : Icons.upcoming_rounded,
                        color: AppColors.white,
                        size: 12.sp,
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        trip.statusLabel.localized(langCode),
                        style: TextStyle(
                          color: AppColors.white,
                          fontSize: 11.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // ── Content ──
          Padding(
            padding: EdgeInsets.all(14.r),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Place Name ──
                Text(
                  trip.place.name.localized(langCode),
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textDark,
                  ),
                ),

                SizedBox(height: 6.h),

                // ── Location ──
                Row(
                  children: [
                    Icon(
                      Icons.location_on_outlined,
                      color: AppColors.textLight,
                      size: 14.sp,
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      trip.place.location.localized(langCode),
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: AppColors.textLight,
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 10.h),

                // ── Info Chips ──
                Wrap(
                  spacing: 8.w,
                  runSpacing: 6.h,
                  children: [
                    _InfoChip(
                      icon: Icons.calendar_today_rounded,
                      label: trip.tripDate,
                    ),
                    _InfoChip(
                      icon: Icons.people_rounded,
                      label:
                          '${trip.personCount} ${AppTranslationKeys.myTripsPeople.tr()}',
                    ),
                    _InfoChip(
                      icon: Icons.payments_outlined,
                      label: trip.price.localized(langCode),
                    ),
                  ],
                ),

                // ── Rating Section (Completed Only) ──
                if (isCompleted) ...[
                  SizedBox(height: 12.h),
                  const Divider(color: Color(0xFFEEEEEE)),
                  SizedBox(height: 8.h),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // ── Stars Display ──
                      Expanded(
                        child: Row(
                          children: [
                            Text(
                              langCode == 'ar' ? 'تقييمك: ' : 'Your rating: ',
                              style: TextStyle(
                                fontSize: 13.sp,
                                color: AppColors.textLight,
                              ),
                            ),
                            if (trip.rating != null)
                              ...List.generate(5, (i) {
                                return Icon(
                                  i < (trip.rating ?? 0)
                                      ? Icons.star_rounded
                                      : Icons.star_outline_rounded,
                                  color: AppColors.primary,
                                  size: 18.sp,
                                );
                              })
                            else
                              Text(
                                langCode == 'ar'
                                    ? 'لم يتم التقييم بعد'
                                    : 'Not rated yet',
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  color: AppColors.textLight,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                          ],
                        ),
                      ),

                      // ── Rate Button ──
                      GestureDetector(
                        onTap: onRate,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 12.w,
                            vertical: 6.h,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primaryLight,
                            borderRadius: BorderRadius.circular(10.r),
                            border: Border.all(
                              color: AppColors.primary.withOpacity(0.4),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.star_rounded,
                                color: AppColors.primary,
                                size: 14.sp,
                              ),
                              SizedBox(width: 4.w),
                              Text(
                                trip.rating != null
                                    ? AppTranslationKeys.myTripsRateEdit.tr()
                                    : AppTranslationKeys.myTripsRate.tr(),
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
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
      ),
    );
  }
}

// ─── Info Chip ────────────────────────────────────────────────────────────────

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _InfoChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: AppColors.primary, size: 12.sp),
          SizedBox(width: 4.w),
          Text(
            label,
            style: TextStyle(fontSize: 11.sp, color: AppColors.textMedium),
          ),
        ],
      ),
    );
  }
}

String _fixImageUrl(String url) {
  return url.replaceFirst('http://', 'https://');
}
