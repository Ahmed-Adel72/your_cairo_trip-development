// lib/features/explore/presentation/widgets/explore_place_card_widget.dart

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_translation_keys.dart';
import '../../../booking/presentation/screens/booking_screen.dart';
import '../../../places/presentation/widgets/place_details_bottom_sheet.dart';
import '../../../places/data/model/budget_response_model.dart';
import '../../data/models/explore_place_model.dart';
import '../cubit/explore_cubit.dart';

class ExplorePlaceCardWidget extends StatelessWidget {
  final ExplorePlaceModel place;

  const ExplorePlaceCardWidget({super.key, required this.place});

  // ── تحويل ExplorePlaceModel إلى PlaceItemResponseModel للـ BottomSheet ──
  PlaceItemResponseModel _toPlaceItemResponseModel() {
    return PlaceItemResponseModel(
      id: place.id,
      name: place.name,
      description: place.description,
      imageUrl: place.imageUrl,
      isFree: place.isFree,
      priceLocalized: place.price,
      priceNumber: place.priceNumber,
      location: place.location,
      workingHours: place.workingHours,
      activities: place.activities,
      ratingAvg: place.ratingAvg,
      totalBookings: place.totalBookings,
      canAfford: true,
      pricePerPerson: place.priceNumber,
      totalCost: place.priceNumber,
    );
  }

  @override
  Widget build(BuildContext context) {
    final langCode = context.locale.languageCode;
    final priceText = place.getPrice(langCode);

    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.07),
            blurRadius: 15.r,
            spreadRadius: 1.r,
            offset: Offset(0, 4.h),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Image Section ──
          _ImageSection(place: place),

          // ── Content ──
          Padding(
            padding: EdgeInsets.all(14.r),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Title + Favourite + Details ──
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        place.name.localized(langCode),
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textDark,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),

                    SizedBox(width: 8.w),

                    // ── Favourite Button ──
                    _FavouriteButton(place: place),

                    SizedBox(width: 8.w),

                    // ── Details Button ──
                    GestureDetector(
                      onTap: () => PlaceDetailsBottomSheet.show(
                        context,
                        _toPlaceItemResponseModel(),
                      ),
                      child: Icon(
                        Icons.info_outline_rounded,
                        color: AppColors.primary,
                        size: 22.sp,
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 8.h),

                // ── Location + Rating ──
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // ── Location ──
                    if (place.location != null)
                      Row(
                        children: [
                          Icon(
                            Icons.location_on_outlined,
                            color: AppColors.primary,
                            size: 14.sp,
                          ),
                          SizedBox(width: 4.w),
                          Text(
                            place.location!.localized(langCode),
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: AppColors.textLight,
                            ),
                          ),
                        ],
                      ),

