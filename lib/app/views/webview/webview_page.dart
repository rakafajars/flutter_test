import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewPage extends StatefulWidget {
  const WebViewPage({super.key});

  @override
  State<WebViewPage> createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  late final WebViewController _controller;
  final RxBool _isLoading = true.obs;
  final RxInt _progress = 0.obs;

  @override
  void initState() {
    super.initState();
    final url = Get.arguments as String? ?? '';

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            _progress.value = progress;
          },
          onPageStarted: (String url) {
            _isLoading.value = true;
          },
          onPageFinished: (String url) {
            _isLoading.value = false;
          },
          onWebResourceError: (WebResourceError error) {
            _isLoading.value = false;
          },
        ),
      )
      ..loadRequest(Uri.parse(url));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF9C27B0),
        foregroundColor: Colors.white,
        title: const Text('Article'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Get.back(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => _controller.reload(),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(3),
          child: Obx(() {
            if (_isLoading.value) {
              return LinearProgressIndicator(
                value: _progress.value / 100,
                backgroundColor: Colors.purple.shade200,
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
              );
            }
            return const SizedBox.shrink();
          }),
        ),
      ),
      body: WebViewWidget(controller: _controller),
    );
  }
}
