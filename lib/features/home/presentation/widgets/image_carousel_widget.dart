// lib/features/home/presentation/widgets/image_carousel_widget.dart

import 'dart:async';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_translation_keys.dart';
import '../../data/models/place_model.dart';

class ImageCarouselWidget extends StatefulWidget {
  final List<PlaceModel> places;

  const ImageCarouselWidget({super.key, required this.places});

  @override
  State<ImageCarouselWidget> createState() => _ImageCarouselWidgetState();
}

class _ImageCarouselWidgetState extends State<ImageCarouselWidget> {
  late final PageController _pageController;
  int _currentPage = 0;
  Timer? _autoScrollTimer;

  static const Duration _autoScrollDuration = Duration(seconds: 3);
  static const Duration _animationDuration = Duration(milliseconds: 600);
  static const Curve _animationCurve = Curves.easeInOut;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
    _startAutoScroll();
  }

  @override
  void dispose() {
    _stopAutoScroll();
    _pageController.dispose();
    super.dispose();
  }

  void _startAutoScroll() {
    _autoScrollTimer = Timer.periodic(_autoScrollDuration, (_) {
      if (!mounted) return;
      final int nextPage = (_currentPage + 1) % widget.places.length;
      _pageController.animateToPage(
        nextPage,
        duration: _animationDuration,
        curve: _animationCurve,
      );
    });
  }

  void _stopAutoScroll() {
    _autoScrollTimer?.cancel();
    _autoScrollTimer = null;
  }

  void _onUserDragStart(DragStartDetails details) => _stopAutoScroll();
  void _onUserDragEnd(DragEndDetails details) => _startAutoScroll();
  void _onPageChanged(int index) => setState(() => _currentPage = index);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.w),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20.r),
        child: Stack(
          children: [
            // ── Page View ──
            SizedBox(
              height: 220.h,
              child: GestureDetector(
                onHorizontalDragStart: _onUserDragStart,
                onHorizontalDragEnd: _onUserDragEnd,
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: widget.places.length,
                  onPageChanged: _onPageChanged,
                  itemBuilder: (context, index) {
                    return _CarouselImage(place: widget.places[index]);
                  },
                ),
              ),
            ),

            // ── Dot Indicators ──
            Positioned(
              bottom: 10.h,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  widget.places.length,
                  (index) => _DotIndicator(isActive: index == _currentPage),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Carousel Image ───────────────────────────────────────────────────────────

class _CarouselImage extends StatelessWidget {
  final PlaceModel place;

  const _CarouselImage({required this.place});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      place.imageUrl,
      fit: BoxFit.cover,
      width: double.infinity,
      errorBuilder: (_, __, ___) => _ErrorWidget(),
    );
  }
}

// ─── Error Widget ─────────────────────────────────────────────────────────────

class _ErrorWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFE8D5B0),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.image_not_supported, color: Colors.grey, size: 50.sp),
            SizedBox(height: 8.h),
            Text(
              // ── مترجم ──
              AppTranslationKeys.placesImageNotFound.tr(),
              style: TextStyle(color: Colors.grey, fontSize: 13.sp),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Dot Indicator ────────────────────────────────────────────────────────────

class _DotIndicator extends StatelessWidget {
  final bool isActive;

  const _DotIndicator({required this.isActive});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      width: isActive ? 20.w : 8.w,
      height: 8.h,
      decoration: BoxDecoration(
        color: isActive ? AppColors.white : AppColors.white.withOpacity(0.5),
        borderRadius: BorderRadius.circular(4.r),
      ),
    );
  }
}
