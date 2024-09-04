import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_easylogger/flutter_logger.dart';
import 'package:poster_stock/features/settings/view/screens/functions_adress_ton.dart';

import 'package:poster_stock/features/settings/view/screens/html.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

// ignore: depend_on_referenced_packages
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';

class TonConnectPage extends StatefulWidget {
  const TonConnectPage({super.key});

  @override
  TonConnectPageState createState() => TonConnectPageState();
}

class TonConnectPageState extends State<TonConnectPage> {
  late WebViewController _controller;

  @override
  void initState() {
    super.initState();
    late final PlatformWebViewControllerCreationParams params;
    if (WebViewPlatform.instance is WebKitWebViewPlatform) {
      params = WebKitWebViewControllerCreationParams(
        allowsInlineMediaPlayback: true,
        mediaTypesRequiringUserAction: const <PlaybackMediaTypes>{},
      );
    } else {
      params = const PlatformWebViewControllerCreationParams();
    }
    final String contentBase64 = base64Encode(
      const Utf8Encoder().convert(html),
    );
    final WebViewController controller =
        WebViewController.fromPlatformCreationParams(params);
    controller
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onNavigationRequest: (NavigationRequest request) {
            Logger.i('request.url ==== ${request.url}');
            // if (request.url.startsWith('tonkeeper://')) {
            launchURL(request.url);
            return NavigationDecision
                .prevent; // Предотвращаем загрузку в WebView
          },
        ),
      )
      ..addJavaScriptChannel(
        'MessageHandler',
        onMessageReceived: (JavaScriptMessage message) {
          String tonAddress = getAddressTon(message.message);
          Logger.i('tonAddress ==== $tonAddress');
          Navigator.pop(context, tonAddress);
        },
      )
      ..loadRequest(
        Uri.parse('data:text/html;base64,$contentBase64'),
      );

    _controller = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Подключение к кошельку')),
      body: WebViewWidget(controller: _controller),
    );
  }

  void launchURL(String url) async {
    try {
      url = '$url?redirect_uri=https://posterstock.io';
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    } catch (e) {
      Logger.e('Could not launch try ==== $url');
    }
  }
}
