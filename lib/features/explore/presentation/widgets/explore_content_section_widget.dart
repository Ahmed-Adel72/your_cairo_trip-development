// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import '../../../../core/constants/app_colors.dart';
// import '../../../../core/constants/app_strings.dart';
// import '../../../../core/constants/app_text_styles.dart';
// import '../../../places/data/model/place_item_model.dart';
// import '../../../places/presentation/widgets/free_badge_widget.dart';
// import '../../../places/presentation/widgets/description_box_widget.dart';
// import '../../../places/presentation/widgets/place_details_bottom_sheet.dart';
// import '../../../booking/presentation/screens/booking_screen.dart';

// class ExploreContentSectionWidget extends StatelessWidget {
//   final PlaceItemModel place;

//   const ExploreContentSectionWidget({super.key, required this.place});

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: EdgeInsets.all(14.r),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // ── Title + Location Row ──
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               // Title
//               Expanded(
//                 child: Text(
//                   place.title,
//                   style: AppTextStyles.placeTitle,
//                   maxLines: 2,
//                   overflow: TextOverflow.ellipsis,
//                 ),
//               ),

//               SizedBox(width: 8.w),

//               // Location
//               GestureDetector(
//                 onTap: () => PlaceDetailsBottomSheet.show(context, place),
//                 child: Row(
//                   children: [
//                     Icon(
//                       Icons.location_on_outlined,
//                       color: AppColors.primary,
//                       size: 16.sp,
//                     ),
//                     SizedBox(width: 2.w),
//                     Text(
//                       AppStrings.locationText,
//                       style: TextStyle(
//                         fontSize: 13.sp,
//                         color: AppColors.primary,
//                         decoration: TextDecoration.underline,
//                         decorationColor: AppColors.primary,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),

//           SizedBox(height: 8.h),

//           // ── Stars + Badge Row ──
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               // Free / Paid Badge
//               FreeBadgeWidget(isFree: place.isFree),
//               // Stars
//               Row(
//                 children: List.generate(5, (i) {
//                   return Icon(
//                     i < 4 ? Icons.star_rounded : Icons.star_outline_rounded,
//                     color: AppColors.primary,
//                     size: 18.sp,
//                   );
//                 }),
//               ),
//             ],
//           ),

//           SizedBox(height: 10.h),

//           // ── Book Button ──
//           SizedBox(
//             width: double.infinity,
//             child: ElevatedButton.icon(
//               onPressed: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (_) => BookingScreen(
//                       placeName: place.title,
//                       placeImage: place.imageUrl,
//                     ),
//                   ),
//                 );
//               },
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: AppColors.primary,
//                 foregroundColor: AppColors.white,
//                 padding: EdgeInsets.symmetric(vertical: 12.h),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(12.r),
//                 ),
//                 elevation: 0,
//               ),
//               icon: Icon(Icons.add_circle_outline_rounded, size: 18.sp),
//               label: Text(
//                 AppStrings.bookTrip,
//                 style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.bold),
//               ),
//             ),
//           ),

//           SizedBox(height: 10.h),

//           // ── Description Box ──
//           DescriptionBoxWidget(description: place.description),
//         ],
//       ),
//     );
//   }
// }
