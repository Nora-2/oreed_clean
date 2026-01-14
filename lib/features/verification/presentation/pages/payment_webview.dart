// ignore_for_file: unused_field

import 'package:flutter/material.dart';
import 'package:oreed_clean/core/routing/routes.dart';
import 'package:webview_flutter/webview_flutter.dart';

enum PaymentResult { success, cancelled, failed }

class PaymentWebView extends StatefulWidget {
  const PaymentWebView({
    super.key,
    required this.url,
    this.successMatcher,
    this.cancelMatcher,
    this.title,
  });

  final String url;
  final bool Function(String url)? successMatcher;
  final bool Function(String url)? cancelMatcher;
  final String? title;

  @override
  State<PaymentWebView> createState() => _PaymentWebViewState();
}

class _PaymentWebViewState extends State<PaymentWebView> {
  late final WebViewController _controller;
  bool _isLoading = true;
  String? _error;
  bool _showResult = false;
  PaymentResult? _resultType;
  String? _resultHtml;
  bool _statusHandled = false;

  void _goHome() {
    if (!mounted) return;
    Navigator.of(context).pushNamedAndRemoveUntil(
      Routes.homelayout,
      (_) => false,
      arguments: 2,
    );
  }

  @override
  void initState() {
    super.initState();
    // Required on Android for inline WebView.
    // if (Platform.isAndroid) WebView.platform = AndroidWebView();

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..addJavaScriptChannel(
        'PaymentStatusChannel',
        onMessageReceived: (msg) => _handleHtmlStatus(msg.message),
      )
      ..setNavigationDelegate(
        NavigationDelegate(
          onNavigationRequest: _handleNavigation,
          onPageStarted: (_) => setState(() => _isLoading = true),
          onPageFinished: (_) {
            setState(() => _isLoading = false);
            _injectStatusObserver();
          },
          onWebResourceError: (error) => setState(() {
            _error = error.description;
            _isLoading = false;
          }),
        ),
      )
      ..loadRequest(Uri.parse(widget.url));
  }

  NavigationDecision _handleNavigation(NavigationRequest request) {
    final uri = request.url;
    if (_isSuccess(uri)) {
      _showResultPage(isSuccess: true);
      return NavigationDecision.prevent;
    }
    if (_isCancel(uri)) {
      _showResultPage(isSuccess: false);
      return NavigationDecision.prevent;
    }
    return NavigationDecision.navigate;
  }

  bool _isSuccess(String url) {
    if (widget.successMatcher != null) return widget.successMatcher!(url);
    return url.contains('payment/success') || url.contains('status=success');
  }

  bool _isCancel(String url) {
    if (widget.cancelMatcher != null) return widget.cancelMatcher!(url);
    return url.contains('payment/cancel') || url.contains('status=cancel');
  }

  void _injectStatusObserver() {
    if (_statusHandled) return;
    const script = '''(function(){
      const body = document.body;
      if (!body || window.__paymentObserverAdded) return;
      window.__paymentObserverAdded = true;
      const send = (type) => {
        PaymentStatusChannel.postMessage(JSON.stringify({type, text: body.innerText || ''}));
      };
      const check = () => {
        const text = (body.innerText || '').toLowerCase();
        if (text.includes('تم الدفع بنجاح') || text.includes('success') || text.includes('status=success')) { send('success'); }
        else if (text.includes('فشل الدفع') || text.includes('failed') || text.includes('cancel')) { send('failed'); }
      };
      const obs = new MutationObserver(() => check());
      obs.observe(body, {childList:true, subtree:true, characterData:true});
      setTimeout(check, 200);
    })();''';
    _controller.runJavaScript(script);
  }

  void _handleHtmlStatus(String message) {
    if (_statusHandled) return;
    _statusHandled = true;
    try {
      final data = message.isNotEmpty ? Uri.decodeComponent(message) : message;
      final decoded = data.startsWith('{') ? data : null;
      final isSuccess =
          decoded?.contains('success') ?? message.contains('success');
      _showResultPage(isSuccess: isSuccess);
    } catch (_) {
      _showResultPage(isSuccess: message.contains('success'));
    }
  }

