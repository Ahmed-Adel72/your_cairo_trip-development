// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import '../../../../core/constants/app_colors.dart';
// import '../../../../core/constants/app_text_styles.dart';
// import '../../../../core/constants/app_strings.dart';

// class ExploreImageSectionWidget extends StatelessWidget {
//   final String imageUrl;
//   final int index;
//   final bool isFavourite;
//   final VoidCallback onFavouriteToggle;

//   const ExploreImageSectionWidget({
//     super.key,
//     required this.imageUrl,
//     required this.index,
//     required this.isFavourite,
//     required this.onFavouriteToggle,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       children: [
//         // ── Place Image ──
//         ClipRRect(
//           borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
//           child: Image.asset(
//             imageUrl,
//             height: 180.h,
//             width: double.infinity,
//             fit: BoxFit.cover,
//             errorBuilder: (context, error, stackTrace) => Container(
//               height: 180.h,
//               width: double.infinity,
//               color: const Color(0xFFE8D5B0),
//               child: Center(
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Icon(
//                       Icons.image_not_supported,
//                       color: Colors.grey,
//                       size: 50.sp,
//                     ),
//                     SizedBox(height: 8.h),
//                     Text(
//                       AppStrings.imageNotFound,
//                       style: TextStyle(color: Colors.grey, fontSize: 13.sp),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ),

//         // ─────────────────────────────────────
//         // ✅ Favourite Button (أعلى يسار)
//         // ─────────────────────────────────────
//         Positioned(
//           top: 10.h,
//           left: 10.w,
//           child: GestureDetector(
//             onTap: onFavouriteToggle,
//             child: AnimatedContainer(
//               duration: const Duration(milliseconds: 300),
//               width: 38.w,
//               height: 38.h,
//               decoration: BoxDecoration(
//                 color: isFavourite
//                     ? AppColors.primary
//                     : Colors.black.withOpacity(0.4),
//                 shape: BoxShape.circle,
//                 boxShadow: [
//                   BoxShadow(
//                     color: isFavourite
//                         ? AppColors.primary.withOpacity(0.4)
//                         : Colors.black.withOpacity(0.2),
//                     blurRadius: 8.r,
//                     offset: Offset(0, 2.h),
//                   ),
//                 ],
//               ),
//               child: Center(
//                 child: AnimatedSwitcher(
//                   duration: const Duration(milliseconds: 300),
//                   transitionBuilder: (child, animation) =>
//                       ScaleTransition(scale: animation, child: child),
//                   child: Icon(
//                     isFavourite
//                         ? Icons.favorite_rounded
//                         : Icons.favorite_border_rounded,
//                     key: ValueKey(isFavourite),
//                     color: AppColors.white,
//                     size: 20.sp,
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ),

//         // ── Index Number Badge (أسفل يمين) ──
//         Positioned(
//           bottom: 10.h,
//           right: 12.w,
//           child: Container(
//             width: 30.w,
//             height: 30.h,
//             decoration: const BoxDecoration(
//               color: AppColors.primary,
//               shape: BoxShape.circle,
//             ),
//             child: Center(
//               child: Text('$index', style: AppTextStyles.indexBadge),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }
