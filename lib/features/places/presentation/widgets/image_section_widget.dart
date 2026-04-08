import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/constants/app_translation_keys.dart';

class ImageSectionWidget extends StatelessWidget {
  final String? imageUrl;
  final int index;

  const ImageSectionWidget({
    super.key,
    required this.imageUrl,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    // سطر للـ Debugging عشان تشوف اللينك اللي واصل فعلياً في الـ Run tab
    debugPrint('📸 Rendering Image URL: $imageUrl');

    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
          child: _buildImage(),
        ),

        // Index Badge
        Positioned(
          bottom: 10.h,
          right: 12.w,
          child: Container(
            width: 32.w,
            height: 32.h,
            decoration: const BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text('$index', style: AppTextStyles.indexBadge),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildImage() {
    // 1. التأكد إن اللينك موجود ومش فاضي
    if (imageUrl == null || imageUrl!.isEmpty) {
      return _ErrorWidget();
    }

    // 2. محاولة تحميل الصورة
    return Image.network(
      _fixImageUrl(imageUrl!),
      height: 200.h,
      width: double.infinity,
      fit: BoxFit.cover,
      // معالجة الخطأ لو اللينك بايظ أو الـ Server واقع
      errorBuilder: (context, error, stackTrace) {
        debugPrint('❌ Image Error: $error');
        return _ErrorWidget();
      },
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return _LoadingWidget();
      },
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

String _fixImageUrl(String url) {
  return url.replaceFirst('http://', 'https://');
}
