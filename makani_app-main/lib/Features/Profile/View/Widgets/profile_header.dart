import 'dart:io';
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:makani_app/Core/Const/app_colors.dart';
import 'package:makani_app/Core/Const/localization_extension.dart';
import 'package:makani_app/Features/Auth/Cubit/auth_cubit.dart';

class ProfileHeader extends StatefulWidget {
  const ProfileHeader({
    super.key,
    required this.userName,
    this.photoBase64,
  });

  final String userName;
  final String? photoBase64;

  @override
  State<ProfileHeader> createState() => _ProfileHeaderState();
}

class _ProfileHeaderState extends State<ProfileHeader> {
  File? _localPreviewFile;
  bool _uploading = false;

  Uint8List? _decodeBase64(String? raw) {
    if (raw == null || raw.isEmpty) return null;
    try {
      return base64Decode(raw);
    } catch (_) {
      return null;
    }
  }

  Future<void> _pickAndUpload(ImageSource source) async {
    final picker = ImagePicker();
    final xfile = await picker.pickImage(source: source, imageQuality: 85);
    if (xfile == null) return;

    if (!mounted) return;
    final confirm = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Confirm upload'),
          content: const Text('Do you want to upload this profile photo?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: const Text('Upload'),
            ),
          ],
        );
      },
    );

    if (confirm != true) return;

    final file = File(xfile.path);
    setState(() {
      _localPreviewFile = file;
      _uploading = true;
    });

    try {
      final success = await context.read<AuthCubit>().uploadProfilePhoto(file);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            success
                ? 'Profile image updated'
                : 'Failed to upload profile image',
          ),
        ),
      );

      if (!mounted) return;
      setState(() {
        if (success) {
          _localPreviewFile = null;
        }
        _uploading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _uploading = false);
    }
  }

  void _showImageSourceSheet() {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.white,
      showDragHandle: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: const Icon(Icons.camera_alt),
                  title: Text(ctx.tr.camera),
                  onTap: () {
                    Navigator.of(ctx).pop();
                    _pickAndUpload(ImageSource.camera);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.photo_library_outlined),
                  title: Text(ctx.tr.gallery),
                  onTap: () {
                    Navigator.of(ctx).pop();
                    _pickAndUpload(ImageSource.gallery);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final firstLetter =
        widget.userName.isNotEmpty ? widget.userName[0].toUpperCase() : 'J';

    final showLoader = _uploading;
    final base64Bytes = _localPreviewFile == null
        ? _decodeBase64(widget.photoBase64)
        : null;

    return Column(
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(48.r),
                onTap: _showImageSourceSheet,
                child: CircleAvatar(
                  radius: 48.r,
                  backgroundColor: AppColors.primary.withValues(alpha: 0.2),
                  backgroundImage: _localPreviewFile != null
                      ? FileImage(_localPreviewFile!)
                      : (base64Bytes != null
                          ? MemoryImage(base64Bytes) as ImageProvider
                          : null),
                  child: showLoader
                      ? const Center(
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : ((_localPreviewFile == null &&
                                base64Bytes == null)
                          ? Text(
                              firstLetter,
                              style: TextStyle(
                                fontSize: 36.sp,
                                fontWeight: FontWeight.w600,
                                color: AppColors.primary,
                              ),
                            )
                          : null),
                ),
              ),
            ),
            Positioned(
              right: 0,
              bottom: 0,
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: _showImageSourceSheet,
                  borderRadius: BorderRadius.circular(16.r),
                  child: Container(
                    width: 32.w,
                    height: 32.h,
                    decoration: BoxDecoration(
                      color: AppColors.primary700,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.camera_alt,
                      size: 16.r,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 12.h),
        Text(
          widget.userName,
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}
