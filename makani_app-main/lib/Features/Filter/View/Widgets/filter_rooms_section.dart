import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FilterRoomsSection extends StatelessWidget {
  const FilterRoomsSection({
    super.key,
    required this.value,
    required this.options,
    required this.onChanged,
  });

  final String value;
  final List<String> options;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      initialValue: value,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
        contentPadding: EdgeInsets.symmetric(
            horizontal: 14.w, vertical: 12.h),
      ),
      items: options
          .map(
            (s) => DropdownMenuItem<String>(
              value: s,
              child: Text(s),
            ),
          )
          .toList(),
      onChanged: onChanged,
    );
  }
}
