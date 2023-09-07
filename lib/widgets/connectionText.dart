import 'dart:async';
// import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';
import 'package:openvpn_flutter_update/openvpn_flutter.dart';
// import 'package:openvpn_flutter/openvpn_flutter.dart';
import 'package:securevpn/constants/colorsConst.dart';
import 'package:securevpn/modal/vpn.dart';

import 'package:securevpn/constants/stringConst.dart';

class ConnectionText extends StatefulWidget {
  //final Vpns vpns;

  const ConnectionText({Key? key}) : super(key: key);

  @override
  _ConnectionTextState createState() => _ConnectionTextState();
}

class _ConnectionTextState extends State<ConnectionText> {
  Stopwatch? _stopwatch;

  OpenVPN? engine;
  VpnStatus? status2;
  VPNStage? stage;
  bool _granted = false;
  String _connectionState = 'Not Connected';
  String get connectionState => _connectionState;
  set connectionState(String connectionState) {
    _connectionState = connectionState;
    // notifyListeners();
  }

  @override
  void initState() {
    // _interstitialAd?.dispose();
    // _interstitialAd = createInterstitialAd()..load();
    Timer.periodic(Duration(seconds: 5), (timer) {
      _connectionState = "Not Connected";
      engine = OpenVPN(
        onVpnStatusChanged: (data) {
          // status2 = data;
          // print(status2);
        },
        onVpnStageChanged: (data, raw) {
          // print(data.toString());
          if (data.toString() == 'VPNStage.connected') {
            // connectionState('CONNECTED');
            _connectionState = 'CONNECTED';
            setState(() {});
            print("succeed");
          } else if (data.toString() == 'VPNStage.connecting') {
            // _connectedVpn = vpn;
            _connectionState = 'CONNECTING';
            // notifyListeners();
          } else if (data.toString() == 'VPNStage.authenticating') {
            // _connectedVpn = vpn;
            _connectionState = 'RECONNECTING';
            setState(() {});
            // notifyListeners();
          } else if (data.toString() == 'VPNStage.disconnected') {
            // _connectedVpn = vpn;
            _connectionState = 'DISCONNECTED';
            setState(() {});
            // notifyListeners();
          } else if (data.toString() == 'VPNStage.disconnecting') {
            // _connectedVpn = vpn;
            _connectionState = 'disconnecting';
            setState(() {});
            // notifyListeners();
          } else if (data.toString() == 'VPNStage.denied') {
            // _connectedVpn = vpn;
            _connectionState = 'denied';
            setState(() {});
          }

          // stage = data;
        },
      );

      engine!.initialize(
          groupIdentifier: StringConst.groupIdentifier,
          providerBundleIdentifier: StringConst.providerBundleIdentifier,
          localizedDescription: StringConst.APPNAME);
      this.setState(() {});
    });
    // Timer.periodic(Duration(seconds: 1), (timer) {
    //   this.setState(() {});
    // });

    // Timer(Duration(seconds: 1), () {

    // });

    super.initState();
    _stopwatch = Stopwatch();
  }

  void handleStartStop() {
    if (_stopwatch!.isRunning) {
      _stopwatch!.stop();
    } else {
      _stopwatch!.start();
    }
    setState(() {}); // re-render the page
  }

  String formatTime(int milliseconds) {
    var secs = milliseconds ~/ 1000;
    var hours = (secs ~/ 3600).toString().padLeft(2, '0');
    var minutes = ((secs % 3600) ~/ 60).toString().padLeft(2, '0');
    var seconds = (secs % 60).toString().padLeft(2, '0');
    return "$hours:$minutes:$seconds";
  }

  Timer? timer;

  @override
  Widget build(BuildContext context) {
    if (_connectionState == 'CONNECTED') {
      _stopwatch!.start();
      timer =
          Timer.periodic(Duration(seconds: 1), (Timer t) => setState(() {}));
    } else {
      _stopwatch!.reset();
      _stopwatch!.stop();
    }

    return InkWell(
      onTap: () {
        if (_connectionState == 'CONNECTED') {
          Vpns().disconnect();
          // widget.vpns.disconnect();
        }
      },
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(text: '', style: connectedStyle, children: [
          TextSpan(text: _connectionState, style: connectedGreenStyle),
          _connectionState == 'CONNECTED'
              ? TextSpan(
                  text: formatTime(_stopwatch!.elapsedMilliseconds),
                  style: connectedSubtitle)
              : TextSpan(),
        ]),
      ),
    );
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }
}
