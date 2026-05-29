import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      throw UnsupportedError('Web is not supported yet.');
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        throw UnsupportedError('iOS is not supported yet.');
      case TargetPlatform.macOS:
        throw UnsupportedError('macOS is not supported yet.');
      case TargetPlatform.windows:
        throw UnsupportedError('Windows is not supported yet.');
      case TargetPlatform.linux:
        throw UnsupportedError('Linux is not supported yet.');
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCFyKmZyLfXOSlWBQqzwBGvoKIMAZ6ns94',
    appId: '1:392658630920:android:b84fb3f4146f21823a94bd',
    messagingSenderId: '392658630920',
    projectId: 'dermalyze-433f8',
    storageBucket: 'dermalyze-433f8.firebasestorage.app',
  );
}
