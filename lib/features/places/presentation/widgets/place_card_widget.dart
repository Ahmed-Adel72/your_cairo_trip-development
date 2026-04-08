// lib/features/places/presentation/widgets/place_card_widget.dart

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:your_cairo_trip/features/places/data/model/budget_response_model.dart';
import '../../../../core/constants/app_colors.dart';
import 'image_section_widget.dart';
import 'content_section_widget.dart';

class PlaceCardWidget extends StatelessWidget {
  final PlaceItemResponseModel place;
  final int index;

  // ── جديد ──
  final bool isBooked;

  const PlaceCardWidget({
    super.key,
    required this.place,
    required this.index,
    this.isBooked = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 20.h),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 15.r,
            spreadRadius: 2.r,
            offset: Offset(0, 4.h),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Image Section ──
          ImageSectionWidget(imageUrl: place.imageUrl, index: index),

          // ── Content Section ──
          ContentSectionWidget(place: place, isBooked: isBooked),
        ],
      ),
    );
  }
}
