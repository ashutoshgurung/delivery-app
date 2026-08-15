
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;


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
    apiKey: 'AIzaSyATV9_Jh-KtpHTfNP2W00jDSugXFa5Bh_0',
    appId: '1:888354609930:web:dc437bc2cbeb911b0438f3',
    messagingSenderId: '888354609930',
    projectId: 'foodapp-207b7',
    authDomain: 'foodapp-207b7.firebaseapp.com',
    storageBucket: 'foodapp-207b7.firebasestorage.app',
    measurementId: 'G-8K5BSKSCT4',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAYQrrJWUmA7fLPOGsBdmACWhcXX3kEND8',
    appId: '1:888354609930:android:9fdd3b58aed33c740438f3',
    messagingSenderId: '888354609930',
    projectId: 'foodapp-207b7',
    storageBucket: 'foodapp-207b7.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyByZpqiGAkOzHRGDVmTGOZerX2IDZAiY58',
    appId: '1:888354609930:ios:53c5e935ef6583140438f3',
    messagingSenderId: '888354609930',
    projectId: 'foodapp-207b7',
    storageBucket: 'foodapp-207b7.firebasestorage.app',
    iosBundleId: 'com.example.foodOrderingApp',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyATV9_Jh-KtpHTfNP2W00jDSugXFa5Bh_0',
    appId: '1:888354609930:web:d3171587a3cf40760438f3',
    messagingSenderId: '888354609930',
    projectId: 'foodapp-207b7',
    authDomain: 'foodapp-207b7.firebaseapp.com',
    storageBucket: 'foodapp-207b7.firebasestorage.app',
    measurementId: 'G-J7RD2WYV18',
  );
}
