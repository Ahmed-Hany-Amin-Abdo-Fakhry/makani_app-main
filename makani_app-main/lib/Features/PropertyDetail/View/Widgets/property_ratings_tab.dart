import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:makani_app/Core/Const/app_colors.dart';
import 'package:makani_app/Core/Const/localization_extension.dart';
import 'package:makani_app/Features/Listings/Model/property_listing.dart';
import 'package:makani_app/Features/PropertyDetail/Cubit/property_detail_cubit.dart';
import 'package:makani_app/Features/Ratings/Model/rating_review.dart';

typedef SubmitReviewCallback = Future<PropertyReviewSubmitStatus> Function({
  required int rating,
  required String reviewText,
});

class PropertyRatingsTab extends StatelessWidget {
  const PropertyRatingsTab({
    super.key,
    required this.listing,
    required this.reviews,
    required this.currentUid,
    required this.myReview,
    required this.onSubmitReview,
  });

  final PropertyListing listing;
  final List<RatingReview> reviews;
  final String? currentUid;
  final RatingReview? myReview;
  final SubmitReviewCallback onSubmitReview;

  bool get _canReview => currentUid != null && currentUid != listing.ownerId;

  String _reviewDateLabel(BuildContext context, RatingReview review) {
    final s = context.tr;
    final date = review.updatedAt ?? review.createdAt;
    if (date == null) return s.ratingJustNow;
    return DateFormat.yMMMd().format(date);
  }

  Future<_ReviewDraft?> _showReviewDialog({
    required BuildContext context,
    required int initialRating,
    required String initialReviewText,
  }) async {
    final controller = TextEditingController(text: initialReviewText);
    var selectedRating = initialRating;
    final s = context.tr;

    return showDialog<_ReviewDraft>(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setLocalState) {
            return AlertDialog(
              backgroundColor: Colors.white,
              insetPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),
              title: Text(s.writeReview),
              content: SingleChildScrollView(
                child: SizedBox(
                  width: 380.w,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        s.tapToRate,
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 13.sp,
                        ),
                      ),
                      SizedBox(height: 10.h),
                      Row(
                        children: List.generate(5, (index) {
                          final star = index + 1;
                          return IconButton(
                            onPressed: () =>
                                setLocalState(() => selectedRating = star),
                            icon: Icon(
                              star <= selectedRating
                                  ? Icons.star
                                  : Icons.star_border,
                              color: Colors.amber,
                            ),
                          );
                        }),
                      ),
                      SizedBox(height: 8.h),
                      TextField(
                        controller: controller,
                        minLines: 4,
                        maxLines: 6,
                        maxLength: 400,
                        decoration: InputDecoration(
                          hintText: s.shareYourExperience,
                          border: const OutlineInputBorder(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(dialogContext).pop(),
                  child: Text(s.back),
                ),
                FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.primary700,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.of(dialogContext).pop(
                      _ReviewDraft(
                        rating: selectedRating,
                        reviewText: controller.text.trim(),
                      ),
                    );
                  },
                  child: Text(s.submitReview),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _handleReviewAction(BuildContext context) async {
    final draft = await _showReviewDialog(
      context: context,
      initialRating: myReview?.rating ?? 0,
      initialReviewText: myReview?.reviewText ?? '',
    );
    if (!context.mounted || draft == null) return;

    final status = await onSubmitReview(
      rating: draft.rating,
      reviewText: draft.reviewText,
    );
    if (!context.mounted) return;

    final s = context.tr;
    final messenger = ScaffoldMessenger.of(context);
    switch (status) {
      case PropertyReviewSubmitStatus.submitted:
        messenger.showSnackBar(
          SnackBar(content: Text(s.reviewSubmittedSuccess)),
        );
      case PropertyReviewSubmitStatus.updated:
        messenger.showSnackBar(
          SnackBar(content: Text(s.reviewUpdatedSuccess)),
        );
      case PropertyReviewSubmitStatus.ownerNotAllowed:
        messenger.showSnackBar(
          SnackBar(content: Text(s.ownerCannotReviewProperty)),
        );
      case PropertyReviewSubmitStatus.invalidInput:
      case PropertyReviewSubmitStatus.notLoaded:
      case PropertyReviewSubmitStatus.notFound:
        messenger.showSnackBar(
          SnackBar(content: Text(s.reviewSubmitError)),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final s = context.tr;
    return Padding(
      padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 24.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: AppColors.divider),
            ),
            child: Row(
              children: [
                Icon(Icons.star_rounded, color: Colors.amber, size: 26.r),
                SizedBox(width: 8.w),
                Text(
                  ((listing.ratingCount ?? 0) > 0 ? (listing.ratingAverage ?? 0) : 0)
                      .toStringAsFixed(1),
                  style: TextStyle(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: Text(
                    s.ratingSummary(
                      listing.ratingCount ?? 0,
                      listing.reviewCount ?? 0,
                    ),
                    style: TextStyle(
                      fontSize: 13.sp,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 14.h),
          if (currentUid == null)
            Text(
              s.loginToRateProperty,
              style: TextStyle(color: AppColors.textSecondary),
            )
          else if (!_canReview)
            Text(
              s.ownerCannotReviewProperty,
              style: TextStyle(color: AppColors.textSecondary),
            )
          else
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () => _handleReviewAction(context),
                icon: const Icon(Icons.rate_review_outlined),
                label: Text(
                  myReview == null ? s.writeReview : s.editYourReview,
                ),
              ),
            ),
          SizedBox(height: 18.h),
          Text(
            s.reviews,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: 10.h),
          if (reviews.isEmpty)
            Padding(
              padding: EdgeInsets.symmetric(vertical: 14.h),
              child: Text(
                s.noReviewsYet,
                style: TextStyle(color: AppColors.textSecondary),
              ),
            )
          else
            ...reviews.map(
              (review) => Container(
                width: double.infinity,
                margin: EdgeInsets.only(bottom: 10.h),
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(color: AppColors.divider),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Builder(
                      builder: (context) {
                        final name = (review.reviewerName ?? '').trim();
                        final headerLabel = name.isNotEmpty
                            ? name
                            : (review.reviewerUid == currentUid
                                ? s.yourReviewLabel
                                : s.reviewerLabel);
                        return Row(
                          children: [
                            Text(
                              headerLabel,
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            const Spacer(),
                            Text(
                              _reviewDateLabel(context, review),
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                    SizedBox(height: 6.h),
                    Row(
                      children: List.generate(
                        5,
                        (index) => Icon(
                          index < review.rating ? Icons.star : Icons.star_border,
                          color: Colors.amber,
                          size: 18.r,
                        ),
                      ),
                    ),
                    if (review.hasReviewText) ...[
                      SizedBox(height: 8.h),
                      Text(
                        review.reviewText!.trim(),
                        style: TextStyle(color: AppColors.textPrimary),
                      ),
                    ],
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _ReviewDraft {
  const _ReviewDraft({
    required this.rating,
    required this.reviewText,
  });

  final int rating;
  final String reviewText;
}
