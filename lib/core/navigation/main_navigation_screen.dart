// lib/core/navigation/main_navigation_screen.dart

import 'dart:ui' as ui;

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../constants/app_colors.dart';
import '../../features/home/presentation/screens/home_screen.dart';
import '../../features/profile/presentation/screens/profile_screen.dart';
import '../../features/settings/presentation/screens/settings_screen.dart';
import '../../features/explore/presentation/screens/explore_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 1;

  final List<Widget> _screens = const [
    ProfileScreen(),
    HomeScreen(),
    ExploreScreen(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final langCode = context.locale.languageCode;
    final isAr = langCode == 'ar';

    return Directionality(
      textDirection: isAr ? ui.TextDirection.rtl : ui.TextDirection.ltr,
      child: Scaffold(
        // ── Key هيخلي الـ IndexedStack يتبني من جديد لما اللغة تتغير ──
        body: IndexedStack(
          key: ValueKey(langCode),
          index: _currentIndex,
          children: _screens,
        ),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
            color: AppColors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 20.r,
                offset: Offset(0, -4.h),
              ),
            ],
          ),
          child: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _NavItem(
                    icon: Icons.person_rounded,
                    label: isAr ? 'الملف الشخصي' : 'Profile',
                    isActive: _currentIndex == 0,
                    onTap: () => setState(() => _currentIndex = 0),
                  ),
                  _NavItem(
                    icon: Icons.home_rounded,
                    label: isAr ? 'الرئيسية' : 'Home',
                    isActive: _currentIndex == 1,
                    onTap: () => setState(() => _currentIndex = 1),
                  ),
                  _NavItem(
                    icon: Icons.explore_rounded,
                    label: isAr ? 'استكشاف' : 'Explore',
                    isActive: _currentIndex == 2,
                    onTap: () => setState(() => _currentIndex = 2),
                  ),
                  _NavItem(
                    icon: Icons.settings_rounded,
                    label: isAr ? 'الإعدادات' : 'Settings',
                    isActive: _currentIndex == 3,
                    onTap: () => setState(() => _currentIndex = 3),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        padding: EdgeInsets.symmetric(
          horizontal: isActive ? 16.w : 12.w,
          vertical: 8.h,
        ),
        decoration: BoxDecoration(
          color: isActive
              ? AppColors.primary.withOpacity(0.12)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isActive ? AppColors.primary : AppColors.textLight,
              size: 24.sp,
            ),
            AnimatedSize(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              child: isActive
                  ? Row(
                      children: [
                        SizedBox(width: 6.w),
                        Text(
                          label,
                          style: TextStyle(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    )
                  : const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }
}