  void _showResultPage(
      {required bool isSuccess, String? reference, String? duplicateId}) {
    final html = _buildResultHtml(
      isSuccess: isSuccess,
      reference: reference,
      duplicateId: duplicateId,
    );

    setState(() {
      _resultType = isSuccess ? PaymentResult.success : PaymentResult.failed;
      _resultHtml = html;
      _showResult = true;
      _isLoading = false;
      _error = null;
    });

    _controller.loadHtmlString(html);

    // Auto-close on success to navigate back without user tapping the button.
    if (isSuccess) {
      Future.delayed(const Duration(seconds: 2), () {
        if (!mounted) return;
        _finish(PaymentResult.success);
      });
    }
  }

  String _buildResultHtml({
    required bool isSuccess,
    String? reference,
    String? duplicateId,
  }) {
    final stateClass = isSuccess ? 'success' : 'failed';
    final emoji = isSuccess ? '✅' : '❌';
    final title = isSuccess ? 'تم الدفع بنجاح' : 'فشل الدفع';
    final desc = isSuccess
        ? 'تمت معالجة دفعتك بنجاح. شكرًا لاستخدامك تطبيق اريد.'
        : 'حدث خطأ ما أثناء إتمام عملية الدفع. الرجاء المحاولة لاحقًا.';

    final refLine = reference != null ? '<p>الرقم المرجعي: $reference</p>' : '';
    final dupLine =
        duplicateId != null ? '<p>رقم العملية: $duplicateId</p>' : '';

    return '''<!DOCTYPE html>
<html lang="ar">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>نتيجة الدفع</title>
<link href="https://fonts.googleapis.com/css2?family=Cairo:wght@300;400;600;700;800&display=swap" rel="stylesheet">
<style>
  body { font-family: 'Cairo', "Segoe UI", Tahoma, Arial, sans-serif; background: #f8f9fa; display: flex; align-items: center; justify-content: center; min-height: 100vh; margin: 0; color: #333; direction: rtl; text-align: center; padding: 15px; }
  .card { background: #fff; padding: 30px 20px; border-radius: 16px; box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1); width: 100%; max-width: 420px; animation: fadeIn 0.5s ease-in-out; }
  h2 { margin: 0 0 12px; font-size: 20px; }
  p { margin: 6px 0; font-size: 15px; }
  .success { color: #28a745; }
  .failed { color: #dc3545; }
  @keyframes fadeIn { from { opacity: 0; transform: translateY(20px); } to { opacity: 1; transform: translateY(0); } }
  @media (max-width: 480px) { .card { padding: 22px 16px; border-radius: 12px; } h2 { font-size: 18px; } p { font-size: 14px; } }
</style>
</head>
<body>
  <div class="card">
    <h2 class="$stateClass">$emoji $title</h2>
    <p>$desc</p>
    $refLine
    $dupLine
  </div>
</body>
</html>''';
  }

  void _finish(PaymentResult result) {
    _statusHandled = true;
    if (!mounted) return;
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop(result);
    } else {
      _goHome();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            widget.title ?? 'الدفع',
            style: const TextStyle(color: Colors.white),
          ),
          leading: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => _finish(_resultType ?? PaymentResult.cancelled),
          ),
        ),
        body: Stack(
          children: [
            if (_error != null)
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.error_outline,
                          size: 48, color: Colors.red),
                      const SizedBox(height: 12),
                      Text(_error!, textAlign: TextAlign.center),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _error = null;
                            _isLoading = true;
                            _showResult = false;
                            _resultType = null;
                          });
                          _controller.loadRequest(Uri.parse(widget.url));
                        },
                        child: const Text('إعادة المحاولة'),
                      )
                    ],
                  ),
                ),
              )
            else
              WebViewWidget(controller: _controller),
            if (_isLoading) const LinearProgressIndicator(minHeight: 2),
            if (_showResult)
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _goHome,
                      child: Text(_resultType == PaymentResult.success
                          ? 'العودة للتطبيق'
                          : 'إغلاق'),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
