// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
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
        return windows;
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
    apiKey: 'AIzaSyDszMYWe-Z2xaYWOKkm2rV6v8pVIVfQGKs',
    appId: '1:606295748362:web:c2131a17ba393cdc5214f3',
    messagingSenderId: '606295748362',
    projectId: 'quiz-app-b1918',
    authDomain: 'quiz-app-b1918.firebaseapp.com',
    storageBucket: 'quiz-app-b1918.firebasestorage.app',
    measurementId: 'G-MDRKTV63MD',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAUTsSn8cN-LdeKJY6zsyqPsqalVWG813I',
    appId: '1:606295748362:android:d423402e644bab4d5214f3',
    messagingSenderId: '606295748362',
    projectId: 'quiz-app-b1918',
    storageBucket: 'quiz-app-b1918.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBSu9iVUYo8bEshWbDTZhDLnhRd3Fgj2jo',
    appId: '1:606295748362:ios:40191af494a36d425214f3',
    messagingSenderId: '606295748362',
    projectId: 'quiz-app-b1918',
    storageBucket: 'quiz-app-b1918.firebasestorage.app',
    iosBundleId: 'com.example.quizAppFirebase',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBSu9iVUYo8bEshWbDTZhDLnhRd3Fgj2jo',
    appId: '1:606295748362:ios:40191af494a36d425214f3',
    messagingSenderId: '606295748362',
    projectId: 'quiz-app-b1918',
    storageBucket: 'quiz-app-b1918.firebasestorage.app',
    iosBundleId: 'com.example.quizAppFirebase',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyDszMYWe-Z2xaYWOKkm2rV6v8pVIVfQGKs',
    appId: '1:606295748362:web:65e03a33705622e55214f3',
    messagingSenderId: '606295748362',
    projectId: 'quiz-app-b1918',
    authDomain: 'quiz-app-b1918.firebaseapp.com',
    storageBucket: 'quiz-app-b1918.firebasestorage.app',
    measurementId: 'G-QKF8KD1NRP',
  );

}