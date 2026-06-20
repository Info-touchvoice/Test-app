import 'package:google_sign_in/google_sign_in.dart';

/// Central place to create Google Sign-In instances.
class GoogleSignInFactory {
  static const String _serverClientId =
      '1092328407075-m93b104pldkih38vetgehabpmn2rcebp.apps.googleusercontent.com';

  static GoogleSignIn create() {
    return GoogleSignIn(
      scopes: const ['email'],
      serverClientId: _serverClientId,
    );
  }
}

