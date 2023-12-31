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
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
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

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyA0xe2c3ISSCd8leGNAmSg43YYlqjOFDWI',
    appId: '1:477481353990:web:4121515a75892de3645487',
    messagingSenderId: '477481353990',
    projectId: 'iot-ecg-c24ad',
    authDomain: 'iot-ecg-c24ad.firebaseapp.com',
    databaseURL: 'https://iot-ecg-c24ad-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'iot-ecg-c24ad.appspot.com',
    measurementId: 'G-6SPN17C5LC',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAu4n5dFwy4glZnAzdX_nkyfocwZ-EExgE',
    appId: '1:477481353990:android:864ca8deee2c5298645487',
    messagingSenderId: '477481353990',
    projectId: 'iot-ecg-c24ad',
    databaseURL: 'https://iot-ecg-c24ad-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'iot-ecg-c24ad.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDFW03dOP3IKW2Ay4zAWIjNJEuZamIdOSw',
    appId: '1:477481353990:ios:b8352dfde97cbb08645487',
    messagingSenderId: '477481353990',
    projectId: 'iot-ecg-c24ad',
    databaseURL: 'https://iot-ecg-c24ad-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'iot-ecg-c24ad.appspot.com',
    iosClientId: '477481353990-t2gmnt3nn0fnihar4egdtths7uovbqkq.apps.googleusercontent.com',
    iosBundleId: 'com.example.flutterTestApplication1',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDFW03dOP3IKW2Ay4zAWIjNJEuZamIdOSw',
    appId: '1:477481353990:ios:b8352dfde97cbb08645487',
    messagingSenderId: '477481353990',
    projectId: 'iot-ecg-c24ad',
    databaseURL: 'https://iot-ecg-c24ad-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'iot-ecg-c24ad.appspot.com',
    iosClientId: '477481353990-t2gmnt3nn0fnihar4egdtths7uovbqkq.apps.googleusercontent.com',
    iosBundleId: 'com.example.flutterTestApplication1',
  );
}
