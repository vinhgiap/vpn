import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:openvpn_flutter_update/openvpn_flutter.dart';
// import 'package:openvpn_flutter/openvpn_flutter.dart';
import 'package:securevpn/constants/stringConst.dart';

class Vpn with ChangeNotifier {
  final String id;
  final String name;
  final String country;
  final String countryCode;
  final String ovpn;
  final String status;
  final String password;
  final String username;

  Vpn({
    this.password = '',
    this.username = '',
    this.id = '',
    this.name = '',
    this.country = '',
    this.countryCode = '',
    this.ovpn = '',
    this.status = 'Not Connected',
  });
}

class Vpns with ChangeNotifier {
  int time = 0;
  String timeString = '00:00:00';
  List<Vpn>? _vpns;
  List<Vpn> get vpns => [..._vpns!];
  String _connectionState = 'Not Connected';
  String get connectionState => _connectionState;
  set connectionState(String connectionState) {
    _connectionState = connectionState;
    notifyListeners();
  }

  Vpn? _connectedVpn = Vpn(); // Assuming Vpn is a class or a data model
  Vpn get connectedVpn => _connectedVpn!;

  // Vpn? _connectedVpn = null;
  // Vpn get connectedVpn => _connectedVpn!;
  OpenVPN? engine;
  VpnStatus? status2;
  VPNStage? stage;
  bool _granted = false;

  set connectedVpn(Vpn vpn) {
    _connectedVpn = vpn;
    notifyListeners();
  }

  Vpn getHighSpeed() {
    // var _newVpn = _vpns;
    return _vpns![0];
  }

  Future<void> fetchVpns() async {
    List<Vpn> _newVpns = [];
    try {
      final request = await http.get(Uri.parse(StringConst.URl));
      var decodedResponse = jsonDecode(request.body);
      var rawVpns = decodedResponse['vpns'];
      print(rawVpns);
      for (var v in rawVpns) {
        List<int> res = base64.decode(base64.normalize(v['configScriptTCP']));
        var ovpn = utf8.decode(res);

        Vpn _vpn = Vpn(
            id: v['id'],
            name: v['name'],
            country: v['country'],
            countryCode: v['flagLogo'],
            username: v['username'],
            password: v['password'],
            ovpn: ovpn);
        _newVpns.add(_vpn);
      }
    } catch (err) {
      print(err);
    }

    _vpns = _newVpns;
    notifyListeners();
  }

  void connect(Vpn vpn) async {
    engine = OpenVPN(
      onVpnStatusChanged: (data) {
        status2 = data;
      },
      onVpnStageChanged: (data, raw) {
        stage = data;
      },
    );
    engine!.initialize(
        groupIdentifier: StringConst.groupIdentifier,
        providerBundleIdentifier: StringConst.providerBundleIdentifier,
        localizedDescription: StringConst.APPNAME);

    engine!.connect(vpn.ovpn, vpn.country,
        username: vpn.username, password: vpn.password, certIsRequired: true);
    // print(stage.toString());
    if (stage.toString() == null) {
      Timer(Duration(seconds: 1), () {
        if (stage.toString() == 'connected') {
          _connectedVpn = vpn;
          _connectionState = 'CONNECTED';
          notifyListeners();
        } else if (stage.toString() == 'connecting') {
          _connectedVpn = vpn;
          _connectionState = 'CONNECTING';
          notifyListeners();
        } else if (stage.toString() == 'authenticating') {
          _connectedVpn = vpn;
          _connectionState = 'RECONNECTING';
          notifyListeners();
        } else if (stage.toString() == 'disconnected') {
          _connectedVpn = vpn;
          _connectionState = 'DISCONNECTED';
          notifyListeners();
        } else if (stage.toString() == 'disconnecting') {
          _connectedVpn = vpn;
          _connectionState = 'disconnecting';
          notifyListeners();
        } else if (stage.toString() == 'denied') {
          _connectedVpn = vpn;
          _connectionState = 'denied';
          notifyListeners();
        }
      });
    } else {
      // _connectedVpn = vpn;
      // _connectionState = stage?.toString();
      // notifyListeners();
    }
  }

  void disconnect() {
    engine = OpenVPN(
      onVpnStatusChanged: (data) {
        status2 = data;
      },
      onVpnStageChanged: (data, raw) {
        stage = data;
      },
    );
    engine!.initialize(
        groupIdentifier: StringConst.groupIdentifier,
        providerBundleIdentifier: StringConst.providerBundleIdentifier,
        localizedDescription: StringConst.APPNAME);
    engine!.disconnect();
    // FlutterOpenvpn.stopVPN();
    time = 0;
    timeString = "00:00:00";

    _connectedVpn == null;
    _connectionState = 'Not Connected';
    notifyListeners();

    // FlutterOpenvpn.stopVPN();
    // time = 0;
    // timeString = "00:00:00";

    // _connectedVpn = null;
    // _connectionState = 'Not Connected';
    // notifyListeners();
  }
}
