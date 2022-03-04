// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars
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
    // ignore: missing_enum_constant_in_switch
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
    }

    throw UnsupportedError(
      'DefaultFirebaseOptions are not supported for this platform.',
    );
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyBibDpHINx2OeRPxeo0OHGVdFOM_YR1uNA',
    appId: '1:833145739107:web:3ee57441572284bc146556',
    messagingSenderId: '833145739107',
    projectId: 'social-app-8331d',
    authDomain: 'social-app-8331d.firebaseapp.com',
    storageBucket: 'social-app-8331d.appspot.com',
    measurementId: 'G-T4WQJES1Q9',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCS1WgUCkwCeqTPPVa2eQToeO_LpIAElNc',
    appId: '1:833145739107:android:46ef4470ac650c0f146556',
    messagingSenderId: '833145739107',
    projectId: 'social-app-8331d',
    storageBucket: 'social-app-8331d.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyA4-zSmKX7ytvqQSPFmbzTl-5GzDAhRPws',
    appId: '1:833145739107:ios:35b1e3c885ddf881146556',
    messagingSenderId: '833145739107',
    projectId: 'social-app-8331d',
    storageBucket: 'social-app-8331d.appspot.com',
    iosClientId: '833145739107-kr8un7v17khurfdllf6umtas9bajsjn0.apps.googleusercontent.com',
    iosBundleId: 'com.example.socialapp',
  );
}