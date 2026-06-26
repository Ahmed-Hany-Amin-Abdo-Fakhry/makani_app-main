import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:makani_app/Core/Const/app_colors.dart';
import 'package:makani_app/Core/Const/localization_extension.dart';

import '../../../../Core/Const/assets.dart';

class PropertyOverviewTab extends StatefulWidget {
  const PropertyOverviewTab({
    super.key,
    required this.description,
    required this.amenityItems,
    this.onReadMore,
    this.onGetDirections,
    this.onMapTap,
  });

  final String description;
  final List<AmenityItem> amenityItems;
  final VoidCallback? onReadMore;
  final VoidCallback? onGetDirections;
  final VoidCallback? onMapTap;

  @override
  State<PropertyOverviewTab> createState() => _PropertyOverviewTabState();
}

class _PropertyOverviewTabState extends State<PropertyOverviewTab> {
  bool _descriptionExpanded = false;

  bool _needsReadMore(double maxWidth, TextStyle style) {
    final painter = TextPainter(
      text: TextSpan(text: widget.description, style: style),
      maxLines: 3,
      textDirection: Directionality.of(context),
    )..layout(maxWidth: maxWidth);
    return painter.didExceedMaxLines;
  }

  void _openDirections() {
    (widget.onMapTap ?? widget.onGetDirections)?.call();
  }

  @override
  Widget build(BuildContext context) {
    final descStyle = TextStyle(
      fontSize: 14.sp,
      color: AppColors.textSecondary,
      height: 1.45,
    );

    final amenities = widget.amenityItems.length > 8
        ? widget.amenityItems.take(8).toList()
        : widget.amenityItems;

    return Padding(
      padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.tr.description,
            style: TextStyle(
              fontSize: 17.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: 8.h),
          LayoutBuilder(
            builder: (context, constraints) {
              final needsReadMore =
                  _needsReadMore(constraints.maxWidth, descStyle);
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    widget.description,
                    style: descStyle,
                    maxLines: _descriptionExpanded ? 10 : 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (needsReadMore) ...[
                    SizedBox(height: 6.h),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _descriptionExpanded = !_descriptionExpanded;
                        });
                        widget.onReadMore?.call();
                      },
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: Text(
                        _descriptionExpanded
                            ? context.tr.readLess
                            : '${context.tr.readMore} >',
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary700,
                        ),
                      ),
                    ),
                  ],
                ],
              );
            },
          ),
          SizedBox(height: 20.h),
          Text(
            context.tr.amenities,
            style: TextStyle(
              fontSize: 17.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: 12.h),
          if (amenities.isEmpty)
            Text(
              '—',
              style: TextStyle(
                fontSize: 13.sp,
                color: AppColors.textSecondary,
              ),
            )
          else
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: EdgeInsets.zero,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10.w,
                mainAxisSpacing: 10.h,
                childAspectRatio: 2.85,
              ),
              itemCount: amenities.length,
              itemBuilder: (context, index) {
                final item = amenities[index];
                return _AmenityChip(icon: item.icon, label: item.label);
              },
            ),
          if (widget.amenityItems.length > amenities.length) ...[
            SizedBox(height: 8.h),
            Text(
              '+${widget.amenityItems.length - amenities.length} more',
              style: TextStyle(
                fontSize: 12.sp,
                color: AppColors.textSecondary,
              ),
            ),
          ],
          SizedBox(height: 20.h),
          Row(
            children: [
              Expanded(
                child: Text(
                  context.tr.location,
                  style: TextStyle(
                    fontSize: 17.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              Flexible(
                child: TextButton.icon(
                  onPressed: widget.onGetDirections ?? _openDirections,
                  icon: SvgPicture.asset(Assets.getDirection),
                  label: Text(
                    context.tr.getDirections,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary700,
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Material(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(12.r),
            child: InkWell(
              onTap: _openDirections,
              borderRadius: BorderRadius.circular(12.r),
              child: Container(
                height: 160.h,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(color: AppColors.divider),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.map_outlined,
                      size: 48.r,
                      color: AppColors.primary700,
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      context.tr.getDirections,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AmenityItem {
  const AmenityItem({required this.icon, required this.label});
  final IconData icon;
  final String label;
}

class _AmenityChip extends StatelessWidget {
  const _AmenityChip({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Row(
        children: [
          Icon(icon, size: 20.r, color: AppColors.textPrimary),
          SizedBox(width: 8.w),
          Expanded(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 14.sp,
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
