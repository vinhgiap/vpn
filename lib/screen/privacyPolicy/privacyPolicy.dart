import 'dart:convert';

import 'package:flutter/material.dart';
// import 'package:flutter_html/flutter_html.dart';
import 'package:securevpn/constants/stringConst.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PrivacyPolicy extends StatefulWidget {
  static const routeName = '/privacy-policy';

  @override
  _PrivacyPolicyState createState() => _PrivacyPolicyState();
}

class _PrivacyPolicyState extends State<PrivacyPolicy> {
  WebViewController? controller;

  @override
  void initState() {
    super.initState();
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..loadRequest(Uri.parse(StringConst.PrivacyPolicyUrl));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Privacy Policy'),
      ),
      body: WebViewWidget(
        controller: controller!,
      ),
    );
  }

  @override
  void dispose() {
    // controller!.();
    super.dispose();
  }
}
