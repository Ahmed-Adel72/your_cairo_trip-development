// lib/features/settings/presentation/screens/support_screen.dart

import 'dart:ui' as ui;

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_translation_keys.dart';
import '../../../../core/di/service_locator.dart';
import '../cubit/support_cubit.dart';
import '../cubit/support_state.dart';

class SupportScreen extends StatelessWidget {
  const SupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<SupportCubit>(),
      child: const _SupportView(),
    );
  }
}

class _SupportView extends StatefulWidget {
  const _SupportView();

  @override
  State<_SupportView> createState() => _SupportViewState();
}

class _SupportViewState extends State<_SupportView> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _problemController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _problemController.dispose();
    super.dispose();
  }

  void _onSubmit() {
    if (_formKey.currentState!.validate()) {
      context.read<SupportCubit>().submitSupport(
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        phone: _phoneController.text.trim(),
        problem: _problemController.text.trim(),
      );
    }
  }

  void _showSuccessDialog() {
    final langCode = context.locale.languageCode;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => Directionality(
        textDirection: langCode == 'ar'
            ? ui.TextDirection.rtl
            : ui.TextDirection.ltr,
        child: AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.r),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // ── Success Icon ──
              Container(
                width: 70.w,
                height: 70.h,
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.check_circle_rounded,
                  color: AppColors.primary,
                  size: 40.sp,
                ),
              ),

              SizedBox(height: 16.h),

              Text(
                AppTranslationKeys.supportSuccessTitle.tr(),
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark,
                ),
                textAlign: TextAlign.center,
              ),

              SizedBox(height: 8.h),

              Text(
                AppTranslationKeys.supportSuccessSubtitle.tr(),
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 13.sp, color: AppColors.textLight),
              ),

              SizedBox(height: 20.h),

              // ── OK Button ──
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context); // close dialog
                    Navigator.pop(context); // back to settings
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                  ),
                  child: Text(
                    AppTranslationKeys.supportSuccessBtn.tr(),
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final langCode = context.locale.languageCode;

    return BlocConsumer<SupportCubit, SupportState>(
      listener: (context, state) {
        if (state is SupportSuccess) {
          _showSuccessDialog();
        }
        if (state is SupportError) {
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
        final isLoading = state is SupportLoading;

        return Directionality(
          textDirection: langCode == 'ar'
              ? ui.TextDirection.rtl
              : ui.TextDirection.ltr,
          child: Scaffold(
            backgroundColor: AppColors.background,
            resizeToAvoidBottomInset: true,

            // ── AppBar ──
            appBar: AppBar(
              backgroundColor: AppColors.primary,
              elevation: 0,
              centerTitle: true,
              title: Text(
                AppTranslationKeys.supportTitle.tr(),
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
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(20.r),
                ),
              ),
            ),

            body: SingleChildScrollView(
              padding: EdgeInsets.all(16.r),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 8.h),

                    // ── Header Card ──
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(16.r),
                      decoration: BoxDecoration(
                        color: AppColors.primaryLight,
                        borderRadius: BorderRadius.circular(16.r),
                        border: Border.all(
                          color: AppColors.primary.withOpacity(0.3),
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 50.w,
                            height: 50.h,
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            child: Icon(
                              Icons.support_agent_rounded,
                              color: AppColors.white,
                              size: 28.sp,
                            ),
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  AppTranslationKeys.supportHeaderTitle.tr(),
                                  style: TextStyle(
                                    fontSize: 15.sp,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.primaryDark,
                                  ),
                                ),
                                SizedBox(height: 4.h),
                                Text(
                                  AppTranslationKeys.supportHeaderSubtitle.tr(),
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    color: AppColors.primaryDark,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 24.h),

                    // ── Name Field ──
                    _SectionLabel(
                      icon: Icons.person_rounded,
                      label: AppTranslationKeys.supportName.tr(),
                    ),
                    SizedBox(height: 8.h),
                    _buildFormField(
                      controller: _nameController,
                      hint: AppTranslationKeys.supportNameHint.tr(),
                      icon: Icons.person_outline_rounded,
                      validator: (val) {
                        if (val == null || val.isEmpty) {
                          return AppTranslationKeys.supportNameRequired.tr();
                        }
                        if (val.trim().length < 3) {
                          return AppTranslationKeys.supportNameInvalid.tr();
                        }
                        return null;
                      },
                    ),

                    SizedBox(height: 16.h),

                    // ── Phone Field ──
                    _SectionLabel(
                      icon: Icons.phone_rounded,
                      label: AppTranslationKeys.supportPhone.tr(),
                    ),
                    SizedBox(height: 8.h),
                    _buildFormField(
                      controller: _phoneController,
                      hint: AppTranslationKeys.supportPhoneHint.tr(),
                      icon: Icons.phone_outlined,
                      keyboardType: TextInputType.phone,
                      validator: (val) {
                        if (val == null || val.isEmpty) {
                          return AppTranslationKeys.supportPhoneRequired.tr();
                        }
                        if (val.trim().length < 10) {
                          return AppTranslationKeys.supportPhoneInvalid.tr();
                        }
                        return null;
                      },
                    ),

                    SizedBox(height: 16.h),

                    // ── Email Field ──
                    _SectionLabel(
                      icon: Icons.email_rounded,
                      label: AppTranslationKeys.supportEmail.tr(),
                    ),
                    SizedBox(height: 8.h),
                    _buildFormField(
                      controller: _emailController,
                      hint: AppTranslationKeys.supportEmailHint.tr(),
                      icon: Icons.email_outlined,
                      keyboardType: TextInputType.emailAddress,
                      validator: (val) {
                        if (val == null || val.isEmpty) {
                          return AppTranslationKeys.supportEmailRequired.tr();
                        }
                        if (!val.contains('@') || !val.contains('.')) {
                          return AppTranslationKeys.supportEmailInvalid.tr();
                        }
                        return null;
                      },
                    ),

                    SizedBox(height: 16.h),

                    // ── Problem Field ──
                    _SectionLabel(
                      icon: Icons.report_problem_rounded,
                      label: AppTranslationKeys.supportProblem.tr(),
                    ),
                    SizedBox(height: 8.h),
                    _buildFormField(
                      controller: _problemController,
                      hint: AppTranslationKeys.supportProblemHint.tr(),
                      icon: Icons.description_outlined,
                      maxLines: 5,
                      validator: (val) {
                        if (val == null || val.isEmpty) {
                          return AppTranslationKeys.supportProblemRequired.tr();
                        }
                        if (val.trim().length < 10) {
                          return AppTranslationKeys.supportProblemInvalid.tr();
                        }
                        return null;
                      },
                    ),

                    SizedBox(height: 30.h),

                    // ── Submit Button ──
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: isLoading ? null : _onSubmit,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: AppColors.white,
                          disabledBackgroundColor: AppColors.primary
                              .withOpacity(0.6),
                          padding: EdgeInsets.symmetric(vertical: 16.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14.r),
                          ),
                          elevation: 3,
                        ),
                        icon: isLoading
                            ? SizedBox(
                                width: 20.w,
                                height: 20.h,
                                child: CircularProgressIndicator(
                                  color: AppColors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : Icon(Icons.send_rounded, size: 20.sp),
                        label: Text(
                          isLoading
                              ? AppTranslationKeys.supportSending.tr()
                              : AppTranslationKeys.supportSend.tr(),
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 16.h),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildFormField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      validator: validator,
      style: TextStyle(fontSize: 14.sp, color: AppColors.textDark),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: AppColors.textLight, fontSize: 14.sp),
        filled: true,
        fillColor: AppColors.white,
        prefixIcon: maxLines == 1
            ? Icon(icon, color: AppColors.primary, size: 20.sp)
            : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(color: AppColors.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: const BorderSide(color: Colors.red),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: const BorderSide(color: Colors.red, width: 2),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      ),
    );
  }
}

// ─── Section Label ────────────────────────────────────────────────────────────

class _SectionLabel extends StatelessWidget {
  final IconData icon;
  final String label;

  const _SectionLabel({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: AppColors.primary, size: 18.sp),
        SizedBox(width: 8.w),
        Text(
          label,
          style: TextStyle(
            fontSize: 15.sp,
            fontWeight: FontWeight.bold,
            color: AppColors.textDark,
          ),
        ),
      ],
    );
  }
}
