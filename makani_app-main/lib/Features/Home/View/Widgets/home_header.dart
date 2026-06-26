import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:makani_app/Core/Const/app_colors.dart';
import 'package:makani_app/Core/Const/localization_extension.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({
    super.key,
    required this.userName,
    this.photoBase64,
    this.locationText = '23 El-Gomhoria Street, Egypt',
  });

  final String userName;
  final String? photoBase64;
  final String locationText;

  Uint8List? _decodeAvatarBytes() {
    if (photoBase64 == null || photoBase64!.isEmpty) return null;
    try {
      return base64Decode(photoBase64!);
    } catch (_) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final avatarBytes = _decodeAvatarBytes();

    return SafeArea(
      bottom: false,
      child: Padding(
        padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 26.r,
              backgroundColor: AppColors.primary.withValues(alpha: 0.2),
              backgroundImage:
              avatarBytes != null ? MemoryImage(avatarBytes) : null,
              child: avatarBytes == null
                  ? Text(
                userName.isNotEmpty
                    ? userName[0].toUpperCase()
                    : 'U',
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
              )
                  : null,
            ),

            SizedBox(width: 12.w),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    context.tr.helloUser(userName),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),

                  SizedBox(height: 4.h),

                  Row(
                    children: [
                      Icon(
                        Icons.location_pin,
                        size: 18.r,
                        color: AppColors.primary700,
                      ),

                      SizedBox(width: 4.w),

                      Expanded(
                        child: Text(
                          locationText,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 13.sp,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}