// lib/features/explore/presentation/widgets/explore_search_bar_widget.dart

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_translation_keys.dart';

class ExploreSearchBarWidget extends StatefulWidget {
  final ValueChanged<String> onSearch;
  final VoidCallback onClear;

  const ExploreSearchBarWidget({
    super.key,
    required this.onSearch,
    required this.onClear,
  });

  @override
  State<ExploreSearchBarWidget> createState() => _ExploreSearchBarWidgetState();
}

class _ExploreSearchBarWidgetState extends State<ExploreSearchBarWidget> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 10.r,
            offset: Offset(0, 2.h),
          ),
        ],
      ),
      child: TextField(
        controller: _controller,
        onChanged: widget.onSearch,
        style: TextStyle(fontSize: 14.sp, color: AppColors.textDark),
        decoration: InputDecoration(
          hintText: AppTranslationKeys.exploreSearchHint.tr(),
          hintStyle: TextStyle(color: AppColors.textLight, fontSize: 14.sp),
          prefixIcon: Icon(
            Icons.search_rounded,
            color: AppColors.primary,
            size: 22.sp,
          ),
          suffixIcon: _controller.text.isNotEmpty
              ? GestureDetector(
                  onTap: () {
                    _controller.clear();
                    widget.onClear();
                  },
                  child: Icon(
                    Icons.close_rounded,
                    color: AppColors.textLight,
                    size: 20.sp,
                  ),
                )
              : null,
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(
            horizontal: 16.w,
            vertical: 14.h,
          ),
        ),
      ),
    );
  }
}
