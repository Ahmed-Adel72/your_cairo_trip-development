// lib/features/auth/presentation/widgets/login_form_widget.dart

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_translation_keys.dart';
import '../../../../core/navigation/main_navigation_screen.dart';
import '../cubit/login_cubit.dart';
import '../cubit/login_state.dart';
import 'login_footer_widget.dart';

class LoginFormWidget extends StatefulWidget {
  const LoginFormWidget({super.key});

  @override
  State<LoginFormWidget> createState() => _LoginFormWidgetState();
}

class _LoginFormWidgetState extends State<LoginFormWidget> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginCubit, LoginState>(
      listener: (context, state) {
        if (state is LoginSuccess) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const MainNavigationScreen()),
          );
        }
        if (state is LoginFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message), backgroundColor: Colors.red),
          );
        }
      },
      builder: (context, state) {
        final isLoading = state is LoginLoading;

        return Container(
          margin: EdgeInsets.all(16.r),
          padding: EdgeInsets.all(20.r),
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.circular(24.r),
            border: Border.all(color: Colors.white.withOpacity(0.15), width: 1),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // ── Title ──
              Text(
                AppTranslationKeys.loginTitle.tr(),
                style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textDark,
                ),
              ),

              SizedBox(height: 16.h),

              // ── Email ──
              _buildTextField(
                controller: _emailController,
                hintKey: AppTranslationKeys.loginEmail,
                icon: Icons.email_outlined,
                keyboardType: TextInputType.emailAddress,
                enabled: !isLoading,
              ),

              SizedBox(height: 12.h),

              // ── Password ──
              _buildTextField(
                controller: _passwordController,
                hintKey: AppTranslationKeys.loginPassword,
                icon: Icons.lock_outline_rounded,
                obscureText: _obscurePassword,
                enabled: !isLoading,
                suffixIcon: GestureDetector(
                  onTap: () =>
                      setState(() => _obscurePassword = !_obscurePassword),
                  child: Icon(
                    _obscurePassword
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                    color: AppColors.textLight,
                    size: 20.sp,
                  ),
                ),
              ),

              SizedBox(height: 20.h),

              // ── Login Button ──
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: isLoading ? null : _onLogin,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.white,
                    padding: EdgeInsets.symmetric(vertical: 14.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    elevation: 3,
                  ),
                  child: isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : Text(
                          AppTranslationKeys.loginBtn.tr(),
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),

              SizedBox(height: 16.h),

              // ── Footer ──
              const Center(child: LoginFooterWidget()),

              SizedBox(height: 60.h),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintKey,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    bool obscureText = false,
    bool enabled = true,
    Widget? suffixIcon,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        obscureText: obscureText,
        enabled: enabled,
        // ── الاتجاه بيتغير تلقائي حسب اللغة ──
        textAlign: context.locale.languageCode == 'ar'
            ? TextAlign.right
            : TextAlign.left,
        style: TextStyle(fontSize: 14.sp, color: AppColors.textDark),
        decoration: InputDecoration(
          hintText: hintKey.tr(),
          hintStyle: TextStyle(color: AppColors.textLight, fontSize: 14.sp),
          suffixIcon:
              suffixIcon ?? Icon(icon, color: AppColors.textLight, size: 20.sp),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(
            horizontal: 16.w,
            vertical: 14.h,
          ),
        ),
      ),
    );
  }

  void _onLogin() {
    context.read<LoginCubit>().login(
      email: _emailController.text.trim(),
      password: _passwordController.text.trim(),
    );
  }
}
