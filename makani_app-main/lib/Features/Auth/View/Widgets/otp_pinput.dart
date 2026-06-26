import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:makani_app/Core/Const/app_colors.dart';
import 'package:makani_app/Core/Helper/convert_number.dart';
import 'package:makani_app/Core/Widgets/shake_widget.dart';
import 'package:makani_app/Features/Auth/Cubit/auth_cubit.dart';
import 'package:pinput/pinput.dart';

class OtpPinput extends StatelessWidget {
  const OtpPinput({
    super.key,
    required this.controller,
    required this.onCompletedOtp,
    this.shakeController,
  });

  final TextEditingController controller;
  final void Function(String pin) onCompletedOtp;
  final AnimationController? shakeController;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthError) {
          controller.clear();
          shakeController?.forward(from: 0);
        }
      },
      builder: (context, state) {
        const filledBorderColor = AppColors.primary700;
        const emptyBorderColor = AppColors.gray500;

        final baseTheme = PinTheme(
          width: 46.w,
          height: 48.w,
          textStyle: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            color: filledBorderColor,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              color: emptyBorderColor,
              width: 1,
            ),
          ),
        );

        final focusedTheme = baseTheme.copyWith(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              color: filledBorderColor,
              width: 1.5,
            ),
          ),
        );

        final pinput = Pinput(
          controller: controller,
          length: 6,
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          mainAxisAlignment: MainAxisAlignment.center,
          separatorBuilder: (index) => SizedBox(width: 10.w),
          defaultPinTheme: baseTheme,
          focusedPinTheme: focusedTheme,
          submittedPinTheme: focusedTheme,
          showCursor: true,
          pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
          onChanged: (value) {
            final fixed = convertToEnglishDigits(value);
            controller.text = fixed;
            controller.selection = TextSelection.fromPosition(
              TextPosition(offset: fixed.length),
            );
            if (fixed.length == 6) {
              FocusScope.of(context).unfocus();
              onCompletedOtp(fixed);
            }
          },
          onCompleted: (pin) {
            final fixedOtp = convertToEnglishDigits(pin);
            controller.text = fixedOtp;
            FocusScope.of(context).unfocus();
            onCompletedOtp(fixedOtp);
          },
        );

        final child = Directionality(
          textDirection: TextDirection.ltr,
          child: pinput,
        );

        if (shakeController != null) {
          return ShakeWidget(
            controller: shakeController!,
            child: child,
          );
        }
        return child;
      },
    );
  }
}
