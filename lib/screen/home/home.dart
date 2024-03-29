import 'dart:async';
import 'dart:io';

// import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:securevpn/constants/stringConst.dart';
import 'package:securevpn/modal/vpn.dart';

import '../../constants/colorsConst.dart';
import '../../constants/textStyleConst.dart';
import '../../widgets/circularButton.dart';
import '../../widgets/connectionText.dart';
import '../../widgets/customClipper/customClipper.dart';

const int maxFailedLoadAttempts = 3;
class Home extends StatefulWidget {
  static String routeName = '/home';
  Home({Key? key}) : super(key: key);
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

Timer? timer;

class _MyHomePageState extends State<Home> {
  static final AdRequest request = AdRequest(
    keywords: <String>['foo', 'bar'],
    contentUrl: 'http://foo.com/bar.html',
    nonPersonalizedAds: true,
  );
  bool loading = false;
  List<Vpn> _vpns = [];
  Vpn? highestSpeed;
  Vpn? dropdownValue;
  bool init = true;
  RewardedAd? _rewardedAd;
  int _numRewardedLoadAttempts = 0;

  InterstitialAd? _interstitialAd;
  int _numInterstitialLoadAttempts = 0;
  bool isShowInterstitial = false;

  @override
  void initState() {
    super.initState();
    _createInterstitialAd();
    _createRewardedAd();
  }
  @override
  void didChangeDependencies() {
    if (init) {
      _vpns = Provider.of<Vpns>(context, listen: false).vpns;
      highestSpeed = Provider.of<Vpns>(context).getHighSpeed();
    }
    init = false;
    super.didChangeDependencies();
  }

  void _showRewardedAd() {
    if (_rewardedAd == null) {
      print('Warning: attempt to show rewarded before loaded.');
      return;
    }
    _rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (RewardedAd ad) =>
          print('ad onAdShowedFullScreenContent.'),
      onAdDismissedFullScreenContent: (RewardedAd ad) {
        print('$ad onAdDismissedFullScreenContent.');
        ad.dispose();
        _createRewardedAd();
      },
      onAdFailedToShowFullScreenContent: (RewardedAd ad, AdError error) {
        print('$ad onAdFailedToShowFullScreenContent: $error');
        ad.dispose();
        _createRewardedAd();
      },
    );

    _rewardedAd!.setImmersiveMode(true);
    _rewardedAd!.show(
        onUserEarnedReward: (AdWithoutView ad, RewardItem reward) {
          print('$ad with reward $RewardItem(${reward.amount}, ${reward.type})');

        });
    _rewardedAd = null;
  }

  void _createRewardedAd() {
    RewardedAd.load(
        adUnitId: Platform.isAndroid
            ? StringConst.ADMOB_APP_REWARD_ANDROID
            : StringConst.ADMOB_APP_REWARD_IOS,
        request: request,
        rewardedAdLoadCallback: RewardedAdLoadCallback(
          onAdLoaded: (RewardedAd ad) {
            print('$ad loaded.');
            _rewardedAd = ad;
            _numRewardedLoadAttempts = 0;
          },
          onAdFailedToLoad: (LoadAdError error) {
            print('RewardedAd failed to load: $error');
            _rewardedAd = null;
            _numRewardedLoadAttempts += 1;
            if (_numRewardedLoadAttempts < maxFailedLoadAttempts) {
              _createRewardedAd();
            }
          },
        ));
  }

