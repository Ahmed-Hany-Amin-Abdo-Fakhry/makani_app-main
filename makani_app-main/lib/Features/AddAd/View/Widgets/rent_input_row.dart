import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:makani_app/Core/Const/app_colors.dart';

class RentInputRow extends StatefulWidget {
  const RentInputRow({
    super.key,
    required this.label,
    required this.hint,
    required this.suffix,
    required this.prefix,
    required this.value,
    required this.onChanged,
  });

  final String label;
  final String hint;
  final String suffix;
  final String prefix;
  final String value;
  final ValueChanged<String> onChanged;

  @override
  State<RentInputRow> createState() => _RentInputRowState();
}

class _RentInputRowState extends State<RentInputRow> {
  late final TextEditingController _controller = TextEditingController(
    text: widget.value,
  );

  @override
  void initState() {
    super.initState();
    _controller.addListener(() => widget.onChanged(_controller.text));
  }

  @override
  void didUpdateWidget(covariant RentInputRow oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value && widget.value != _controller.text) {
      _controller.text = widget.value;
      _controller.selection = TextSelection.collapsed(
        offset: _controller.text.length,
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          widget.label,
          style: TextStyle(
            fontSize: 13.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        SizedBox(height: 8.h),
        TextField(
          controller: _controller,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'[\d.,]')),
          ],
          style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600),
          decoration: InputDecoration(
            hintText: widget.hint,
            filled: true,
            fillColor: Colors.white,
            prefixText: '${widget.prefix} ',
            prefixStyle: TextStyle(
              fontSize: 15.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
            suffixText: ' ${widget.suffix}',
            suffixStyle: TextStyle(
              fontSize: 13.sp,
              color: AppColors.textSecondary,
            ),
            contentPadding:
                EdgeInsets.symmetric(horizontal: 14.w, vertical: 16.h),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: const BorderSide(color: AppColors.gray200),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: const BorderSide(color: AppColors.gray200),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide:
                  const BorderSide(color: AppColors.primary700, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }
}
