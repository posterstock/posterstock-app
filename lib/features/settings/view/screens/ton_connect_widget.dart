import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_easylogger/flutter_logger.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';
// ignore: depend_on_referenced_packages
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';
import 'html.dart';

class TonConnectWidget extends StatefulWidget {
  const TonConnectWidget({super.key});
  @override
  TonConnectWidgetState createState() => TonConnectWidgetState();
}

class TonConnectWidgetState extends State<TonConnectWidget> {
  late WebViewController _controller;

  @override
  void initState() {
    super.initState();
    initWebView();
  }

  void initWebView() async {
    PlatformWebViewControllerCreationParams params;
    if (WebViewPlatform.instance is WebKitWebViewPlatform) {
      params = WebKitWebViewControllerCreationParams(
        allowsInlineMediaPlayback: true,
        mediaTypesRequiringUserAction: const <PlaybackMediaTypes>{},
      );
    } else {
      params = const PlatformWebViewControllerCreationParams();
    }

    final String contentBase64 =
        base64Encode(const Utf8Encoder().convert(htmlAddess));
    final WebViewController controller =
        WebViewController.fromPlatformCreationParams(params);
    controller
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith('tonkeeper://')) {
              launchURL(request.url);
              return NavigationDecision
                  .prevent; // Предотвращаем загрузку в WebView
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..addJavaScriptChannel(
        'MessageHandler',
        onMessageReceived: (JavaScriptMessage message) {
          Logger.i('Received hex address: ${message.message}');
          Navigator.pop(context,
              message.message); // Возвращаем адрес при закрытии модального окна
        },
      )
      ..loadRequest(Uri.parse('data:text/html;base64,$contentBase64'));

    setState(() {
      _controller = controller;
    });
  }

  void launchURL(String url) async {
    try {
      url = '$url?redirect_uri=https://posterstock.io';
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    } catch (e) {
      Logger.e('Could not launch URL: $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return WebViewWidget(controller: _controller);
  }
}
