import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_translation_keys.dart';
import '../../../../core/navigation/main_navigation_screen.dart';
import '../cubit/signup_cubit.dart';
import '../cubit/signup_state.dart';
import 'sign_up_footer_widget.dart';

class SignUpFormWidget extends StatefulWidget {
  const SignUpFormWidget({super.key});

  @override
  State<SignUpFormWidget> createState() => _SignUpFormWidgetState();
}

class _SignUpFormWidgetState extends State<SignUpFormWidget> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  // Field-level errors from the API
  Map<String, String> _fieldErrors = {};

  @override
  void initState() {
    super.initState();
    // Clear field errors when the user starts editing any field
    _nameController.addListener(() => _clearFieldError('name'));
    _emailController.addListener(() => _clearFieldError('email'));
    _phoneController.addListener(() => _clearFieldError('phone'));
    _passwordController.addListener(() => _clearFieldError('password'));
    _confirmPasswordController.addListener(
      () => _clearFieldError('password_confirmation'),
    );
  }

  void _clearFieldError(String field) {
    if (_fieldErrors.containsKey(field)) {
      setState(() => _fieldErrors = Map.from(_fieldErrors)..remove(field));
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SignUpCubit, SignUpState>(
      listener: (context, state) {
        if (state is SignUpSuccess) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const MainNavigationScreen()),
          );
        }
        if (state is SignUpFailure) {
          // Update inline field errors
          setState(() => _fieldErrors = state.fieldErrors);

          // Show a snackbar only for the top-level message
          // (when there are no field errors, or as a summary)
          if (state.fieldErrors.isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        }
        // Clear field errors on new loading attempt
        if (state is SignUpLoading) {
          setState(() => _fieldErrors = {});
        }
      },
      builder: (context, state) {
        final isLoading = state is SignUpLoading;

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
                AppTranslationKeys.signUpTitle.tr(),
                style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textDark,
                ),
              ),

              SizedBox(height: 16.h),

              // ── Name ──
              _buildTextField(
                controller: _nameController,
                hintKey: AppTranslationKeys.signUpName,
                icon: Icons.person_outline_rounded,
                enabled: !isLoading,
                errorText: _fieldErrors['name'],
              ),

              SizedBox(height: 12.h),

              // ── Email ──
              _buildTextField(
                controller: _emailController,
                hintKey: AppTranslationKeys.signUpEmail,
                icon: Icons.email_outlined,
                keyboardType: TextInputType.emailAddress,
                enabled: !isLoading,
                errorText: _fieldErrors['email'],
              ),

              SizedBox(height: 12.h),

              // ── Phone ──
              _buildTextField(
                controller: _phoneController,
                hintKey: AppTranslationKeys.signUpPhone,
                icon: Icons.phone_outlined,
                keyboardType: TextInputType.phone,
                enabled: !isLoading,
                errorText: _fieldErrors['phone'],
              ),

              SizedBox(height: 12.h),

              // ── Password ──
              _buildTextField(
                controller: _passwordController,
                hintKey: AppTranslationKeys.signUpPassword,
                icon: Icons.lock_outline_rounded,
                obscureText: _obscurePassword,
                enabled: !isLoading,
                errorText: _fieldErrors['password'],
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

              SizedBox(height: 12.h),

              // ── Confirm Password ──
              _buildTextField(
                controller: _confirmPasswordController,
                hintKey: AppTranslationKeys.signUpConfirmPassword,
                icon: Icons.lock_outline_rounded,
                obscureText: _obscureConfirmPassword,
                enabled: !isLoading,
                errorText: _fieldErrors['password_confirmation'],
                suffixIcon: GestureDetector(
                  onTap: () => setState(
                    () => _obscureConfirmPassword = !_obscureConfirmPassword,
                  ),
                  child: Icon(
                    _obscureConfirmPassword
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                    color: AppColors.textLight,
                    size: 20.sp,
                  ),
                ),
              ),

              SizedBox(height: 20.h),

              // ── SignUp Button ──
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: isLoading ? null : _onSignUp,
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
                          AppTranslationKeys.signUpBtn.tr(),
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),

              SizedBox(height: 16.h),

              // ── Footer ──
              const Center(child: SignUpFooterWidget()),

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
    String? errorText,
  }) {
    final hasError = errorText != null && errorText.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.9),
            borderRadius: BorderRadius.circular(12.r),
            border: hasError
                ? Border.all(color: Colors.red.shade400, width: 1.2)
                : null,
          ),
          child: TextField(
            controller: controller,
            keyboardType: keyboardType,
            obscureText: obscureText,
            enabled: enabled,
            textAlign: context.locale.languageCode == 'ar'
                ? TextAlign.right
                : TextAlign.left,
            style: TextStyle(fontSize: 14.sp, color: AppColors.textDark),
            decoration: InputDecoration(
              hintText: hintKey.tr(),
              hintStyle: TextStyle(color: AppColors.textLight, fontSize: 14.sp),
              suffixIcon:
                  suffixIcon ??
                  Icon(icon, color: AppColors.textLight, size: 20.sp),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(
                horizontal: 16.w,
                vertical: 14.h,
              ),
            ),
          ),
        ),
        if (hasError) ...[
          SizedBox(height: 4.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            child: Text(
              errorText,
              style: TextStyle(color: Colors.red.shade600, fontSize: 12.sp),
              textAlign: context.locale.languageCode == 'ar'
                  ? TextAlign.right
                  : TextAlign.left,
            ),
          ),
        ],
      ],
    );
  }

  void _onSignUp() {
    context.read<SignUpCubit>().signUp(
      name: _nameController.text.trim(),
      email: _emailController.text.trim(),
      phone: _phoneController.text.trim(),
      password: _passwordController.text.trim(),
      passwordConfirmation: _confirmPasswordController.text.trim(),
      langCode: context.locale.languageCode,
    );
  }
}
