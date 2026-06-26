import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:makani_app/Core/Const/assets.dart';

/// Full-screen image viewer with pinch-to-zoom; swipe between photos when
/// [imageUrls] has more than one entry. Uses [fallbackAsset] when [imageUrls] is empty.
class PropertyGalleryFullscreen extends StatefulWidget {
  const PropertyGalleryFullscreen({
    super.key,
    required this.imageUrls,
    this.initialIndex = 0,
    this.fallbackAsset = Assets.homeImage,
  });

  final List<String> imageUrls;
  final int initialIndex;
  final String fallbackAsset;

  @override
  State<PropertyGalleryFullscreen> createState() =>
      _PropertyGalleryFullscreenState();
}

class _PropertyGalleryFullscreenState extends State<PropertyGalleryFullscreen> {
  PageController? _pageController;
  late int _index;

  bool get _hasNetwork => widget.imageUrls.isNotEmpty;

  @override
  void initState() {
    super.initState();
    if (_hasNetwork) {
      final n = widget.imageUrls.length;
      _index = widget.initialIndex.clamp(0, n - 1);
      _pageController = PageController(initialPage: _index);
    } else {
      _index = 0;
    }
  }

  @override
  void dispose() {
    _pageController?.dispose();
    super.dispose();
  }

  Widget _zoomable(BuildContext context, Widget image) {
    final size = MediaQuery.sizeOf(context);
    return InteractiveViewer(
      minScale: 0.8,
      maxScale: 4,
      child: SizedBox(
        width: size.width,
        height: size.height,
        child: image,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          fit: StackFit.expand,
          children: [
            if (!_hasNetwork)
              Positioned.fill(
                child: _zoomable(
                  context,
                  Image.asset(
                    widget.fallbackAsset,
                    width: size.width,
                    height: size.height,
                    fit: BoxFit.contain,
                  ),
                ),
              )
            else
              Positioned.fill(
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: widget.imageUrls.length,
                  onPageChanged: (i) => setState(() => _index = i),
                  itemBuilder: (context, i) {
                    return _zoomable(
                      context,
                      Image.network(
                        widget.imageUrls[i],
                        width: size.width,
                        height: size.height,
                        fit: BoxFit.contain,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return const Center(
                            child: CircularProgressIndicator(
                              color: Colors.white54,
                            ),
                          );
                        },
                        errorBuilder: (_, __, ___) => Center(
                          child: Icon(
                            Icons.broken_image_outlined,
                            color: Colors.white54,
                            size: 48.r,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            Positioned(
              top: 4.h,
              right: 4.w,
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.white),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
            if (_hasNetwork && widget.imageUrls.length > 1)
              Positioned(
                bottom: 16.h,
                left: 0,
                right: 0,
                child: Text(
                  '${_index + 1} / ${widget.imageUrls.length}',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
