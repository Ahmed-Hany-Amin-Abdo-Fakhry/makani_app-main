import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:makani_app/Core/Const/app_colors.dart';
import 'package:makani_app/Core/Const/localization_extension.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart';
import 'package:webview_flutter/webview_flutter.dart';

bool _isYoutubeUrl(String url) {
  final lower = url.toLowerCase();
  return lower.contains('youtube.com') || lower.contains('youtu.be');
}

String? _youtubeEmbedUrl(String url) {
  final uri = Uri.tryParse(url.trim());
  if (uri == null) return null;
  String? id;
  if (uri.host.contains('youtu.be') && uri.pathSegments.isNotEmpty) {
    id = uri.pathSegments.first;
  }
  id ??= uri.queryParameters['v'];
  if (id == null || id.isEmpty) return null;
  return 'https://www.youtube.com/embed/$id?playsinline=1';
}

bool _isDirectVideoFileUrl(String url) {
  if (_isYoutubeUrl(url)) return false;
  final lower = url.toLowerCase();
  if (lower.endsWith('.mp4') ||
      lower.endsWith('.webm') ||
      lower.endsWith('.mov') ||
      lower.endsWith('.m4v')) {
    return true;
  }
  if (lower.contains('cloudinary.com') && lower.contains('/video/')) {
    return true;
  }
  return false;
}

class PropertyDetailVideoTab extends StatefulWidget {
  const PropertyDetailVideoTab({super.key, this.videoUrl});

  final String? videoUrl;

  @override
  State<PropertyDetailVideoTab> createState() => _PropertyDetailVideoTabState();
}

class _PropertyDetailVideoTabState extends State<PropertyDetailVideoTab> {
  VideoPlayerController? _video;
  WebViewController? _web;
  bool _videoFailed = false;

  @override
  void initState() {
    super.initState();
    _initFromUrl(widget.videoUrl);
  }

