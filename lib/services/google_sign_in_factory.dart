import 'package:google_sign_in/google_sign_in.dart';

/// Central place to create Google Sign-In instances.
class GoogleSignInFactory {
  static GoogleSignIn create() {
    return GoogleSignIn(
      scopes: const ['email'],
    );
  }
}

