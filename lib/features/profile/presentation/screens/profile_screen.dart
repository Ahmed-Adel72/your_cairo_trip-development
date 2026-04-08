// lib/features/profile/presentation/screens/profile_screen.dart

import 'dart:ui' as ui;

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_translation_keys.dart';
import '../../../../core/di/service_locator.dart';
import '../../../auth/presentation/screens/login_screen.dart';
import '../cubit/profile_cubit.dart';
import '../cubit/profile_state.dart';
import 'my_trips_screen.dart';
import 'favourites_screen.dart';
import 'my_bookings_screen.dart';
import 'edit_profile_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<ProfileCubit>()..getProfile(),
      child: const _ProfileView(),
    );
  }
}

class _ProfileView extends StatelessWidget {
  const _ProfileView();

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
            AppTranslationKeys.profileTitle.tr(),
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

        body: BlocConsumer<ProfileCubit, ProfileState>(
          listener: (context, state) {
            if (state is LogoutSuccess) {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const LoginScreen()),
                (_) => false,
              );
            }
            if (state is LogoutError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
              );
            }
          },
          builder: (context, state) {
            // ── Loading ──
            if (state is ProfileLoading) {
              return const Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              );
            }

            // ── Error ──
            if (state is ProfileError) {
              return _buildError(context, state.message);
            }

            if (state is ProfileLoaded ||
                state is ProfileUpdateSuccess ||
                state is LogoutLoading) {
              final profile = state is ProfileLoaded
                  ? state.profile
                  : state is ProfileUpdateSuccess
                  ? state.profile
                  : null;

              if (profile == null) {
                return const Center(
                  child: CircularProgressIndicator(color: AppColors.primary),
                );
              }

              final isLogoutLoading = state is LogoutLoading;

              return RefreshIndicator(
                color: AppColors.primary,
                onRefresh: () => context.read<ProfileCubit>().getProfile(),
                child: SingleChildScrollView(
                  // ── مهم عشان الـ RefreshIndicator يشتغل حتى لو المحتوى قصير ──
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Column(
                    children: [
                      // ── Profile Header ──
                      _ProfileHeader(
                        name: profile.name,
                        email: profile.email,
                        avatar: profile.avatar,
                        tripsCount: profile.tripsCount,
                        favouritesCount: profile.favouritesCount,
                        onTrips: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const MyTripsScreen(),
                          ),
                        ),
                        onFavourites: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const FavouritesScreen(),
                          ),
                        ),
                      ),

                      SizedBox(height: 20.h),

                      // ── Info Cards ──
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        child: Column(
                          children: [
                            _InfoCard(
                              icon: Icons.person_outline_rounded,
                              label: AppTranslationKeys.profileName.tr(),
                              value: profile.name,
                            ),
                            SizedBox(height: 12.h),
                            _InfoCard(
                              icon: Icons.email_outlined,
                              label: AppTranslationKeys.profileEmail.tr(),
                              value: profile.email,
                            ),
                            SizedBox(height: 12.h),
                            _InfoCard(
                              icon: Icons.phone_outlined,
                              label: AppTranslationKeys.profilePhone.tr(),
                              value: profile.phone,
                            ),

                            SizedBox(height: 20.h),

                            // ── My Bookings Button ──
                            _ActionButton(
                              icon: Icons.calendar_month_rounded,
                              label: AppTranslationKeys.myBookingsTitle.tr(),
                              color: AppColors.primary,
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const MyBookingsScreen(),
                                ),
                              ),
                            ),

                            SizedBox(height: 12.h),

                            // ── Edit Profile Button ──
                            _ActionButton(
                              icon: Icons.edit_rounded,
                              label: AppTranslationKeys.profileEdit.tr(),
                              color: AppColors.primary,
                              onTap: () async {
                                final updated = await Navigator.push<bool>(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        EditProfileScreen(profile: profile),
                                  ),
                                );
                                if (updated == true && context.mounted) {
                                  context.read<ProfileCubit>().getProfile();
                                }
                              },
                            ),

                            SizedBox(height: 12.h),

                            // ── Logout Button ──
                            _LogoutButton(
                              isLoading: isLogoutLoading,
                              onTap: () => _showLogoutDialog(context),
                            ),

                            SizedBox(height: 24.h),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }

            return const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          },
        ),
      ),
    );
  }

  // ── Error Widget ──
  Widget _buildError(BuildContext context, String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline_rounded, color: Colors.red, size: 60.sp),
          SizedBox(height: 16.h),
          Text(
            message,
            style: TextStyle(fontSize: 14.sp, color: AppColors.textLight),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 16.h),
          ElevatedButton(
            onPressed: () => context.read<ProfileCubit>().getProfile(),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
            ),
            child: Text(AppTranslationKeys.loading.tr()),
          ),
        ],
      ),
    );
  }

  // ── Logout Dialog ──
  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => Directionality(
        textDirection: context.locale.languageCode == 'ar'
            ? ui.TextDirection.rtl
            : ui.TextDirection.ltr,
        child: AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.r),
          ),
          title: Text(
            AppTranslationKeys.profileLogout.tr(),
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.textDark,
            ),
          ),
          content: Text(
            AppTranslationKeys.profileLogoutConfirm.tr(),
            style: TextStyle(fontSize: 14.sp, color: AppColors.textLight),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                context.locale.languageCode == 'ar' ? 'إلغاء' : 'Cancel',
                style: TextStyle(color: AppColors.textLight, fontSize: 14.sp),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                context.read<ProfileCubit>().logout();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: AppColors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.r),
                ),
              ),
              child: Text(
                AppTranslationKeys.profileLogout.tr(),
                style: TextStyle(fontSize: 14.sp),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Profile Header ───────────────────────────────────────────────────────────

class _ProfileHeader extends StatelessWidget {
  final String name;
  final String email;
  final String? avatar;
  final int tripsCount;
  final int favouritesCount;
  final VoidCallback onTrips;
  final VoidCallback onFavourites;

  const _ProfileHeader({
    required this.name,
    required this.email,
    required this.avatar,
    required this.tripsCount,
    required this.favouritesCount,
    required this.onTrips,
    required this.onFavourites,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 30.h),
      decoration: BoxDecoration(
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10.r,
            offset: Offset(0, 4.h),
          ),
        ],
      ),
      child: Column(
        children: [
          // ── Avatar ──
          Container(
            width: 90.w,
            height: 90.h,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primaryLight,
              border: Border.all(color: AppColors.primary, width: 3),
            ),
            child: avatar != null
                ? ClipOval(
                    child: Image.network(
                      avatar!,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => _defaultAvatar(),
                    ),
                  )
                : _defaultAvatar(),
          ),

          SizedBox(height: 12.h),

          // ── Name ──
          Text(
            name,
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.textDark,
            ),
          ),

          SizedBox(height: 4.h),

          // ── Email ──
          Text(
            email,
            style: TextStyle(fontSize: 13.sp, color: AppColors.textLight),
          ),

          SizedBox(height: 16.h),

          // ── Stats Row ──
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: onTrips,
                child: _StatItem(
                  label: AppTranslationKeys.profileTrips.tr(),
                  value: tripsCount.toString(),
                ),
              ),
              Container(height: 30.h, width: 1, color: AppColors.border),
              GestureDetector(
                onTap: onFavourites,
                child: _StatItem(
                  label: AppTranslationKeys.profileFavourites.tr(),
                  value: favouritesCount.toString(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _defaultAvatar() {
    return Center(
      child: Icon(Icons.person_rounded, color: AppColors.primary, size: 50.sp),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;

  const _StatItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            label,
            style: TextStyle(fontSize: 12.sp, color: AppColors.textLight),
          ),
        ],
      ),
    );
  }
}

