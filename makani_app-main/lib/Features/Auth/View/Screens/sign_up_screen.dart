import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:makani_app/Core/Const/localization_extension.dart';
import 'package:makani_app/Core/Widgets/app_text_field.dart';
import 'package:makani_app/Core/Widgets/primary_button.dart';
import 'package:makani_app/Features/Auth/Helper/auth_validation.dart';
import 'package:makani_app/Features/Auth/Cubit/auth_cubit.dart';
import 'package:makani_app/Routing/routes.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../Core/Const/app_colors.dart';
import '../../../../Core/Const/assets.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        title: Text(context.tr.signUp),
        backgroundColor: AppColors.backgroundColor,
      ),
      body: SafeArea(
        child: BlocConsumer<AuthCubit, AuthState>(
          listener: (context, state) {
            if (state is AuthAuthenticated) {
              context.goNamed(Routes.home.name);
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
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 24.h),
                  AppTextField(
                    hint: context.tr.name,
                    label: context.tr.name,
                    controller: _nameController,
                  ),
                  SizedBox(height: 16.h),
                  AppTextField(
                    hint: context.tr.email,
                    label: context.tr.email,
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  SizedBox(height: 16.h),
                  AppTextField(
                    keyboardType: TextInputType.number,
                    hint: context.tr.phoneNumber,
                    label: context.tr.phoneNumber,
                    controller: _phoneController,
                  ),
                  SizedBox(height: 16.h),
                  AppTextField(
                    suffixIcon: Icon(Icons.remove_red_eye),
                    hint: context.tr.password,
                    label: context.tr.password,
                    controller: _passwordController,
                    obscureText: true,
                  ),
                  SizedBox(height: 16.h),
                  AppTextField(
                    hint: context.tr.confirmPassword,
                    label: context.tr.confirmPassword,
                    controller: _confirmController,
                    obscureText: true,
                  ),
                  SizedBox(height: 32.h),
                  PrimaryButton(
                    label: context.tr.signUp,
                    loading: state is AuthLoading,
                    onPressed: () {
                      final name = _nameController.text.trim();
                      final email = _emailController.text.trim();
                      final phone = _phoneController.text.trim();
                      final password = _passwordController.text;
                      final confirmPassword = _confirmController.text;

                      String? message;
                      if (name.isEmpty ||
                          email.isEmpty ||
                          phone.isEmpty ||
                          password.isEmpty ||
                          confirmPassword.isEmpty) {
                        message = 'All fields are required.';
                      } else if (!AuthValidation.isValidEmail(email)) {
                        message = 'Please enter a valid email.';
                      } else if (!AuthValidation.isValidPhone(phone)) {
                        message = 'Please enter a valid phone number.';
                      } else if (!AuthValidation.isStrongPassword(password)) {
                        message = 'Password must be at least 6 characters.';
                      } else if (password != confirmPassword) {
                        message = 'Passwords do not match.';
                      }

                      if (message != null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(message)),
                        );
                        return;
                      }

                      context.read<AuthCubit>().signUp(
                            name: name,
                            email: email,
                            phone: phone,
                            password: password,
                          );
                    },
                  ),
                  SizedBox(height: 24.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        context.tr.alreadyHaveAccountLogin,
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      SizedBox(width: 2.w,),
                      InkWell(
                          onTap: (){
                            context.pop();
                          },
                          child: Text(context.tr.signIn,style: TextStyle(
                            fontSize: 16.sp,
                            color: AppColors.primary700,
                          ),)),
                    ],
                  ),
                  SizedBox(
                    height: 70.h,
                  ),
                  InkWell(
                    onTap: (){
                      context.pushNamed(Routes.home.name);
                    },
                    child: Text(context.tr.skipForNow,style: TextStyle(
                      color: AppColors.gray500,
                      fontSize: 16.sp,
                    ),),
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
