import 'package:google_sign_in/google_sign_in.dart';

/// Central place to create Google Sign-In instances.
class GoogleSignInFactory {
  static const String _serverClientId =
      '573933509196-3ib9q7fsu7df31ln6m63e6p6aesjaoh51.apps.googleusercontent.com';

  static GoogleSignIn create() {
    return GoogleSignIn(
      scopes: const ['email'],
      serverClientId: _serverClientId,
    );
  }
}

