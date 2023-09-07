// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web - '
        'you can reconfigure this by running the FlutterFire CLI again.',
      );
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDmqLi0jcgfCNlJpsdPtKS-PWDcfDRwvF8',
    appId: '1:1055474275695:android:0839910844473daed4c49a',
    messagingSenderId: '1055474275695',
    projectId: 'smslab-6f96f',
    databaseURL: 'https://smslab-6f96f-default-rtdb.firebaseio.com',
    storageBucket: 'smslab-6f96f.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyC2A_jV0Y8rFx9-OtFGPxv9LACoDXZG9LA',
    appId: '1:1055474275695:ios:5b18e833b1f911e4d4c49a',
    messagingSenderId: '1055474275695',
    projectId: 'smslab-6f96f',
    databaseURL: 'https://smslab-6f96f-default-rtdb.firebaseio.com',
    storageBucket: 'smslab-6f96f.appspot.com',
    iosClientId: '1055474275695-u8uf9b9lsqh18a79gfhf55nt9399ti8a.apps.googleusercontent.com',
    iosBundleId: 'com.phariddot.securevpn',
  );
}
