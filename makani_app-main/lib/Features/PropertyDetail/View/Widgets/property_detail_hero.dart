import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:makani_app/Core/Const/app_colors.dart';
import 'package:makani_app/Core/Const/assets.dart';
import 'package:makani_app/Features/PropertyDetail/View/Widgets/property_gallery_fullscreen.dart';

class PropertyDetailHero extends StatefulWidget {
  const PropertyDetailHero({
    super.key,
    this.imageUrls,
    required this.onBack,
    this.onShare,
    this.onFavorite,
    this.isFavorited = false,
  });

  /// Network image URLs. Empty or null → [Assets.homeImage] placeholder.
  final List<String>? imageUrls;
  final VoidCallback onBack;
  final VoidCallback? onShare;
  final VoidCallback? onFavorite;
  final bool isFavorited;

  @override
  State<PropertyDetailHero> createState() => _PropertyDetailHeroState();
}

class _PropertyDetailHeroState extends State<PropertyDetailHero> {
  static const _autoSlideInterval = Duration(seconds: 4);

  PageController? _pageController;
  Timer? _timer;
  int _page = 0;

  List<String> _effectiveUrls() {
    if (widget.imageUrls == null || widget.imageUrls!.isEmpty) {
      return const [];
    }
    return widget.imageUrls!
        .map((u) => u.trim())
        .where((u) => u.isNotEmpty)
        .toList();
  }

  bool get _multi => _effectiveUrls().length > 1;

  @override
  void initState() {
    super.initState();
    if (_multi) {
      _pageController = PageController();
      _scheduleTimer();
    }
  }

  void _scheduleTimer() {
    _timer?.cancel();
    if (!_multi) return;
    _timer = Timer.periodic(_autoSlideInterval, (_) {
      if (!mounted || _pageController == null || !_pageController!.hasClients) {
        return;
      }
      final urls = _effectiveUrls();
      if (urls.isEmpty) return;
      final next = (_page + 1) % urls.length;
      _pageController!.animateToPage(
        next,
        duration: const Duration(milliseconds: 380),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void didUpdateWidget(covariant PropertyDetailHero oldWidget) {
    super.didUpdateWidget(oldWidget);
    final oldMulti = oldWidget.imageUrls != null &&
        oldWidget.imageUrls!.map((e) => e.trim()).where((e) => e.isNotEmpty).length >
            1;
    final nowMulti = _multi;
    if (oldMulti != nowMulti) {
      _timer?.cancel();
      _pageController?.dispose();
      _pageController = null;
      _page = 0;
      if (nowMulti) {
        _pageController = PageController();
        _scheduleTimer();
      }
    } else if (nowMulti &&
        oldWidget.imageUrls?.length != widget.imageUrls?.length) {
      _page = _page.clamp(0, _effectiveUrls().length - 1);
      _scheduleTimer();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController?.dispose();
    super.dispose();
  }

  Widget _networkImage(String url) {
    return Image.network(
      url,
      width: double.infinity,
      height: double.infinity,
      fit: BoxFit.cover,
    );
  }

  void _openFullscreen(BuildContext context) {
    final urls = _effectiveUrls();
    Navigator.of(context).push<void>(
      MaterialPageRoute<void>(
        fullscreenDialog: true,
        builder: (ctx) => PropertyGalleryFullscreen(
          imageUrls: urls,
          initialIndex: urls.length > 1 ? _page : 0,
        ),
      ),
    );
  }

  Widget _imageLayer() {
    final urls = _effectiveUrls();
    if (urls.isEmpty) {
      return Image(
        image: AssetImage(Assets.homeImage),
        width: double.infinity,
        height: double.infinity,
        fit: BoxFit.cover,
      );
    }
    if (!_multi) {
      return _networkImage(urls.first);
    }
    return PageView.builder(
      controller: _pageController,
      itemCount: urls.length,
      onPageChanged: (i) {
        setState(() => _page = i);
        _scheduleTimer();
      },
      itemBuilder: (context, i) => _networkImage(urls[i]),
    );
  }

  @override
  Widget build(BuildContext context) {
    final urls = _effectiveUrls();
    return Stack(
      children: [
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => _openFullscreen(context),
          child: ClipRRect(
            child: SizedBox(
              height: 280.h,
              width: double.infinity,
              child: _imageLayer(),
            ),
          ),
        ),
        Positioned(
          top: MediaQuery.of(context).padding.top + 8.h,
          left: 8.w,
          child: IconButton(
            icon: Transform.rotate(
              angle: Directionality.of(context) == TextDirection.rtl ? pi : 0,
              child: const Icon(Icons.chevron_left, color: Colors.black),
            ),
            onPressed: widget.onBack,
            style: IconButton.styleFrom(
              backgroundColor: Colors.white.withAlpha(50),
            ),
          ),
        ),
        Positioned(
          top: MediaQuery.of(context).padding.top + 8.h,
          right: 8.w,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.share_outlined, color: Colors.black),
                onPressed: widget.onShare ?? () {},
                style: IconButton.styleFrom(
                  backgroundColor: Colors.white.withAlpha(50),
                ),
              ),
              SizedBox(width: 16.w),
              IconButton(
                icon: Icon(
                  widget.isFavorited
                      ? Icons.favorite
                      : Icons.favorite_border,
                  color: AppColors.error,
                ),
                onPressed: widget.onFavorite ?? () {},
                style: IconButton.styleFrom(
                  backgroundColor: Colors.white.withAlpha(50),
                ),
              ),
            ],
          ),
        ),
        if (urls.length > 1)
          Positioned(
            bottom: 12.h,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(urls.length, (i) {
                return Container(
                  margin: EdgeInsets.symmetric(horizontal: 3.w),
                  width: i == _page ? 14.w : 8.w,
                  height: 8.w,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4.r),
                    color: i == _page
                        ? AppColors.textPrimary
                        : Colors.white.withValues(alpha: 0.7),
                  ),
                );
              }),
            ),
          ),
      ],
    );
  }
}
