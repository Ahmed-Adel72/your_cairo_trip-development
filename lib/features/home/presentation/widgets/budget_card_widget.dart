// lib/features/places/presentation/widgets/budget_card_widget.dart

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_translation_keys.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/widgets/custom_button.dart';

class BudgetCardWidget extends StatelessWidget {
  final TextEditingController budgetController;
  final TextEditingController personCountController;
  final VoidCallback onDiscover;
  final bool isLoading;

  const BudgetCardWidget({
    super.key,
    required this.budgetController,
    required this.personCountController,
    required this.onDiscover,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.r),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 12.r,
            offset: Offset(0, 4.h),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Budget Label ──
          Text(
            AppTranslationKeys.homeBudgetLabel.tr(),
            style: AppTextStyles.budgetLabel,
          ),

          SizedBox(height: 12.h),

          // ── Budget Input ──
          _BudgetInputField(controller: budgetController),

          SizedBox(height: 16.h),

          // ── Person Count Label ──
          Text(
            AppTranslationKeys.homePersonCountLabel.tr(),
            style: AppTextStyles.budgetLabel,
          ),

          SizedBox(height: 12.h),

          // ── Person Count Input ──
          _PersonCountField(controller: personCountController),

          SizedBox(height: 16.h),

          // ── Discover Button ──
          isLoading
              ? const Center(
                  child: CircularProgressIndicator(color: AppColors.primary),
                )
              : CustomButton(
                  label: AppTranslationKeys.homeDiscoverBtn.tr(),
                  icon: Icons.travel_explore_rounded,
                  onPressed: onDiscover,
                ),
        ],
      ),
    );
  }
}

// ── Budget Input ──
class _BudgetInputField extends StatelessWidget {
  final TextEditingController controller;
  const _BudgetInputField({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Row(
        children: [
          // ── Icon ──
          Container(
            decoration: BoxDecoration(
              color: AppColors.fieldBg,
              borderRadius: BorderRadius.all(Radius.circular(10.r)),
            ),
            padding: EdgeInsets.all(12.r),
            child: Icon(
              Icons.calculate_outlined,
              color: AppColors.primary,
              size: 23.sp,
            ),
          ),

          // ── Input ──
          Expanded(
            child: TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              style: AppTextStyles.budgetAmount,
              decoration: InputDecoration(
                hintText: AppTranslationKeys.homeBudgetHint.tr(),
                hintStyle: AppTextStyles.budgetHint,
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(horizontal: 8.w),
              ),
            ),
          ),

          // ── Currency ──
          Container(
            decoration: BoxDecoration(
              color: AppColors.fieldBg,
              borderRadius: BorderRadius.all(Radius.circular(10.r)),
            ),
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
            child: Text(
              AppTranslationKeys.homeCurrency.tr(),
              style: AppTextStyles.currency,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Person Count Input ──
class _PersonCountField extends StatelessWidget {
  final TextEditingController controller;
  const _PersonCountField({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Row(
        children: [
          // ── Minus Button ──
          _CounterButton(
            icon: Icons.remove,
            onTap: () {
              final current = int.tryParse(controller.text) ?? 1;
              if (current > 1) {
                controller.text = (current - 1).toString();
              }
            },
          ),

          // ── Count ──
          Expanded(
            child: TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              style: AppTextStyles.budgetAmount,
              decoration: const InputDecoration(border: InputBorder.none),
            ),
          ),

          // ── Plus Button ──
          _CounterButton(
            icon: Icons.add,
            onTap: () {
              final current = int.tryParse(controller.text) ?? 1;
              controller.text = (current + 1).toString();
            },
          ),
        ],
      ),
    );
  }
}

class _CounterButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _CounterButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.fieldBg,
          borderRadius: BorderRadius.all(Radius.circular(10.r)),
        ),
        padding: EdgeInsets.all(12.r),
        child: Icon(icon, color: AppColors.primary, size: 23.sp),
      ),
    );
  }
}
