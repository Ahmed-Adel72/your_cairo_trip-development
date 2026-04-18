// lib/features/profile/presentation/screens/my_bookings_screen.dart

import 'dart:ui' as ui;

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_translation_keys.dart';
import '../../../../core/di/service_locator.dart';
import '../../data/models/booking_list_model.dart';
import '../cubit/profile_cubit.dart';
import '../cubit/profile_state.dart';

class MyBookingsScreen extends StatelessWidget {
  const MyBookingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<ProfileCubit>()..getBookings(),
      child: const _MyBookingsView(),
    );
  }
}

class _MyBookingsView extends StatelessWidget {
  const _MyBookingsView();

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
          title: Text(
            AppTranslationKeys.myBookingsTitle.tr(),
            style: TextStyle(
              color: AppColors.white,
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(
              Icons.arrow_back_ios_rounded,
              color: AppColors.white,
              size: 20.sp,
            ),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(20.r)),
          ),
        ),

        body: BlocConsumer<ProfileCubit, ProfileState>(
          listener: (context, state) {
            // ── Cancel Success ──
            if (state is BookingCancelSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: Colors.green,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  content: Text(
                    AppTranslationKeys.myBookingsCancelSuccess.tr(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              );
            }

            // ── Cancel Error ──
            if (state is BookingCancelError) {
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
            if (state is BookingsLoading) {
              return const Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              );
            }

            // ── Error ──
            if (state is BookingsError) {
              return _buildError(context, state.message);
            }

            // ── Loaded ──
            if (state is BookingsLoaded) {
              if (state.bookings.isEmpty) {
                return _buildEmptyState();
              }

              return RefreshIndicator(
                color: AppColors.primary,
                onRefresh: () => context.read<ProfileCubit>().getBookings(),
                child: ListView.builder(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.all(16.r),
                  itemCount: state.bookings.length,
                  itemBuilder: (context, index) {
                    return _BookingCard(
                      booking: state.bookings[index],
                      onCancel:
                          state.bookings[index].status == 'pending' ||
                              state.bookings[index].status == 'confirmed'
                          ? () => _showCancelDialog(
                              context,
                              state.bookings[index].id,
                            )
                          : null,
                    );
                  },
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

  // ── Cancel Dialog ──
  void _showCancelDialog(BuildContext context, int bookingId) {
    final langCode = context.locale.languageCode;

    showDialog(
      context: context,
      builder: (_) => Directionality(
        textDirection: langCode == 'ar'
            ? ui.TextDirection.rtl
            : ui.TextDirection.ltr,
        child: AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.r),
          ),
          title: Text(
            AppTranslationKeys.myBookingsCancel.tr(),
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.textDark,
            ),
          ),
          content: Text(
            AppTranslationKeys.myBookingsCancelConfirm.tr(),
            style: TextStyle(fontSize: 14.sp, color: AppColors.textLight),
          ),
          actions: [
            // ── Keep ──
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                langCode == 'ar' ? 'تراجع' : 'Keep',
                style: TextStyle(color: AppColors.textLight, fontSize: 14.sp),
              ),
            ),
            // ── Cancel ──
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                context.read<ProfileCubit>().cancelBooking(bookingId);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.r),
                ),
              ),
              child: Text(
                AppTranslationKeys.myBookingsCancel.tr(),
                style: TextStyle(fontSize: 14.sp),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Empty State ──
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.calendar_today_outlined,
            color: AppColors.textLight,
            size: 70.sp,
          ),
          SizedBox(height: 16.h),
          Text(
            AppTranslationKeys.myBookingsNoBookings.tr(),
            style: TextStyle(fontSize: 16.sp, color: AppColors.textLight),
          ),
        ],
      ),
    );
  }

  // ── Error State ──
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
            onPressed: () => context.read<ProfileCubit>().getBookings(),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
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
}

// ─── Booking Card ─────────────────────────────────────────────────────────────

