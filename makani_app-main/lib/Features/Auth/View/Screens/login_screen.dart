import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:makani_app/Core/Const/app_colors.dart';
import 'package:makani_app/Core/Const/localization_extension.dart';
import 'package:makani_app/Core/Widgets/app_text_field.dart';
import 'package:makani_app/Core/Widgets/primary_button.dart';
import 'package:makani_app/Features/Auth/Cubit/auth_cubit.dart';
import 'package:makani_app/Routing/routes.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../Core/Const/assets.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
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
                  SizedBox(height: 48.h),
                  Center(
                    child: Image.asset(Assets.appIcon,height: 90.h,width: 90.w,)
                  ),
                  Text(
                    context.tr.welcomeToMakani,
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  Text(
                    context.tr.findYourPerfectHome,
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w400,
                      color: AppColors.gray500,
                    ),
                  ),
                  SizedBox(height: 50.h),
                  AppTextField(
                    label: context.tr.email,
                    hint: context.tr.email,
                    keyboardType: TextInputType.emailAddress,
                    onChanged: context.read<AuthCubit>().setEmail,
                  ),
                  SizedBox(height: 16.h),
                  AppTextField(
                    label: context.tr.password,
                    hint: context.tr.password,
                    obscureText: true,
                    onChanged: context.read<AuthCubit>().setPassword,
                  ),
                  SizedBox(height: 8.h),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () =>
                          context.pushNamed(Routes.forgotPassword.name),
                      child: Text(context.tr.forgotPassword,  style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                        color: AppColors.primary700,
                      ),),
                    ),
                  ),
                  SizedBox(height: 24.h),
                  PrimaryButton(
                    label: context.tr.signIn,
                    loading: state is AuthLoading,
                    onPressed: () => context.read<AuthCubit>().login(),

                  ),
                  SizedBox(height: 24.h),
                  Row(
                    children: [
                      Expanded(
                        child: Divider(
                          color: AppColors.divider,
                          thickness: 1,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        child: Text(
                          context.tr.orLoginWith,
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Divider(
                          color: AppColors.divider,
                          thickness: 1,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16.h),
                  OutlinedButton.icon(
                    onPressed: state is AuthLoading
                        ? null
                        : () => context.read<AuthCubit>().signInWithGoogle(),
                    icon: SvgPicture.asset(Assets.googleIcon),
                    label: Text(context.tr.loginWithGoogle),
                    style: OutlinedButton.styleFrom(
                      minimumSize: Size(double.infinity, 52.h),
                      foregroundColor: AppColors.textPrimary,
                      side: BorderSide(color: AppColors.divider),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                  ),
                  SizedBox(height: 32.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        context.tr.newToMakaniSignUp,
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      SizedBox(width: 2.w,),
                      InkWell(
                          onTap: (){
                            context.pushNamed(Routes.signUp.name);
                          },
                          child: Text(context.tr.signUp,style: TextStyle(
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
