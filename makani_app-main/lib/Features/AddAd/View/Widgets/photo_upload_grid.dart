
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:makani_app/Core/Const/app_colors.dart';
import 'package:makani_app/Features/AddAd/Model/add_ad_constants.dart';

class PhotoUploadGrid extends StatelessWidget {
  const PhotoUploadGrid({
    super.key,
    required this.slots,
    required this.onAdd,
    required this.onRemove,
    required this.addLabel,
  });

  final List<String> slots;
  final void Function(int index) onAdd;
  final void Function(int index) onRemove;
  final String addLabel;

  bool _isRemoteUrl(String path) {
    final uri = Uri.tryParse(path);
    if (uri == null) return false;
    return uri.scheme == 'http' || uri.scheme == 'https';
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: AddAdConstants.maxPhotos,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12.h,
        crossAxisSpacing: 12.w,
        childAspectRatio: 1.05,
      ),
      itemBuilder: (context, i) {
        final path = i < slots.length ? slots[i] : '';
        final has = path.isNotEmpty;
        return Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: has ? null : () => onAdd(i),
            borderRadius: BorderRadius.circular(14.r),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              decoration: BoxDecoration(
                color: has ? Colors.black12 : Colors.white,
                borderRadius: BorderRadius.circular(14.r),
                border: Border.all(
                  color: has ? AppColors.primary.withValues(alpha: 0.35) : AppColors.gray200,
                  width: has ? 2 : 1.5,
                ),
              ),
              child: has
                  ? Stack(
                      fit: StackFit.expand,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12.r),
                          child: _isRemoteUrl(path)
                              ? Image.network(path, fit: BoxFit.cover)
                              : Image.file(File(path), fit: BoxFit.cover),
                        ),
                        Positioned(
                          top: 6.h,
                          right: 6.w,
                          child: Material(
                            color: Colors.black54,
                            shape: const CircleBorder(),
                            child: InkWell(
                              customBorder: const CircleBorder(),
                              onTap: () => onRemove(i),
                              child: Padding(
                                padding: EdgeInsets.all(4.r),
                                child: Icon(Icons.close, color: Colors.white, size: 18.r),
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.add_circle_outline, size: 36.r, color: AppColors.gray400),
                        SizedBox(height: 8.h),
                        Text(
                          addLabel,
                          style: TextStyle(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        );
      },
    );
  }
}
