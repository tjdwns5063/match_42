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

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyD4XyYz1ojDVdJ8USltUJ8e-BwVDESrY5o',
    appId: '1:782490906793:web:d79244767946cdb41d39b8',
    messagingSenderId: '782490906793',
    projectId: 'match-42',
    authDomain: 'match-42.firebaseapp.com',
    storageBucket: 'match-42.appspot.com',
    measurementId: 'G-C70C34B8HM',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyA2A9uFc0umqTu5SL-VksjXqI3T4zZd9R4',
    appId: '1:782490906793:android:80838610203939961d39b8',
    messagingSenderId: '782490906793',
    projectId: 'match-42',
    storageBucket: 'match-42.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCqs226IA41Ts8qtdvVYI_vwPxbXIsKG5Q',
    appId: '1:782490906793:ios:950a02f8731e75971d39b8',
    messagingSenderId: '782490906793',
    projectId: 'match-42',
    storageBucket: 'match-42.appspot.com',
    iosClientId: '782490906793-eghhjl97qd3udn14cg4v9cou4m2ahds9.apps.googleusercontent.com',
    iosBundleId: 'com.match42.match42',
  );
}
