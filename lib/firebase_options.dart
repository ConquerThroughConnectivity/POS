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
        return linux;
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyDjCB4BK6Cl6uf1D4Z3cTfnO5NRLvdnhA0',
    appId: '1:709775399232:web:5d47de226442b29f31c2a5',
    messagingSenderId: '709775399232',
    projectId: 'point-49005',
    authDomain: 'point-49005.firebaseapp.com',
    storageBucket: 'point-49005.firebasestorage.app',
    measurementId: 'G-CM0NMKLXGJ',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAjUEKFuo3YUvKgo9WuiLBUQvLxrniyolk',
    appId: '1:709775399232:android:70148981318b9f0031c2a5',
    messagingSenderId: '709775399232',
    projectId: 'point-49005',
    storageBucket: 'point-49005.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAjUEKFuo3YUvKgo9WuiLBUQvLxrniyolk',
    appId: '1:709775399232:ios:70148981318b9f0031c2a5',
    messagingSenderId: '709775399232',
    projectId: 'point-49005',
    storageBucket: 'point-49005.firebasestorage.app',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAjUEKFuo3YUvKgo9WuiLBUQvLxrniyolk',
    appId: '1:709775399232:macos:70148981318b9f0031c2a5',
    messagingSenderId: '709775399232',
    projectId: 'point-49005',
    storageBucket: 'point-49005.firebasestorage.app',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyAjUEKFuo3YUvKgo9WuiLBUQvLxrniyolk',
    appId: '1:709775399232:windows:70148981318b9f0031c2a5',
    messagingSenderId: '709775399232',
    projectId: 'point-49005',
    storageBucket: 'point-49005.firebasestorage.app',
  );

  static const FirebaseOptions linux = FirebaseOptions(
    apiKey: 'AIzaSyAjUEKFuo3YUvKgo9WuiLBUQvLxrniyolk',
    appId: '1:709775399232:linux:70148981318b9f0031c2a5',
    messagingSenderId: '709775399232',
    projectId: 'point-49005',
    storageBucket: 'point-49005.firebasestorage.app',
  );
}
