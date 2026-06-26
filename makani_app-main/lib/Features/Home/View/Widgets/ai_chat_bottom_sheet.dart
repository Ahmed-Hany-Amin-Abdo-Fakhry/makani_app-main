import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:makani_app/Core/Const/app_colors.dart';
import 'package:makani_app/Core/Const/app_constants.dart';
import 'package:webview_flutter/webview_flutter.dart';

class AiChatBottomSheet extends StatefulWidget {
  const AiChatBottomSheet({super.key});

  @override
  State<AiChatBottomSheet> createState() => _AiChatBottomSheetState();
}

class _AiChatBottomSheetState extends State<AiChatBottomSheet> {
  late final WebViewController _chatWebViewController;
  static final Set<Factory<OneSequenceGestureRecognizer>> _webViewGestures = {
    Factory<OneSequenceGestureRecognizer>(() => EagerGestureRecognizer()),
  };
  static final Uri _kommunicateChatUri = Uri.parse(
    'https://widget.kommunicate.io/chat?appId=${AppConstants.kommunicateAppId}&hideLauncher=true&popupWidget=true',
  );

  @override
  void initState() {
    super.initState();
    _chatWebViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.transparent)
      ..setNavigationDelegate(
        NavigationDelegate(
          onWebResourceError: (error) {
            debugPrint("WebView error: ${error.description}");
          },
          onPageFinished: (url) async {
            await _chatWebViewController.runJavaScript('''
        try {
          Kommunicate && Kommunicate.launchConversation();
        } catch(e) {
          console.log("Kommunicate not ready");
        }
      ''');
          },
        ),
      )
      ..loadRequest(_kommunicateChatUri);
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    return Padding(
      padding: EdgeInsets.only(top: 24.h),
      child: Container(
        height: .9.sh,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
        ),
        child: Column(
          children: [
            SizedBox(height: 12.h),
            Container(
              width: 48.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: AppColors.textSecondary.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(6.r),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(16.w, 10.h, 8.w, 8.h),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'AI Assistant',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(bottom: bottomInset),
                child: WebViewWidget(
                  controller: _chatWebViewController,
                  gestureRecognizers: _webViewGestures,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
