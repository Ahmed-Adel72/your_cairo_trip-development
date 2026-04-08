import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'app_colors.dart';

class AppTextStyles {
  AppTextStyles._();

  // ── App Bar ──
  static TextStyle get appTitle => TextStyle(
    fontSize: 18.sp,
    fontWeight: FontWeight.bold,
    color: AppColors.primary,
  );

  static TextStyle get settingsBtn => TextStyle(fontSize: 13.sp);

  // ── Badge ──
  static TextStyle get badge => TextStyle(
    color: AppColors.primaryDark,
    fontSize: 13.sp,
    fontWeight: FontWeight.w600,
  );

  // ── Headline ──
  static TextStyle get headlineBase => TextStyle(
    fontSize: 24.sp,
    fontWeight: FontWeight.bold,
    color: AppColors.textDark,
    height: 1.5,
  );

  static TextStyle get headlineHighlight => TextStyle(
    fontSize: 24.sp,
    fontWeight: FontWeight.bold,
    color: AppColors.primary,
    height: 1.5,
  );

  // ── Budget Card ──
  static TextStyle get budgetLabel => TextStyle(
    fontSize: 15.sp,
    fontWeight: FontWeight.w600,
    color: AppColors.textMedium,
  );

  static TextStyle get budgetAmount => TextStyle(
    fontSize: 18.sp,
    fontWeight: FontWeight.bold,
    color: AppColors.textDark,
  );
  static TextStyle get budgetHint => TextStyle(
    fontSize: 18.sp,
    fontWeight: FontWeight.w500,
    color: AppColors.textLight,
  );

  static TextStyle get currency => TextStyle(
    fontWeight: FontWeight.bold,
    color: AppColors.textLight,
    fontSize: 14.sp,
  );

  static TextStyle get discoverBtn =>
      TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold);

  // ── Places List ──
  static TextStyle get placeTitle => TextStyle(
    fontSize: 18.sp,
    fontWeight: FontWeight.bold,
    color: AppColors.textDark,
  );

  static TextStyle get placeLocation =>
      TextStyle(color: AppColors.textLight, fontSize: 13.sp);

  static TextStyle get placeDescription =>
      TextStyle(fontSize: 13.sp, color: AppColors.textDesc, height: 1.5);

  static TextStyle get freeBadge => TextStyle(
    color: AppColors.freeBadgeText,
    fontSize: 13.sp,
    fontWeight: FontWeight.w600,
  );

  static TextStyle get paidBadge => TextStyle(
    color: AppColors.paidBadgeText,
    fontSize: 13.sp,
    fontWeight: FontWeight.w600,
  );

  static TextStyle get indexBadge => TextStyle(
    color: AppColors.white,
    fontWeight: FontWeight.bold,
    fontSize: 14.sp,
  );
}