  @override
  void didUpdateWidget(covariant PropertyDetailVideoTab oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.videoUrl != widget.videoUrl) {
      _disposeVideo();
      _web = null;
      _videoFailed = false;
      _initFromUrl(widget.videoUrl);
      setState(() {});
    }
  }

  void _disposeVideo() {
    _video?.dispose();
    _video = null;
  }

  void _initFromUrl(String? raw) {
    final url = raw?.trim();
    if (url == null || url.isEmpty) return;

    if (_isDirectVideoFileUrl(url)) {
      final uri = Uri.tryParse(url);
      if (uri != null && uri.hasScheme) {
        final c = VideoPlayerController.networkUrl(uri);
        _video = c;
        c.initialize().then((_) {
          if (mounted) setState(() {});
        }).catchError((_) {
          if (mounted) {
            _disposeVideo();
            WebViewController? fallbackWeb;
            if (Uri.tryParse(url)?.hasScheme == true) {
              final escapedUrl = url.replaceAll('"', '&quot;');
              final html = '''<!DOCTYPE html>
<html>
<head>
<meta name="viewport" content="width=device-width,initial-scale=1,user-scalable=no">
<style>
*{margin:0;padding:0;box-sizing:border-box}
body{background:#000;display:flex;align-items:center;justify-content:center;height:100vh;overflow:hidden}
video{width:100%;height:100%;object-fit:contain;outline:none}
</style>
</head>
<body>
<video controls autoplay playsinline src="$escapedUrl"></video>
</body>
</html>''';
              fallbackWeb = WebViewController()
                ..setJavaScriptMode(JavaScriptMode.unrestricted)
                ..setBackgroundColor(Colors.black)
                ..loadHtmlString(html);
            }
            setState(() {
              _videoFailed = true;
              _web = fallbackWeb;
            });
          }
        });
      }
      return;
    }

    String? loadUrl = url;
    if (_isYoutubeUrl(url)) {
      loadUrl = _youtubeEmbedUrl(url) ?? url;
    }
    final uri = Uri.tryParse(loadUrl);
    if (uri != null && uri.hasScheme) {
      _web = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..setBackgroundColor(Colors.black)
        ..loadRequest(uri);
    }
  }

  @override
  void dispose() {
    _disposeVideo();
    super.dispose();
  }

  Future<void> _openInBrowser(String url) async {
    final uri = Uri.tryParse(url.trim());
    if (uri == null || !uri.hasScheme) return;
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final s = context.tr;
    final url = widget.videoUrl?.trim() ?? '';

    if (url.isEmpty) {
      return Center(
        child: Padding(
          padding: EdgeInsets.all(24.w),
          child: Text(
            s.video,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14.sp,
              color: AppColors.textSecondary,
            ),
          ),
        ),
      );
    }

    if (_video != null && _video!.value.isInitialized) {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12.r),
                child: AspectRatio(
                  aspectRatio: _video!.value.aspectRatio == 0
                      ? 16 / 9
                      : _video!.value.aspectRatio,
                  child: VideoPlayer(_video!),
                ),
              ),
            ),
            SizedBox(height: 8.h),
            VideoProgressIndicator(
              _video!,
              allowScrubbing: true,
              colors: VideoProgressColors(
                playedColor: AppColors.primary700,
                bufferedColor: AppColors.primary700.withValues(alpha: 0.35),
                backgroundColor: AppColors.divider,
              ),
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 4.h),
            ),
            SizedBox(height: 8.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ValueListenableBuilder<VideoPlayerValue>(
                  valueListenable: _video!,
                  builder: (context, value, _) {
                    return FilledButton(
                      onPressed: () {
                        if (value.isPlaying) {
                          _video!.pause();
                        } else {
                          _video!.play();
                        }
                      },
                      child: Icon(
                        value.isPlaying ? Icons.pause : Icons.play_arrow,
                        size: 28.r,
                        color: Colors.white,
                      ),
                    );
                  },
                ),
                SizedBox(width: 12.w),
                ValueListenableBuilder<VideoPlayerValue>(
                  valueListenable: _video!,
                  builder: (context, value, _) {
                    return OutlinedButton(
                      onPressed: () =>
                          _video!.setVolume(value.volume > 0 ? 0 : 1),
                      child: Icon(
                        value.volume > 0 ? Icons.volume_up : Icons.volume_off,
                        size: 22.r,
                      ),
                    );
                  },
                ),
                SizedBox(width: 12.w),
                OutlinedButton(
                  onPressed: () => _openInBrowser(url),
                  child: Icon(Icons.open_in_new, size: 22.r),
                ),
              ],
            ),
          ],
        ),
      );
    }

    if (_video != null && !_video!.value.isInitialized && !_videoFailed) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(),
            SizedBox(height: 16.h),
            Text(
              s.video,
              style: TextStyle(color: AppColors.textSecondary, fontSize: 13.sp),
            ),
          ],
        ),
      );
    }

    if (_web != null) {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12.r),
              child: SizedBox(
                height: 220.h,
                width: double.infinity,
                child: WebViewWidget(controller: _web!),
              ),
            ),
            SizedBox(height: 8.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FilledButton(
                  onPressed: () => _web!.reload(),
                  child: Icon(Icons.refresh, size: 22.r, color: Colors.white),
                ),
                SizedBox(width: 12.w),
                OutlinedButton(
                  onPressed: () => _openInBrowser(url),
                  child: Icon(Icons.open_in_new, size: 22.r),
                ),
              ],
            ),
          ],
        ),
      );
    }

    return Center(
      child: Padding(
        padding: EdgeInsets.all(20.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.videocam_off_outlined,
                size: 48.r, color: AppColors.textSecondary),
            SizedBox(height: 12.h),
            Text(
              _videoFailed ? 'Could not play in app' : s.video,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14.sp, color: AppColors.textSecondary),
            ),
            SizedBox(height: 16.h),
            FilledButton.icon(
              onPressed: () => _openInBrowser(url),
              icon: const Icon(Icons.play_circle_outline),
              label: const Text('Open video'),
            ),
          ],
        ),
      ),
    );
  }
}
