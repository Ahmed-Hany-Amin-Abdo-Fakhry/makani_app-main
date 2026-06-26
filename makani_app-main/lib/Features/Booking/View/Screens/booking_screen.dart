import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:makani_app/Core/Const/app_colors.dart';
import 'package:makani_app/Core/Const/localization_extension.dart';
import 'package:makani_app/Core/Widgets/primary_button.dart';
import 'package:go_router/go_router.dart';

class BookingScreen extends StatelessWidget {
  const BookingScreen({super.key, this.extra});

  final Map<String, dynamic>? extra;

  @override
  Widget build(BuildContext context) {
    final title = extra?['title'] as String? ?? 'Property';
    final price = extra?['price'] as String? ?? '0';

    return Scaffold(
      appBar: AppBar(title: Text(context.tr.booking)),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Container(
                  width: 80.w,
                  height: 80.h,
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Icon(Icons.home_work_outlined, color: AppColors.textSecondary),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600)),
                      Text(context.tr.perMonth(price), style: TextStyle(fontSize: 14.sp, color: AppColors.primary)),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 24.h),
            Text(context.tr.checkIn, style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600)),
            SizedBox(height: 8.h),
            TextField(decoration: InputDecoration(hintText: 'MM/DD/YYYY', border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r)))),
            SizedBox(height: 16.h),
            Text(context.tr.checkOut, style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600)),
            SizedBox(height: 8.h),
            TextField(decoration: InputDecoration(hintText: 'MM/DD/YYYY', border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r)))),
            SizedBox(height: 16.h),
            Text(context.tr.guests, style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600)),
            SizedBox(height: 8.h),
            Row(
              children: [
                IconButton(onPressed: () {}, icon: const Icon(Icons.remove_circle_outline)),
                Text(' 1 ', style: TextStyle(fontSize: 18.sp)),
                IconButton(onPressed: () {}, icon: const Icon(Icons.add_circle_outline)),
              ],
            ),
            SizedBox(height: 24.h),
            Text(context.tr.total, style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600)),
            Text('$price EGP', style: TextStyle(fontSize: 20.sp, color: AppColors.primary)),
            SizedBox(height: 32.h),
            PrimaryButton(
              label: context.tr.confirmBooking,
              onPressed: () => context.pop(),
            ),
          ],
        ),
      ),
    );
  }
}
