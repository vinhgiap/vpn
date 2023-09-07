import 'dart:convert';

import 'package:flutter/material.dart';
// import 'package:flutter_html/flutter_html.dart';
import 'package:securevpn/constants/stringConst.dart';
import 'package:webview_flutter/webview_flutter.dart';

class LicenseAggrement extends StatefulWidget {
  static const routeName = '/License';

  @override
  _PrivacyPolicyState createState() => _PrivacyPolicyState();
}

class _PrivacyPolicyState extends State<LicenseAggrement> {
  WebViewController? controller;

  @override
  void initState() {
    super.initState();
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..loadRequest(Uri.parse(StringConst.TOSURl));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('License Agreement'),
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
