// lib/features/profile/presentation/screens/my_trips_screen.dart

import 'dart:ui' as ui;

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_translation_keys.dart';
import '../../../../core/di/service_locator.dart';
import '../../data/models/trip_model.dart';
import '../cubit/profile_cubit.dart';
import '../cubit/profile_state.dart';
import '../widgets/trip_card_widget.dart';

class MyTripsScreen extends StatelessWidget {
  const MyTripsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<ProfileCubit>()..getTrips(),
      child: const _MyTripsView(),
    );
  }
}

class _MyTripsView extends StatefulWidget {
  const _MyTripsView();

  @override
  State<_MyTripsView> createState() => _MyTripsViewState();
}

class _MyTripsViewState extends State<_MyTripsView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _showRatingDialog(BuildContext context, TripModel trip) {
    double selectedRating = trip.rating ?? 0;

    showDialog(
      context: context,
      builder: (_) => Directionality(
        textDirection: context.locale.languageCode == 'ar'
            ? ui.TextDirection.rtl
            : ui.TextDirection.ltr,
        child: StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.r),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12.r),
                    child: Image.network(
                      _fixImageUrl(trip.place.imageUrl),
                      height: 120.h,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        height: 120.h,
                        color: const Color(0xFFE8D5B0),
                        child: Center(
                          child: Icon(Icons.image_not_supported, size: 30.sp),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    AppTranslationKeys.myTripsRateTitle.tr(),
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: AppColors.textLight,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    trip.place.name.localized(context.locale.languageCode),
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textDark,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 16.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(5, (i) {
                      return GestureDetector(
                        onTap: () =>
                            setDialogState(() => selectedRating = i + 1.0),
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 4.w),
                          child: Icon(
                            i < selectedRating
                                ? Icons.star_rounded
                                : Icons.star_outline_rounded,
                            color: AppColors.primary,
                            size: 36.sp,
                          ),
                        ),
                      );
                    }),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    _getRatingLabel(
                      selectedRating,
                      context.locale.languageCode,
                    ),
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 20.h),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: selectedRating == 0
                          ? null
                          : () {
                              Navigator.pop(context);
                              context.read<ProfileCubit>().rateTrip(
                                tripId: trip.id,
                                rating: selectedRating,
                              );
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: AppColors.white,
                        disabledBackgroundColor: AppColors.border,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 12.h),
                      ),
                      child: Text(
                        AppTranslationKeys.myTripsRateSave.tr(),
                        style: TextStyle(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  String _getRatingLabel(double rating, String langCode) {
    if (rating == 0) {
      return langCode == 'ar' ? 'اختر تقييمك' : 'Choose your rating';
    }
    if (rating == 1) return langCode == 'ar' ? '😞 سيء' : '😞 Bad';
    if (rating == 2) return langCode == 'ar' ? '😐 مقبول' : '😐 Fair';
    if (rating == 3) return langCode == 'ar' ? '🙂 جيد' : '🙂 Good';
    if (rating == 4) return langCode == 'ar' ? '😊 جيد جداً' : '😊 Very Good';
    return langCode == 'ar' ? '🤩 ممتاز' : '🤩 Excellent';
  }

  @override
  Widget build(BuildContext context) {
    final langCode = context.locale.languageCode;

    return Directionality(
      textDirection: langCode == 'ar'
          ? ui.TextDirection.rtl
          : ui.TextDirection.ltr,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.primary,
          elevation: 0,
          centerTitle: true,
          title: Text(
            AppTranslationKeys.myTripsTitle.tr(),
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
          bottom: TabBar(
            controller: _tabController,
            indicatorColor: AppColors.white,
            indicatorWeight: 3,
            labelColor: AppColors.white,
            unselectedLabelColor: AppColors.white.withOpacity(0.6),
            labelStyle: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold),
            tabs: [
              Tab(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.check_circle_outline_rounded, size: 18.sp),
                    SizedBox(width: 6.w),
                    Text(AppTranslationKeys.myTripsCompleted.tr()),
                  ],
                ),
              ),
              Tab(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.upcoming_outlined, size: 18.sp),
                    SizedBox(width: 6.w),
                    Text(AppTranslationKeys.myTripsUpcoming.tr()),
                  ],
                ),
              ),
            ],
          ),
        ),
        body: BlocConsumer<ProfileCubit, ProfileState>(
          listener: (context, state) {
            if (state is RatingSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: AppColors.primary,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  content: Text(
                    AppTranslationKeys.myTripsRateSuccess.tr(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              );
            }
            if (state is RatingError) {
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
            if (state is TripsLoading || state is RatingLoading) {
              return const Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              );
            }

            if (state is TripsError) {
              return _buildError(context, state.message);
            }

            if (state is TripsLoaded) {
              return TabBarView(
                controller: _tabController,
                children: [
                  _buildTripsList(
                    context: context,
                    trips: state.completedTrips,
                    isCompleted: true,
                  ),
                  _buildTripsList(
                    context: context,
                    trips: state.upcomingTrips,
                    isCompleted: false,
                  ),
                ],
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

  Widget _buildTripsList({
    required BuildContext context,
    required List<TripModel> trips,
    required bool isCompleted,
  }) {
    if (trips.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isCompleted
                  ? Icons.check_circle_outline_rounded
                  : Icons.upcoming_outlined,
              color: AppColors.textLight,
              size: 60.sp,
            ),
            SizedBox(height: 16.h),
            Text(
              isCompleted
                  ? AppTranslationKeys.myTripsNoCompleted.tr()
                  : AppTranslationKeys.myTripsNoUpcoming.tr(),
              style: TextStyle(fontSize: 16.sp, color: AppColors.textLight),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      color: AppColors.primary,
      onRefresh: () => context.read<ProfileCubit>().getTrips(),
      child: ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.all(16.r),
        itemCount: trips.length,
        itemBuilder: (context, index) {
          return TripCardWidget(
            trip: trips[index],
            isCompleted: isCompleted,
            onRate: isCompleted
                ? () => _showRatingDialog(context, trips[index])
                : null,
          );
        },
      ),
    );
  }

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
            onPressed: () => context.read<ProfileCubit>().getTrips(),
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
}

String _fixImageUrl(String url) {
  return url.replaceFirst('http://', 'https://');
}
