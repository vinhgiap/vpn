import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:securevpn/modal/vpn.dart';
import 'package:securevpn/screen/home/home.dart';

import 'constants/colorsConst.dart';
import 'firebase_options.dart';
import 'screen/privacyPolicy/privacyPolicy.dart';
import 'screen/privacyPolicy/termsAndCondition.dart';
import 'screen/splashScreen/splashScreen.dart';
import 'screen/welcomeScree/welcomeScree.dart';

void main()  async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  MobileAds.instance.initialize();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // List<Vpn> vpn = [];
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => Vpns(),
        )
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'RB VPN',
        theme: ThemeData(
            primarySwatch: Colors.blue,
            visualDensity: VisualDensity.adaptivePlatformDensity,
            appBarTheme: AppBarTheme(
              color: ColorConst.backgroundColor,
            ),
            textTheme: TextTheme(
                bodySmall: TextStyle(
              color: Colors.white,
            ))),
        routes: {
          Home.routeName: (_) => Home(),
          WelcomeScreen.routeName: (_) => WelcomeScreen(),
          PrivacyPolicy.routeName: (_) => PrivacyPolicy(),
          LicenseAggrement.routeName: (_) => LicenseAggrement(),
        },
        home: SplashScreen(),
      ),
    );
  }
}
