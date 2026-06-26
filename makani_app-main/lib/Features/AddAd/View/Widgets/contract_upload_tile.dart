import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:makani_app/Core/Const/app_colors.dart';

class ContractUploadTile extends StatelessWidget {
  const ContractUploadTile({
    super.key,
    required this.imagePath,
    required this.onPick,
    required this.onRemove,
    required this.title,
    required this.hint,
    required this.tapToUploadLabel,
    this.compact = false,
    this.placeholderIcon = Icons.description_outlined,
  });

  final String? imagePath;
  final VoidCallback onPick;
  final VoidCallback onRemove;
  final String title;
  final String hint;
  final String tapToUploadLabel;
  final bool compact;
  final IconData placeholderIcon;

  bool get _hasImage => imagePath != null && imagePath!.isNotEmpty;

  bool get _isRemote {
    final uri = Uri.tryParse(imagePath ?? '');
    return uri != null &&
        (uri.scheme == 'http' || uri.scheme == 'https');
  }

  double get _tileHeight => compact ? 120.h : 140.h;

  @override
  Widget build(BuildContext context) {
    if (compact) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: 8.h),
          _buildTile(context),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        SizedBox(height: 6.h),
        Text(
          hint,
          style: TextStyle(
            fontSize: 13.sp,
            color: AppColors.textSecondary,
            height: 1.35,
          ),
        ),
        SizedBox(height: 12.h),
        _buildTile(context),
      ],
    );
  }

  Widget _buildTile(BuildContext context) {
    return GestureDetector(
      onTap: onPick,
      child: Container(
        height: _tileHeight,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: _hasImage ? AppColors.primary : AppColors.divider,
            width: _hasImage ? 1.5 : 1,
          ),
        ),
        clipBehavior: Clip.antiAlias,
        child: _hasImage ? _buildPreview(context) : _buildPlaceholder(context),
      ),
    );
  }

  Widget _buildPlaceholder(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(placeholderIcon, size: compact ? 28.r : 36.r, color: AppColors.textSecondary),
          SizedBox(height: 8.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.w),
            child: Text(
              tapToUploadLabel,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: compact ? 12.sp : 14.sp,
                color: AppColors.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPreview(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        if (_isRemote)
          Image.network(
            imagePath!,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => _buildPlaceholder(context),
          )
        else
          Image.file(
            File(imagePath!),
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => _buildPlaceholder(context),
          ),
        Positioned(
          top: 8.h,
          right: 8.w,
          child: Material(
            color: Colors.black54,
            shape: const CircleBorder(),
            child: IconButton(
              icon: Icon(Icons.close, size: 20.r, color: Colors.white),
              onPressed: onRemove,
            ),
          ),
        ),
      ],
    );
  }
}