                    // ── Rating ──
                    _StarRating(rating: place.ratingAvg),
                  ],
                ),

                SizedBox(height: 8.h),

                // ── Price + Free Badge ──
                Row(
                  children: [
                    // ── Free/Paid Badge ──
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10.w,
                        vertical: 4.h,
                      ),
                      decoration: BoxDecoration(
                        color: place.isFree
                            ? Colors.green.withOpacity(0.1)
                            : Colors.red.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20.r),
                        border: Border.all(
                          color: place.isFree
                              ? Colors.green.withOpacity(0.4)
                              : Colors.red.withOpacity(0.4),
                        ),
                      ),
                      child: Text(
                        place.isFree
                            ? AppTranslationKeys.exploreFree.tr()
                            : (priceText ??
                                  AppTranslationKeys.explorePaid.tr()),
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.bold,
                          color: place.isFree
                              ? Colors.green.shade700
                              : Colors.red.shade700,
                        ),
                      ),
                    ),

                    SizedBox(width: 8.w),

                    // ── Bookings Count ──
                    Row(
                      children: [
                        Icon(
                          Icons.bookmark_rounded,
                          color: AppColors.primary.withOpacity(0.6),
                          size: 14.sp,
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          AppTranslationKeys.exploreBookingsCount.tr(
                            namedArgs: {
                              'count': place.totalBookings.toString(),
                            },
                          ),
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: AppColors.textLight,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                SizedBox(height: 12.h),

                // ── Book Button أو Booked ──
                SizedBox(
                  width: double.infinity,
                  child: place.isBooked
                      // ── لو محجوز بيظهر زرار معطل ──
                      ? ElevatedButton.icon(
                          onPressed: null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey.shade300,
                            foregroundColor: Colors.grey.shade600,
                            padding: EdgeInsets.symmetric(vertical: 12.h),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            elevation: 0,
                          ),
                          icon: Icon(Icons.check_circle_rounded, size: 18.sp),
                          label: Text(
                            AppTranslationKeys.exploreBooked.tr(),
                            style: TextStyle(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        )
                      // ── لو مش محجوز بيظهر زرار الحجز ──
                      : ElevatedButton.icon(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => BookingScreen(
                                  placeId: place.id,
                                  placeName: place.name.localized(langCode),
                                  placeImage: place.imageUrl,
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
                            AppTranslationKeys.exploreBook.tr(),
                            style: TextStyle(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Image Section ────────────────────────────────────────────────────────────

class _ImageSection extends StatelessWidget {
  final ExplorePlaceModel place;

  const _ImageSection({required this.place});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
          child: place.imageUrl != null && place.imageUrl!.isNotEmpty
              ? Image.network(
                  _fixImageUrl(place.imageUrl!),
                  height: 180.h,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return _LoadingWidget();
                  },
                  errorBuilder: (context, error, stackTrace) {
                    debugPrint('❌ Image Error: $error');
                    return _ErrorWidget();
                  },
                )
              : _ImagePlaceholder(),
        ),

        // ── Booked Badge على الصورة ──
        if (place.isBooked)
          Positioned(
            top: 12.h,
            right: 12.w,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
              decoration: BoxDecoration(
                color: Colors.green.shade600,
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.check_circle_rounded,
                    color: Colors.white,
                    size: 12.sp,
                  ),
                  SizedBox(width: 4.w),
                  Text(
                    context.locale.languageCode == 'ar' ? 'تم الحجز' : 'Booked',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 11.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

class _LoadingWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200.h,
      width: double.infinity,
      color: const Color(0xFFF5F5F5), // لون هادي للتحميل
      child: const Center(
        child: CircularProgressIndicator(
          strokeWidth: 2,
          color: AppColors.primary,
        ),
      ),
    );
  }
}

class _ErrorWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200.h,
      width: double.infinity,
      color: const Color(0xFFE8D5B0),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.broken_image_outlined,
              color: Colors.grey.shade600,
              size: 40.sp,
            ),
            SizedBox(height: 8.h),
            Text(
              AppTranslationKeys.placesImageNotFound.tr(),
              style: TextStyle(color: Colors.grey.shade700, fontSize: 12.sp),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Favourite Button ─────────────────────────────────────────────────────────

class _FavouriteButton extends StatelessWidget {
  final ExplorePlaceModel place;

  const _FavouriteButton({required this.place});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.read<ExploreCubit>().toggleFavourite(place.id),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.all(6.r),
        decoration: BoxDecoration(
          color: place.isFavourite
              ? Colors.red.withOpacity(0.1)
              : Colors.grey.withOpacity(0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(
          place.isFavourite
              ? Icons.favorite_rounded
              : Icons.favorite_border_rounded,
          color: place.isFavourite ? Colors.red : Colors.grey,
          size: 20.sp,
        ),
      ),
    );
  }
}

// ─── Star Rating ──────────────────────────────────────────────────────────────

class _StarRating extends StatelessWidget {
  final double rating;

  const _StarRating({required this.rating});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ...List.generate(5, (i) {
          final starValue = i + 1;
          if (rating >= starValue) {
            return Icon(
              Icons.star_rounded,
              color: AppColors.rating,
              size: 16.sp,
            );
          } else if (rating >= starValue - 0.5) {
            return Icon(
              Icons.star_half_rounded,
              color: AppColors.rating,
              size: 16.sp,
            );
          } else {
            return Icon(
              Icons.star_outline_rounded,
              color: AppColors.rating,
              size: 16.sp,
            );
          }
        }),
        SizedBox(width: 4.w),
        Text(
          rating > 0 ? rating.toStringAsFixed(1) : '0.0',
          style: TextStyle(fontSize: 11.sp, color: AppColors.textLight),
        ),
      ],
    );
  }
}

// ─── Image Placeholder ────────────────────────────────────────────────────────

class _ImagePlaceholder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 180.h,
      color: const Color(0xFFE8D5B0),
      child: Center(
        child: Icon(
          Icons.image_not_supported_outlined,
          color: Colors.grey,
          size: 48.sp,
        ),
      ),
    );
  }
}

String _fixImageUrl(String url) {
  return url.replaceFirst('http://', 'https://');
}
