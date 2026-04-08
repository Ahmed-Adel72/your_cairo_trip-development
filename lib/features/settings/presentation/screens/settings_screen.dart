// lib/features/settings/presentation/screens/settings_screen.dart

import 'dart:ui' as ui;

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_translation_keys.dart';
import 'support_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final langCode = context.locale.languageCode;

    return Directionality(
      textDirection: langCode == 'ar'
          ? ui.TextDirection.rtl
          : ui.TextDirection.ltr,
      child: Scaffold(
        backgroundColor: AppColors.background,

        // ── AppBar ──
        appBar: AppBar(
          backgroundColor: AppColors.primary,
          elevation: 0,
          centerTitle: true,
          automaticallyImplyLeading: false,
          title: Text(
            AppTranslationKeys.settingsTitle.tr(),
            style: TextStyle(
              color: AppColors.white,
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(20.r)),
          ),
        ),

        body: SingleChildScrollView(
          padding: EdgeInsets.all(16.r),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 10.h),

              // ── Language Section ──
              _SectionTitle(
                title: langCode == 'ar' ? 'التفضيلات' : 'Preferences',
              ),
              SizedBox(height: 8.h),

              // ── Language Switcher ──
              _LanguageSwitcherCard(currentLang: langCode),

              SizedBox(height: 16.h),

              // ── General Section ──
              _SectionTitle(title: langCode == 'ar' ? 'عام' : 'General'),
              SizedBox(height: 8.h),

              // ── About App ──
              _SettingsItem(
                icon: Icons.info_outline_rounded,
                label: AppTranslationKeys.settingsAbout.tr(),
                subtitle: AppTranslationKeys.settingsAboutSubtitle.tr(),
                onTap: () {},
              ),

              SizedBox(height: 10.h),

              // ── Privacy Policy ──
              _SettingsItem(
                icon: Icons.privacy_tip_outlined,
                label: AppTranslationKeys.settingsPrivacy.tr(),
                subtitle: AppTranslationKeys.settingsPrivacySubtitle.tr(),
                onTap: () {},
              ),

              SizedBox(height: 10.h),

              // ── Visit Website ──
              _SettingsItem(
                icon: Icons.public_rounded,
                label: AppTranslationKeys.settingsWebsite.tr(),
                subtitle: AppTranslationKeys.settingsWebsiteSubtitle.tr(),
                iconColor: Colors.blue,
                onTap: () {},
                trailing: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10.w,
                    vertical: 4.h,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Text(
                    AppTranslationKeys.settingsWebsiteSoon.tr(),
                    style: TextStyle(
                      fontSize: 11.sp,
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              SizedBox(height: 16.h),

              // ── Support Section ──
              _SectionTitle(title: langCode == 'ar' ? 'الدعم' : 'Support'),
              SizedBox(height: 8.h),

              // ── Help & Support ──
              _SettingsItem(
                icon: Icons.help_outline_rounded,
                label: AppTranslationKeys.settingsSupport.tr(),
                subtitle: AppTranslationKeys.settingsSupportSubtitle.tr(),
                iconColor: Colors.green,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const SupportScreen()),
                  );
                },
              ),

              SizedBox(height: 24.h),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Section Title ────────────────────────────────────────────────────────────

class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: 4.w, left: 4.w),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 13.sp,
          fontWeight: FontWeight.bold,
          color: AppColors.textLight,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

// ─── Language Switcher Card ───────────────────────────────────────────────────

class _LanguageSwitcherCard extends StatelessWidget {
  final String currentLang;

  const _LanguageSwitcherCard({required this.currentLang});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8.r,
            offset: Offset(0, 2.h),
          ),
        ],
      ),
      child: Column(
        children: [
          // ── Header ──
          Row(
            children: [
              Container(
                width: 40.w,
                height: 40.h,
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Center(
                  child: Icon(
                    Icons.language_rounded,
                    color: AppColors.primary,
                    size: 20.sp,
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppTranslationKeys.settingsLanguage.tr(),
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textDark,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      AppTranslationKeys.settingsLanguageSubtitle.tr(),
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: AppColors.textLight,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          SizedBox(height: 14.h),

          // ── Language Options ──
          Row(
            children: [
              // ── Arabic ──
              Expanded(
                child: _LangOption(
                  flag: '🇪🇬',
                  label: AppTranslationKeys.settingsLanguageAr.tr(),
                  value: 'ar',
                  currentLang: currentLang,
                  onTap: () async {
                    if (currentLang != 'ar') {
                      await context.setLocale(const Locale('ar'));
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              AppTranslationKeys.settingsLanguageChanged.tr(),
                            ),
                            backgroundColor: AppColors.primary,
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                          ),
                        );
                      }
                    }
                  },
                ),
              ),

              SizedBox(width: 12.w),

              // ── English ──
              Expanded(
                child: _LangOption(
                  flag: '🇺🇸',
                  label: AppTranslationKeys.settingsLanguageEn.tr(),
                  value: 'en',
                  currentLang: currentLang,
                  onTap: () async {
                    if (currentLang != 'en') {
                      await context.setLocale(const Locale('en'));
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              AppTranslationKeys.settingsLanguageChanged.tr(),
                            ),
                            backgroundColor: AppColors.primary,
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                          ),
                        );
                      }
                    }
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Lang Option ──
class _LangOption extends StatelessWidget {
  final String flag;
  final String label;
  final String value;
  final String currentLang;
  final VoidCallback onTap;

  const _LangOption({
    required this.flag,
    required this.label,
    required this.value,
    required this.currentLang,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = currentLang == value;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(vertical: 10.h),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryLight : AppColors.background,
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.border,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(flag, style: TextStyle(fontSize: 18.sp)),
            SizedBox(width: 6.w),
            Text(
              label,
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? AppColors.primary : AppColors.textMedium,
              ),
            ),
            if (isSelected) ...[
              SizedBox(width: 4.w),
              Icon(
                Icons.check_circle_rounded,
                color: AppColors.primary,
                size: 14.sp,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// ─── Settings Item ────────────────────────────────────────────────────────────

class _SettingsItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String subtitle;
  final VoidCallback onTap;
  final Color? iconColor;
  final Widget? trailing;

  const _SettingsItem({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.onTap,
    this.iconColor,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(14.r),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8.r,
              offset: Offset(0, 2.h),
            ),
          ],
        ),
        child: Row(
          children: [
            // ── Icon ──
            Container(
              width: 40.w,
              height: 40.h,
              decoration: BoxDecoration(
                color: (iconColor ?? AppColors.primary).withOpacity(0.1),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Center(
                child: Icon(
                  icon,
                  color: iconColor ?? AppColors.primary,
                  size: 20.sp,
                ),
              ),
            ),

            SizedBox(width: 12.w),

            // ── Label + Subtitle ──
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textDark,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: AppColors.textLight,
                    ),
                  ),
                ],
              ),
            ),

            // ── Trailing ──
            trailing ??
                Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: AppColors.textLight,
                  size: 14.sp,
                ),
          ],
        ),
      ),
    );
  }
}
