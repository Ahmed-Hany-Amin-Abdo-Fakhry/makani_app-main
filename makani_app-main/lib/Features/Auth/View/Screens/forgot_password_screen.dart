import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:makani_app/Core/Const/localization_extension.dart';
import 'package:makani_app/Core/Widgets/app_text_field.dart';
import 'package:makani_app/Core/Widgets/primary_button.dart';
import 'package:makani_app/Features/Auth/Cubit/auth_cubit.dart';
import 'package:makani_app/Features/Auth/Helper/auth_validation.dart';
import 'package:makani_app/Routing/routes.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../Core/Const/app_colors.dart';
import '../../../../Core/Widgets/password_updated_success_dialog.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _emailController = TextEditingController();

  void _showPasswordUpdatedSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24.r),
        ),
        child: PasswordUpdatedSuccessDialog(
          onContinue: () {
            Navigator.of(dialogContext).pop();
            context.goNamed(Routes.login.name);
          },
        ),
      ),
    );
  }


  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        title: Text(
          context.tr.forgotPassword
        ),
        backgroundColor: AppColors.backgroundColor,
      ),
      body: SafeArea(
        child: BlocConsumer<AuthCubit, AuthState>(
          listener: (context, state) {
            if (state is AuthPasswordResetEmailSent) {
              _showPasswordUpdatedSuccessDialog(context);
            } else if (state is AuthError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            }
          },
          builder: (context, state) {
            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: 24.h),
                  AppTextField(
                    label: context.tr.email,
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  SizedBox(height: 32.h),
                  PrimaryButton(
                    label: context.tr.resetPassword,
                    loading: state is AuthLoading,
                    onPressed: () {
                      final email = _emailController.text.trim();
                      if (email.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Email is required.'),
                          ),
                        );
                        return;
                      }
                      if (!AuthValidation.isValidEmail(email)) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Please enter a valid email.'),
                          ),
                        );
                        return;
                      }
                      context.read<AuthCubit>().requestResetPassword(email);
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
