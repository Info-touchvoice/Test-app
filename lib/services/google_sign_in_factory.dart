import 'package:google_sign_in/google_sign_in.dart';

/// Central place to configure Google Sign-In.
///
/// The serverClientId must match your Firebase project's **Web client ID**
/// (client_type: 3) so Android can reliably return an `idToken`.
class GoogleSignInFactory {
  // From `android/app/google-services.json` -> oauth_client (client_type: 3)
  // Must match the Firebase project in google-services.json (belstream-daa04).
  static const String serverClientId =
      '1092328407075-m93b104pldkih38vetgehabpmn2rcebp.apps.googleusercontent.com';

  static GoogleSignIn create() {
    return GoogleSignIn(
      scopes: const ['email', 'profile'],
      serverClientId: serverClientId,
    );
  }
}

