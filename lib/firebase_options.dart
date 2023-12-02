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
    apiKey: 'AIzaSyC-CNpC-HsABO7nPRv9wXQZvv-w6_7Xpkk',
    appId: '1:1051140534821:web:9e515b8f77e49dd0d145cc',
    messagingSenderId: '1051140534821',
    projectId: 'babysteps-c362f',
    authDomain: 'babysteps-c362f.firebaseapp.com',
    storageBucket: 'babysteps-c362f.appspot.com',
    measurementId: 'G-RG235E7NNG',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyClX2CGv4RDuN_8MiYPwzJaC_a_b6wOOps',
    appId: '1:1051140534821:android:689d1271df53f799d145cc',
    messagingSenderId: '1051140534821',
    projectId: 'babysteps-c362f',
    storageBucket: 'babysteps-c362f.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAtQoq-djcwQEqeL32yTLveauV4p0aExrQ',
    appId: '1:1051140534821:ios:e6c851a22926867bd145cc',
    messagingSenderId: '1051140534821',
    projectId: 'babysteps-c362f',
    storageBucket: 'babysteps-c362f.appspot.com',
    iosBundleId: 'com.example.babysteps',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAtQoq-djcwQEqeL32yTLveauV4p0aExrQ',
    appId: '1:1051140534821:ios:a59b8b8cfd365676d145cc',
    messagingSenderId: '1051140534821',
    projectId: 'babysteps-c362f',
    storageBucket: 'babysteps-c362f.appspot.com',
    iosBundleId: 'com.example.babysteps.RunnerTests',
  );
}