  void _showInterstitialAd() {
    if (_interstitialAd == null) {
      print('Warning: attempt to show interstitial before loaded.');
      return;
    }
    _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (InterstitialAd ad) =>
          print('ad onAdShowedFullScreenContent.'),
      onAdDismissedFullScreenContent: (InterstitialAd ad) {
        print('$ad onAdDismissedFullScreenContent.');
        ad.dispose();
        _createInterstitialAd();
      },
      onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
        print('$ad onAdFailedToShowFullScreenContent: $error');
        ad.dispose();
        _createInterstitialAd();
      },
    );
    _interstitialAd!.show();
    _interstitialAd = null;
  }

  void _createInterstitialAd() {
    InterstitialAd.load(
        adUnitId: Platform.isAndroid
            ? StringConst.ADMOB_APP_INTERSTITIAL_Android
            : StringConst.ADMOB_APP_INTERSTITIAL_IOS,
        request: request,
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (InterstitialAd ad) {
            print('$ad loaded');
            _interstitialAd = ad;
            _numInterstitialLoadAttempts = 0;
            _interstitialAd!.setImmersiveMode(true);
          },
          onAdFailedToLoad: (LoadAdError error) {
            print('InterstitialAd failed to load: $error.');
            _numInterstitialLoadAttempts += 1;
            _interstitialAd = null;
            if (_numInterstitialLoadAttempts < maxFailedLoadAttempts) {
              _createInterstitialAd();
            }
          },
        ));
  }


  void onSelect(Vpn vpn) {
    Provider.of<Vpns>(context, listen: false).connect(vpn);
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    Future.delayed(Duration(milliseconds: 3000),(){
      if(!isShowInterstitial){
        isShowInterstitial= true;
        _showInterstitialAd();
      }
    });
    return Scaffold(
        backgroundColor: bgColor,
        body: ListView(
          children: <Widget>[
            Stack(
              alignment: Alignment.topCenter,
              clipBehavior: Clip.none,
              children: <Widget>[
                upperCurvedContainer(context),
                CircularButton(
                  width: screenWidth,
                ),
              ],
            ),
            SizedBox(height: screenWidth * 0.35),
            Align(
              alignment: Alignment.center,
              child: ConnectionText(),
            ),
            SizedBox(height: 10),
            randomLocationCard(Colors.transparent, 'Random Location'),
            SizedBox(height: 20),
            locationCard(
              'Select Location',
              Color.fromARGB(255, 67, 78, 120),
            ),
            Container(
              height: 50,
            )
          ],
        ));
  }

  Widget locationCard(title, cardBgColor) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(title, style: locationTitleStyle),
          SizedBox(height: 14.0),
          Container(
            height: 50,
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: cardBgColor,
              borderRadius: BorderRadius.circular(16),
            ),
            child: DropdownMenuItem(
              child: _dropDownItem(),
            ),
          )
        ],
      ),
    );
  }

  Widget _dropDownItem() {
    return Theme(
      data: ThemeData(canvasColor: bgColor),
      child: DropdownButton<Vpn>(
        hint: Text(
          'Select Location',
          style: locationTitleStyle,
        ),
        value: dropdownValue,
        icon: Icon(
          Icons.arrow_downward,
          color: Colors.white,
        ),
        iconSize: 24,
        elevation: 16,
        isExpanded: true,
        style: TextStyle(
          color: Colors.white,
          fontSize: 14.0,
          fontWeight: FontWeight.w600,
        ),
        underline: Container(
          height: 0,
        ),
        onChanged: (Vpn? newValue) {
          _showRewardedAd();
          onSelect(newValue!);
          setState(() {
            dropdownValue = newValue;
          });
        },
        items: _vpns.map<DropdownMenuItem<Vpn>>((Vpn value) {
          return DropdownMenuItem<Vpn>(
            value: value,
            child: Row(
              children: [
                SizedBox(
                  width: 20,
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: CircleAvatar(
                      backgroundColor: Colors.transparent,
                      radius: 15,
                      backgroundImage: AssetImage(
                          'assests/country/${value.countryCode.toLowerCase()}.png'),
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Text(
                    value.name + " - " + value.country,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget randomLocationCard(Color cardBgColor, String title) {
    return Container(
        margin: EdgeInsets.symmetric(vertical: 8, horizontal: 32),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(title, style: locationTitleStyle),
              SizedBox(height: 14.0),
              InkWell(
                onTap: () {
                  _showRewardedAd();
                  onSelect(highestSpeed!);
                  setState(() {
                    dropdownValue = highestSpeed;
                  });
                },
                child: Card(
                  color: cardBgColor,
                  elevation: 10,
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                      color: cardBgColor,
                      border: Border.all(
                        color: Color(0XFF9BB1BD),
                        style: BorderStyle.solid,
                        width: 0.5,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                        child: Row(
                      children: [
                        SizedBox(
                          width: 20,
                        ),
                        Expanded(
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: CircleAvatar(
                              backgroundColor: Colors.transparent,
                              radius: 15,
                              child: Image.asset(
                                  'assests/country/${highestSpeed!.countryCode.toLowerCase()}.png'),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Text(
                            highestSpeed!.name + " - " + highestSpeed!.country,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    )),
                  ),
                ),
              )
            ]));
  }



  Widget upperCurvedContainer(BuildContext context) {
    return ClipPath(
      clipper: MyCustomClipper(),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        height: 250,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          gradient: curveGradient,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            _topRow(context),
            Text(StringConst.APPNAME.toUpperCase(),
                style: TextStyleConst.header1.copyWith(fontSize: 24)),
            _bottomRow(context),
            SizedBox(
              height: 10,
            )
          ],
        ),
      ),
    );
  }

  Widget _topRow(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          // height: 50,
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: <Widget>[
              SizedBox(width: 12),
              Text(
                'No.1',
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              )
            ],
          ),
        ),
        Container(
          height: 50,
          width: 50,
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: InkWell(
              onTap: () async {
                setState(() {
                  loading = true;
                });
                await Provider.of<Vpns>(context, listen: false).fetchVpns();
                setState(() {
                  loading = false;
                });
              },
              child: loading
                  ? CircularProgressIndicator()
                  : Icon(
                      Icons.cached,
                      size: 26,
                      color: Colors.white,
                    ),
            ),
          ),
        )
      ],
    );
  }
}

Widget _bottomRow(
  BuildContext context,
) {
  return Row(
      //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //   children: <Widget>[
      //     Text(
      //       'Upload\n${Provider.of<Vpns>(context).connectedVpn == null ? 0 : (Provider.of<Vpns>(context).connectedVpn.speed / 1048576).round()}  mb/s',
      //       style: txtSpeedStyle,
      //     ),
      //     Text(
      //       "Ping\n${Provider.of<Vpns>(context).connectedVpn == null ? '0' : Provider.of<Vpns>(context).connectedVpn.ping} ms",
      //       textAlign: TextAlign.center,
      //       style: txtSpeedStyle,
      //     ),
      //   ],
      );

}
