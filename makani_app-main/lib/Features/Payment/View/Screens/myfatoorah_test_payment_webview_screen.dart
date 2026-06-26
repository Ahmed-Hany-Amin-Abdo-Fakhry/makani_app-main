import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:makani_app/Core/Config/myfatoorah_config.dart';
import 'package:makani_app/Core/Const/app_colors.dart';
import 'package:makani_app/Core/Const/localization_extension.dart';
import 'package:makani_app/Features/Payment/Services/myfatoorah_payment_service.dart';
import 'package:makani_app/generated/l10n.dart';
import 'package:webview_flutter/webview_flutter.dart';

class MyFatoorahTestPaymentWebViewScreen extends StatefulWidget {
  const MyFatoorahTestPaymentWebViewScreen({super.key});

  @override
  State<MyFatoorahTestPaymentWebViewScreen> createState() =>
      _MyFatoorahTestPaymentWebViewScreenState();
}

class _MyFatoorahTestPaymentWebViewScreenState
    extends State<MyFatoorahTestPaymentWebViewScreen> {
  final _paymentService = MyFatoorahPaymentService();
  WebViewController? _controller;
  bool _loadingInvoice = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _startPayment());
  }

  Future<void> _startPayment() async {
    setState(() {
      _loadingInvoice = true;
      _errorMessage = null;
      _controller = null;
    });

    try {
      final invoiceUrl = await _paymentService.createTestInvoiceUrl(
        customerName: 'Makani Test User',
      );
      if (!mounted) return;

      final controller = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..setBackgroundColor(Colors.white)
        ..setNavigationDelegate(
          NavigationDelegate(
            onNavigationRequest: _handleNavigation,
          ),
        )
        ..loadRequest(Uri.parse(invoiceUrl));

      setState(() {
        _controller = controller;
        _loadingInvoice = false;
      });
    } on MyFatoorahPaymentException catch (e) {
      if (!mounted) return;
      setState(() {
        _loadingInvoice = false;
        _errorMessage = e.message;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _loadingInvoice = false;
        _errorMessage = context.tr.addAdTestPaymentError;
      });
    }
  }

  NavigationDecision _handleNavigation(NavigationRequest request) {
    final url = request.url;
    if (url.startsWith(MyFatoorahConfig.callbackUrl)) {
      Navigator.of(context).pop(true);
      return NavigationDecision.prevent;
    }
    if (url.startsWith(MyFatoorahConfig.errorUrl)) {
      Navigator.of(context).pop(false);
      return NavigationDecision.prevent;
    }
    return NavigationDecision.navigate;
  }

  @override
  Widget build(BuildContext context) {
    final s = context.tr;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(s.addAdTestPaymentTitle),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: _buildBody(s),
    );
  }

  Widget _buildBody(S s) {
    if (_loadingInvoice) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(),
            SizedBox(height: 16.h),
            Text(
              s.addAdTestPaymentLoading,
              style: TextStyle(
                fontSize: 14.sp,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      );
    }

    if (_errorMessage != null) {
      return Padding(
        padding: EdgeInsets.all(24.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 48.r, color: Colors.red.shade700),
            SizedBox(height: 16.h),
            Text(
              _errorMessage!,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14.sp,
                color: AppColors.textSecondary,
                height: 1.4,
              ),
            ),
            SizedBox(height: 24.h),
            FilledButton(
              onPressed: _startPayment,
              child: Text(s.addAdTestPaymentRetry),
            ),
          ],
        ),
      );
    }

    final controller = _controller;
    if (controller == null) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          width: double.infinity,
          color: AppColors.primary.withValues(alpha: 0.08),
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
          child: Text(
            s.addAdTestPaymentSandboxHint,
            style: TextStyle(
              fontSize: 12.sp,
              color: AppColors.textSecondary,
              height: 1.35,
            ),
          ),
        ),
        Expanded(
          child: WebViewWidget(controller: controller),
        ),
      ],
    );
  }
}