class _BookingCard extends StatelessWidget {
  final BookingListModel booking;
  final VoidCallback? onCancel;

  const _BookingCard({required this.booking, this.onCancel});

  @override
  Widget build(BuildContext context) {
    final langCode = context.locale.languageCode;
    final statusConfig = _getStatusConfig(booking.status);

    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.07),
            blurRadius: 12.r,
            offset: Offset(0, 4.h),
          ),
        ],
      ),
      child: Column(
        children: [
          // ── Image + Status Badge ──
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
                child: Image.network(
                  _fixImageUrl(booking.place.imageUrl),
                  height: 150.h,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    height: 150.h,
                    color: const Color(0xFFE8D5B0),
                    child: Center(
                      child: Icon(
                        Icons.image_not_supported,
                        color: Colors.grey,
                        size: 30.sp,
                      ),
                    ),
                  ),
                ),
              ),

              // ── Status Badge ──
              Positioned(
                top: 10.h,
                left: langCode == 'ar' ? null : 10.w,
                right: langCode == 'ar' ? 10.w : null,
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10.w,
                    vertical: 4.h,
                  ),
                  decoration: BoxDecoration(
                    color: statusConfig['color'] as Color,
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        statusConfig['icon'] as IconData,
                        color: Colors.white,
                        size: 12.sp,
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        booking.statusLabel.localized(langCode),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 11.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // ── Content ──
          Padding(
            padding: EdgeInsets.all(14.r),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Place Name ──
                Text(
                  booking.place.name.localized(langCode),
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textDark,
                  ),
                ),

                SizedBox(height: 6.h),

                // ── Location ──
                Row(
                  children: [
                    Icon(
                      Icons.location_on_outlined,
                      color: AppColors.textLight,
                      size: 14.sp,
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      booking.place.location.localized(langCode),
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: AppColors.textLight,
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 10.h),

                // ── Info Chips ──
                Wrap(
                  spacing: 8.w,
                  runSpacing: 6.h,
                  children: [
                    _InfoChip(
                      icon: Icons.calendar_today_rounded,
                      label: booking.bookingDate,
                    ),
                    _InfoChip(
                      icon: Icons.people_rounded,
                      label:
                          '${booking.personCount} ${langCode == 'ar' ? 'أفراد' : 'People'}',
                    ),
                    _InfoChip(
                      icon: Icons.payments_outlined,
                      label: booking.totalPrice.localized(langCode),
                    ),
                  ],
                ),

                // ── Cancel Button ──
                if (onCancel != null) ...[
                  SizedBox(height: 12.h),
                  const Divider(color: Color(0xFFEEEEEE)),
                  SizedBox(height: 8.h),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: onCancel,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.red,
                        side: const BorderSide(color: Colors.red),
                        padding: EdgeInsets.symmetric(vertical: 10.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                      ),
                      icon: Icon(Icons.cancel_outlined, size: 16.sp),
                      label: Text(
                        AppTranslationKeys.myBookingsCancel.tr(),
                        style: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Status Config ──
  Map<String, dynamic> _getStatusConfig(String status) {
    switch (status) {
      case 'confirmed':
        return {'color': Colors.green, 'icon': Icons.check_circle_rounded};
      case 'cancelled':
        return {'color': Colors.red, 'icon': Icons.cancel_rounded};
      case 'completed':
        return {'color': Colors.blue, 'icon': Icons.done_all_rounded};
      default: // pending
        return {'color': Colors.orange, 'icon': Icons.hourglass_empty_rounded};
    }
  }
}

// ─── Info Chip ────────────────────────────────────────────────────────────────

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _InfoChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: AppColors.primary, size: 12.sp),
          SizedBox(width: 4.w),
          Text(
            label,
            style: TextStyle(fontSize: 11.sp, color: AppColors.textMedium),
          ),
        ],
      ),
    );
  }
}

String _fixImageUrl(String url) {
  return url.replaceFirst('http://', 'https://');
}
