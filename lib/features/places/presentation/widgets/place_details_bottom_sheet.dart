// lib/features/places/presentation/widgets/place_details_bottom_sheet.dart

import 'dart:ui';
import 'dart:ui' as ui;
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:your_cairo_trip/features/places/data/model/budget_response_model.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_translation_keys.dart';

class PlaceDetailsBottomSheet extends StatelessWidget {
  final PlaceItemResponseModel place;

  const PlaceDetailsBottomSheet({super.key, required this.place});

  static void show(BuildContext context, PlaceItemResponseModel place) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => PlaceDetailsBottomSheet(place: place),
    );
  }

  @override
  Widget build(BuildContext context) {
    final langCode = context.locale.languageCode;
    final priceText = place.getPrice(langCode);

    return Directionality(
      textDirection: langCode == 'ar'
          ? ui.TextDirection.rtl
          : ui.TextDirection.ltr,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          height:
              MediaQuery.of(context).size.height *
              0.8, // زودت الطول شوية عشان الأنشطة
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.97),
            borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
          ),
          child: Column(
            children: [
              // ── Image Section ──
              _ImageSection(place: place),

              // ── Details Content ──
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(16.r),
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ── Name ──
                      Text(
                        place.name.localized(langCode),
                        style: TextStyle(
                          fontSize: 22.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textDark,
                        ),
                      ),

                      if (place.description != null) ...[
                        SizedBox(height: 8.h),
                        Text(
                          place.description!.localized(langCode),
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: AppColors.textMedium,
                            height: 1.4,
                          ),
                        ),
                      ],

                      SizedBox(height: 20.h),

                      // ── Price Section ──
                      _SectionCard(
                        icon: Icons.confirmation_number_outlined,
                        title: AppTranslationKeys.placeDetailsTicketPrice.tr(),
                        child: Text(
                          place.isFree
                              ? AppTranslationKeys.placeDetailsFreeEntry.tr()
                              : (priceText ?? ''),
                          style: TextStyle(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.bold,
                            color: place.isFree
                                ? Colors.green.shade600
                                : Colors.red,
                          ),
                        ),
                      ),

                      SizedBox(height: 12.h),

                      // ── Working Hours Section ──
                      _SectionCard(
                        icon: Icons.access_time_rounded,
                        title: AppTranslationKeys.placeDetailsWorkingHours.tr(),
                        child: Text(
                          place.workingHours != null
                              ? place.workingHours!.localized(langCode)
                              : AppTranslationKeys.placeDetailsNoWorkingHours
                                    .tr(),
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: AppColors.textLight,
                            height: 1.5,
                          ),
                        ),
                      ),

                      SizedBox(height: 12.h),

                      // ── Location Section ──
                      if (place.location != null) ...[
                        _SectionCard(
                          icon: Icons.location_on_outlined,
                          title: AppTranslationKeys.placeDetailsLocation.tr(),
                          child: Text(
                            place.location!.localized(
                              langCode,
                            ), // تعديل: استخدمت localized
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: AppColors.textLight,
                              height: 1.5,
                            ),
                          ),
                        ),
                        SizedBox(height: 12.h),
                      ],

                      // ── Activities Section ──
                      _SectionCard(
                        icon: Icons.local_activity_outlined,
                        title: AppTranslationKeys.placeDetailsActivities.tr(),
                        child: place.activities.isEmpty
                            ? Text(
                                AppTranslationKeys.placeDetailsNoActivities
                                    .tr(),
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  color: AppColors.textLight,
                                ),
                              )
                            : Column(
                                children: place.activities
                                    .asMap()
                                    .entries
                                    .map(
                                      (entry) => _ActivityItem(
                                        index: entry.key + 1,
                                        activity: entry.value.localized(
                                          langCode,
                                        ),
                                      ),
                                    )
                                    .toList(),
                              ),
                      ),

                      SizedBox(height: 24.h),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Image Section ────────────────────────────────────────────────────────────

class _ImageSection extends StatelessWidget {
  final PlaceItemResponseModel place;

  const _ImageSection({required this.place});

  @override
  Widget build(BuildContext context) {
    final langCode = context.locale.languageCode;

    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
          child: place.imageUrl != null && place.imageUrl!.isNotEmpty
              ? Image.network(
                  place.imageUrl!,
                  height: 220.h,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    debugPrint('❌ Image Error: $error');
                    return _ErrorWidget();
                  },
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return _LoadingWidget();
                  },
                )
              : _ImagePlaceholder(),
        ),

        // Gradient Overlay
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            height: 100.h,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [Colors.black.withOpacity(0.7), Colors.transparent],
              ),
            ),
          ),
        ),

        // Close Button
        Positioned(
          top: 16.h,
          left: 16.w,
          child: InkWell(
            onTap: () => Navigator.pop(context),
            child: CircleAvatar(
              backgroundColor: Colors.black26,
              radius: 18.r,
              child: Icon(
                Icons.close_rounded,
                color: Colors.white,
                size: 22.sp,
              ),
            ),
          ),
        ),

        // Name on Image
        Positioned(
          bottom: 16.h,
          right: 16.w,
          left: 16.w,
          child: Text(
            place.name.localized(langCode),
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              shadows: const [Shadow(blurRadius: 10, color: Colors.black)],
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
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

// ─── Section Card ─────────────────────────────────────────────────────────────

class _SectionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final Widget child;

  const _SectionCard({
    required this.icon,
    required this.title,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: Colors.grey.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: AppColors.primary, size: 20.sp),
              SizedBox(width: 8.w),
              Text(
                title,
                style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark,
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8.h),
            child: Divider(color: Colors.grey.withOpacity(0.1), height: 1),
          ),
          child,
        ],
      ),
    );
  }
}

// ─── Activity Item ────────────────────────────────────────────────────────────

class _ActivityItem extends StatelessWidget {
  final int index;
  final String activity;

  const _ActivityItem({required this.index, required this.activity});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 10.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(6.r),
            decoration: const BoxDecoration(
              color: AppColors.primaryLight,
              shape: BoxShape.circle,
            ),
            child: Text(
              '$index',
              style: TextStyle(
                fontSize: 11.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Text(
              activity,
              style: TextStyle(
                fontSize: 14.sp,
                color: AppColors.textMedium,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Image Placeholder ────────────────────────────────────────────────────────

class _ImagePlaceholder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 220.h,
      width: double.infinity,
      color: const Color(0xFFF3F3F3),
      child: Icon(
        Icons.image_not_supported_outlined,
        color: Colors.grey,
        size: 48.sp,
      ),
    );
  }
}
