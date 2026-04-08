// lib/features/booking/presentation/widgets/booking_header_widget.dart

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_translation_keys.dart';

class BookingHeaderWidget extends StatelessWidget {
  final String placeName;
  // ── بقى nullable عشان الـ API ممكن ميرجعش image ──
  final String? placeImage;

  const BookingHeaderWidget({
    super.key,
    required this.placeName,
    this.placeImage,
  });

  @override
  Widget build(BuildContext context) {
    final langCode = context.locale.languageCode;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Place Image ──
        ClipRRect(
          borderRadius: BorderRadius.circular(16.r),
          child: placeImage != null && placeImage!.isNotEmpty
              // ── Image.network بدل Image.asset ──
              ? Image.network(
                  _fixImageUrl(placeImage!),
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
              : _PlaceholderWidget(),
        ),

        SizedBox(height: 16.h),

        // ── Place Name ──
        RichText(
          text: TextSpan(
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.textDark,
            ),
            children: [
              TextSpan(
                // ── مترجم حسب اللغة ──
                text: langCode == 'ar' ? 'المكان : ' : 'Place: ',
              ),
              TextSpan(
                text: placeName,
                style: TextStyle(
                  color: AppColors.primary,
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),

        SizedBox(height: 6.h),

        // ── Subtitle ──
        Text(
          AppTranslationKeys.bookingSelectDate.tr(),
          style: TextStyle(color: AppColors.textLight, fontSize: 14.sp),
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

// ─── Placeholder ──────────────────────────────────────────────────────────────

class _PlaceholderWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 180.h,
      decoration: BoxDecoration(
        color: const Color(0xFFE8D5B0),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Center(
        child: Icon(Icons.image_not_supported, color: Colors.grey, size: 50.sp),
      ),
    );
  }
}

String _fixImageUrl(String url) {
  return url.replaceFirst('http://', 'https://');
}
