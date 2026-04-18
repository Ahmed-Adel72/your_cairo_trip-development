// lib/features/places/presentation/screens/places_list_screen.dart

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:your_cairo_trip/features/places/data/model/budget_response_model.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_translation_keys.dart';
import '../cubit/places_cubit.dart';
import '../cubit/places_state.dart';
import '../widgets/place_card_widget.dart';

class PlacesListScreen extends StatelessWidget {
  final BudgetResponseModel budgetResponse;

  const PlacesListScreen({super.key, required this.budgetResponse});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PlacesCubit, PlacesState>(
      builder: (context, state) {
        final bookedPlaceIds = state is PlacesSuccess
            ? state.bookedPlaceIds
            : <int>{};
        final totalBookedCost = state is PlacesSuccess
            ? state.totalBookedCost
            : 0;

        final langCode = context.locale.languageCode;
        final places = budgetResponse.selectedPlaces;
        final budgetInfo = budgetResponse.budgetInfo;

        final remainingAfterBooking = budgetInfo.remainingBudget.number;

        // ── نلف الـ Scaffold بـ PopScope عشان نتحكم في زرار الباك بتاع الموبايل ──
        return PopScope(
          canPop: false,
          onPopInvokedWithResult: (didPop, result) {
            if (!didPop) {
              // ── زرار الباك بتاع الموبايل → نرجع للصفحة الرئيسية مباشرة ──
              Navigator.of(context).pushNamedAndRemoveUntil('/home', (route) => false);
            }
          },
          child: Scaffold(
            backgroundColor: AppColors.background,
            appBar: AppBar(
              backgroundColor: AppColors.primary,
              elevation: 0,
              centerTitle: true,
              title: Text(
                AppTranslationKeys.placesTitle.tr(),
                style: TextStyle(
                  color: AppColors.white,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              // ── زرار الباك بتاع الـ AppBar → نرجع للصفحة الرئيسية مباشرة ──
              leading: IconButton(
                onPressed: () =>
                    Navigator.of(context).pushNamedAndRemoveUntil('/home', (route) => false),
                icon: Icon(
                  Icons.arrow_back_ios_rounded,
                  color: AppColors.white,
                  size: 20.sp,
                ),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(20.r),
                ),
              ),
            ),
            body: ListView(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
              children: [
                // ── Budget Section ──
                _BudgetSection(
                  budgetInfo: budgetInfo,
                  placesCount: places.length,
                  langCode: langCode,
                  totalBookedCost: totalBookedCost,
                  remainingAfterBooking: remainingAfterBooking,
                ),

                SizedBox(height: 8.h),

                // ── Empty State ──
                if (places.isEmpty)
                  _EmptyState()
                else
                  ...List.generate(
                    places.length,
                    (index) => PlaceCardWidget(
                      place: places[index],
                      index: index + 1,
                      isBooked:
                          bookedPlaceIds.contains(places[index].id) ||
                          places[index].isBooked,
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// ─── Budget Section ───────────────────────────────────────────────────────────

class _BudgetSection extends StatelessWidget {
  final BudgetInfoModel budgetInfo;
  final int placesCount;
  final String langCode;
  final num totalBookedCost;
  final num remainingAfterBooking;

  const _BudgetSection({
    required this.budgetInfo,
    required this.placesCount,
    required this.langCode,
    required this.totalBookedCost,
    required this.remainingAfterBooking,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(8.r),
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20.r),
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
          // ── 3 Budget Cards ──
          Row(
            children: [
              // ── الميزانية ──
              Expanded(
                child: _BudgetCard(
                  title: AppTranslationKeys.placesBudgetLabel.tr(),
                  amount: budgetInfo.enteredBudget.number.toString(),
                  currency: AppTranslationKeys.placesCurrency.tr(),
                  amountColor: AppColors.textDark,
                  backgroundColor: AppColors.primaryLight,
                  borderColor: AppColors.primary.withOpacity(0.3),
                  icon: Icons.account_balance_wallet_rounded,
                  iconColor: AppColors.primary,
                ),
              ),

              SizedBox(width: 10.w),

              // ── التكلفة ──
              Expanded(
                child: _BudgetCard(
                  title: AppTranslationKeys.placesCostLabel.tr(),
                  amount: budgetInfo.totalCost.number == 0
                      ? (langCode == 'ar' ? 'مجاني' : 'Free')
                      : budgetInfo.totalCost.number.toString(),
                  currency: budgetInfo.totalCost.number == 0
                      ? ''
                      : AppTranslationKeys.placesCurrency.tr(),
                  amountColor: Colors.orange.shade700,
                  backgroundColor: Colors.orange.withOpacity(0.08),
                  borderColor: Colors.orange.withOpacity(0.3),
                  icon: Icons.calculate_rounded,
                  iconColor: Colors.orange.shade700,
                  bookedCost: totalBookedCost > 0 ? totalBookedCost : null,
                  langCode: langCode,
                ),
              ),

              SizedBox(width: 10.w),

              // ── المتبقي ──
              Expanded(
                child: _BudgetCard(
                  title: AppTranslationKeys.placesRemainingLabel.tr(),
                  amount: totalBookedCost > 0
                      ? remainingAfterBooking.toString()
                      : budgetInfo.remainingBudget.number.toString(),
                  currency: AppTranslationKeys.placesCurrency.tr(),
                  amountColor: remainingAfterBooking >= 0
                      ? Colors.green.shade600
                      : Colors.red,
                  backgroundColor: remainingAfterBooking >= 0
                      ? Colors.green.withOpacity(0.08)
                      : Colors.red.withOpacity(0.08),
                  borderColor: remainingAfterBooking >= 0
                      ? Colors.green.withOpacity(0.3)
                      : Colors.red.withOpacity(0.3),
                  icon: remainingAfterBooking >= 0
                      ? Icons.savings_rounded
                      : Icons.warning_rounded,
                  iconColor: remainingAfterBooking >= 0
                      ? Colors.green.shade600
                      : Colors.red,
                ),
              ),
            ],
          ),

          SizedBox(height: 14.h),

          // ── Places Count ──
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: AppColors.primary.withOpacity(0.3)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.location_on_rounded,
                  color: AppColors.primary,
                  size: 16.sp,
                ),
                SizedBox(width: 6.w),
                Text(
                  AppTranslationKeys.placesCount.tr(
                    namedArgs: {'count': placesCount.toString()},
                  ),
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: AppColors.textDark,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 12.h),

          // ── Summary ──
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(12.r),
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.05),
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: Colors.grey.withOpacity(0.2)),
            ),
            child: Text(
              budgetInfo.summary.localized(langCode),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13.sp,
                color: AppColors.textMedium,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Budget Card ──────────────────────────────────────────────────────────────

class _BudgetCard extends StatelessWidget {
  final String title;
  final String amount;
  final String currency;
  final Color amountColor;
  final Color backgroundColor;
  final Color borderColor;
  final IconData icon;
  final Color iconColor;
  final num? bookedCost;
  final String? langCode;

  const _BudgetCard({
    required this.title,
    required this.amount,
    required this.currency,
    required this.amountColor,
    required this.backgroundColor,
    required this.borderColor,
    required this.icon,
    required this.iconColor,
    this.bookedCost,
    this.langCode,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 8.w),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: iconColor, size: 22.sp),
          SizedBox(height: 6.h),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 11.sp,
              color: AppColors.textLight,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 4.h),

          if (bookedCost != null && bookedCost! > 0) ...[
            Text(
              (num.parse(amount) - bookedCost!).toString(),
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: amountColor,
              ),
            ),
            SizedBox(height: 2.h),
            Container(
              width: 40.w,
              height: 1,
              color: Colors.orange.withOpacity(0.3),
            ),
            SizedBox(height: 2.h),
            Text(
              bookedCost.toString(),
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.w500,
                color: Colors.green.shade600,
                decoration: TextDecoration.lineThrough,
                decorationColor: Colors.green.shade600,
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              langCode == 'ar' ? 'محجوز' : 'booked',
              style: TextStyle(fontSize: 9.sp, color: Colors.green.shade600),
            ),
          ] else ...[
            Text(
              amount,
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: amountColor,
              ),
            ),
            if (currency.isNotEmpty) ...[
              SizedBox(height: 2.h),
              Text(
                currency,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 10.sp, color: AppColors.textLight),
              ),
            ],
          ],
        ],
      ),
    );
  }
}

// ─── Empty State ──────────────────────────────────────────────────────────────

class _EmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 40.h),
        child: Column(
          children: [
            Icon(
              Icons.location_off_rounded,
              size: 60.sp,
              color: AppColors.textLight,
            ),
            SizedBox(height: 16.h),
            Text(
              AppTranslationKeys.placesNoPlaces.tr(),
              style: TextStyle(
                fontSize: 16.sp,
                color: AppColors.textLight,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