// ─── Info Card ────────────────────────────────────────────────────────────────

class _InfoCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoCard({
    required this.icon,
    required this.label,
    required this.value,
  });

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
      child: Row(
        children: [
          Container(
            width: 40.w,
            height: 40.h,
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Center(
              child: Icon(icon, color: AppColors.primary, size: 20.sp),
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(fontSize: 12.sp, color: AppColors.textLight),
                ),
                SizedBox(height: 2.h),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textDark,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Action Button ────────────────────────────────────────────────────────────

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: AppColors.white,
          padding: EdgeInsets.symmetric(vertical: 14.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
          elevation: 0,
        ),
        icon: Icon(icon, size: 18.sp),
        label: Text(
          label,
          style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

// ─── Logout Button ────────────────────────────────────────────────────────────

class _LogoutButton extends StatelessWidget {
  final bool isLoading;
  final VoidCallback onTap;

  const _LogoutButton({required this.isLoading, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: isLoading ? null : onTap,
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.red,
          side: const BorderSide(color: Colors.red),
          padding: EdgeInsets.symmetric(vertical: 14.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
        ),
        icon: isLoading
            ? SizedBox(
                width: 18.w,
                height: 18.h,
                child: const CircularProgressIndicator(
                  color: Colors.red,
                  strokeWidth: 2,
                ),
              )
            : Icon(Icons.logout_rounded, size: 18.sp),
        label: Text(
          AppTranslationKeys.profileLogout.tr(),
          style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
