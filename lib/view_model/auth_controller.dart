import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart' hide Trans;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/app/setup.dart';
import '../helpers/quick_help.dart';
import '../parse/UserModel.dart';
import '../utils/datoo_exeption.dart';
import '../view/screens/authentication/social_login.dart';
import '../services/google_sign_in_diagnostics.dart';

class AuthViewModel extends GetxController {
  Future<GoogleSignInAccount?> _signInWithDiagnostics(
      GoogleSignIn googleSignIn) async {
    try {
      return await googleSignIn.signIn();
    } catch (error, stackTrace) {
      GoogleSignInDiagnostics.logSignInException(error, stackTrace);
      rethrow;
    }
  }

  Future<User?> signUpWithGoogle(
      GoogleSignIn _googleSignIn,
      FirebaseAuth firebaseAuth,
      BuildContext context,
      SharedPreferences preferences) async {
    try {
      // await _googleSignIn.signOut();

      final GoogleSignInAccount? googleSignInAccount =
          await _signInWithDiagnostics(_googleSignIn);
      
      // Check if user cancelled the sign-in
      if (googleSignInAccount == null) {
        // User cancelled, don't show error
        return null;
      }

      QuickHelp.showLoadingDialog(context);
      
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;

      // Debug logging
      print('Google Sign-In Debug (signUp):');
      print('  accessToken: ${googleSignInAuthentication.accessToken != null ? "Present" : "NULL"}');
      print('  idToken: ${googleSignInAuthentication.idToken != null ? "Present" : "NULL"}');
      print('  account ID: ${googleSignInAccount.id}');
      print('  account email: ${googleSignInAccount.email}');

      // Firebase and Parse both need the Google tokens produced by the native
      // Android configuration generated from google-services.json.
      if (googleSignInAuthentication.accessToken == null ||
          googleSignInAuthentication.idToken == null) {
        QuickHelp.hideLoadingDialog(context);
        QuickHelp.showAppNotificationAdvanced(
            context: context,
            title: "auth.gg_login_error".tr(),
            message: "Missing Google token(s). Please try signing in again.");
        await _googleSignIn.signOut();
        return null;
      }

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken!,
        idToken: googleSignInAuthentication.idToken!,
      );

      final UserCredential userCredential =
          await firebaseAuth.signInWithCredential(credential);
      final User? user = userCredential.user;

      if (user != null) {
        final ParseResponse response = await ParseUser.loginWith(
            'google',
            google(
                googleSignInAuthentication.accessToken!,
                googleSignInAccount.id,
                googleSignInAuthentication.idToken!));

        if (response.success) {
          UserModel? user = await ParseUser.currentUser();
          if (user != null) {
            if (user.getUid == null) {
              getGoogleUserDetails(user, googleSignInAccount,
                  googleSignInAuthentication.idToken!, context, preferences);
            } else {
              if (QuickHelp.isAccountDisabled(user) == false)
                SocialLogin.goHome(context, user, null,
                    isUserNameIncluded: true);
              else {
                QuickHelp.hideLoadingDialog(context);
                await _googleSignIn.signOut();
                user.logout().then((value) {
                  Get.back();
                  QuickHelp.showAppNotificationAdvanced(
                      title: 'This Account is deleted.', context: context);
                });
              }
            }
          } else {
            QuickHelp.hideLoadingDialog(context);
            QuickHelp.showAppNotificationAdvanced(
                context: context, title: "auth.gg_login_error".tr());
            await _googleSignIn.signOut();
          }
        } else {
          QuickHelp.hideLoadingDialog(context);
          
          // Debug logging
          print('Parse Login Error (signUp):');
          print('  Status Code: ${response.statusCode}');
          print('  Error: ${response.error}');
          print('  Error message: ${response.error?.message}');
          
          String errorMessage;
          if (response.statusCode == 402) {
            errorMessage = "Authentication failed. Please check your Parse Server configuration or try again later.";
          } else if (response.error != null && response.error!.message != null && response.error!.message!.isNotEmpty) {
            errorMessage = response.error!.message!;
          } else {
            errorMessage = "auth.gg_login_error".tr();
          }
          
          QuickHelp.showAppNotificationAdvanced(
              context: context, title: errorMessage);
          await _googleSignIn.signOut();
        }
      } else {
        QuickHelp.hideLoadingDialog(context);
        await _googleSignIn.signOut();
      }
      return user;
    } catch (error) {
      QuickHelp.hideLoadingDialog(context);
      
      if (error.toString().contains('sign_in_canceled') || 
          error.toString().contains('SIGN_IN_CANCELLED') ||
          error == GoogleSignIn.kSignInCanceledError) {
        // User cancelled - don't show error message
        return null;
      } else if (error.toString().contains('network_error') ||
          error == GoogleSignIn.kNetworkError) {
        QuickHelp.showAppNotificationAdvanced(
            context: context, title: "not_connected".tr());
      } else {
        print('Google Sign-In Error: $error');
        QuickHelp.showAppNotificationAdvanced(
            context: context, 
            title: "Google Sign-In failed",
            message: GoogleSignInDiagnostics.snackbarMessage(error),
            messageMaxLines: null,
            notificationHeight: 220);
      }

      await _googleSignIn.signOut();
      return null;
    }
  }

  Future<User?> signInWithGoogle(
      GoogleSignIn _googleSignIn,
      FirebaseAuth firebaseAuth,
      BuildContext context,
      SharedPreferences preferences) async {
    try {
      await _googleSignIn.signOut();
      
      final GoogleSignInAccount? googleSignInAccount =
          await _signInWithDiagnostics(_googleSignIn);
      
      // Check if user cancelled the sign-in
      if (googleSignInAccount == null) {
        // User cancelled, don't show error
        return null;
      }

      QuickHelp.showLoadingDialog(context);
      
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;

      // Debug logging
      print('Google Sign-In Debug:');
      print('  accessToken: ${googleSignInAuthentication.accessToken != null ? "Present" : "NULL"}');
      print('  idToken: ${googleSignInAuthentication.idToken != null ? "Present" : "NULL"}');
      print('  account ID: ${googleSignInAccount.id}');
      print('  account email: ${googleSignInAccount.email}');

      // Firebase and Parse both need the Google tokens produced by the native
      // Android configuration generated from google-services.json.
      if (googleSignInAuthentication.accessToken == null ||
          googleSignInAuthentication.idToken == null) {
        QuickHelp.hideLoadingDialog(context);
        QuickHelp.showAppNotificationAdvanced(
            context: context,
            title: "auth.gg_login_error".tr(),
            message: "Missing Google token(s). Please try signing in again.");
        await _googleSignIn.signOut();
        return null;
      }

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken!,
        idToken: googleSignInAuthentication.idToken!,
      );

      final UserCredential userCredential =
          await firebaseAuth.signInWithCredential(credential);
      final User? user = userCredential.user;

      if (user != null) {
        await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          'name': user.displayName,
          'email': user.email,
          'number': user.phoneNumber,
          'photoUrl': user.photoURL,
          'id': user.uid
        }, SetOptions(merge: true));

        final ParseResponse response = await ParseUser.loginWith(
            'google',
            google(
                googleSignInAuthentication.accessToken!,
                googleSignInAccount.id,
                googleSignInAuthentication.idToken!));

        if (response.success) {
          UserModel? user = await ParseUser.currentUser();
          if (user != null) {
            if (user.getUid == null) {
              QuickHelp.showAppNotificationAdvanced(
                  context: context,
                  title:
                      "No account with this user exists. Please proceed to create a new account.");
              await _googleSignIn.signOut();
              user.logout();
            } else {
              if (QuickHelp.isAccountDisabled(user) == false)
                SocialLogin.goHome(context, user, null,
                    isUserNameIncluded: true);
              else {
                await _googleSignIn.signOut();
                user.logout().then((value) {
                  Get.back();
                  QuickHelp.showAppNotificationAdvanced(
                      title: 'This Account is deleted.', context: context);
                });
              }
            }
          } else {
            QuickHelp.hideLoadingDialog(context);
            QuickHelp.showAppNotificationAdvanced(
                context: context, title: "auth.gg_login_error");
            await _googleSignIn.signOut();
          }
        } else {
          QuickHelp.hideLoadingDialog(context);
          
          // Debug logging
          print('Parse Login Error (signIn):');
          print('  Status Code: ${response.statusCode}');
          print('  Error: ${response.error}');
          print('  Error message: ${response.error?.message}');
          
          String errorMessage;
          if (response.statusCode == 402) {
            errorMessage = "Authentication failed. Please check your Parse Server configuration or try again later.";
          } else if (response.error != null && response.error!.message != null && response.error!.message!.isNotEmpty) {
            errorMessage = response.error!.message!;
          } else {
            errorMessage = "auth.gg_login_error".tr();
          }
          
          QuickHelp.showAppNotificationAdvanced(
              context: context, title: errorMessage);
          await _googleSignIn.signOut();
        }
      } else {
        QuickHelp.hideLoadingDialog(context);
        QuickHelp.showAppNotificationAdvanced(
            context: context, title: "auth.gg_login_error".tr());
        await _googleSignIn.signOut();
      }
      return user;
    } catch (error) {
      QuickHelp.hideLoadingDialog(context);
      
      print('Google Sign-In Error: $error');
      print('Error type: ${error.runtimeType}');
      
      if (error.toString().contains('sign_in_canceled') || 
          error.toString().contains('SIGN_IN_CANCELLED') ||
          error == GoogleSignIn.kSignInCanceledError) {
        // User cancelled - don't show error message
        return null;
      } else if (error.toString().contains('network_error') ||
          error == GoogleSignIn.kNetworkError) {
        QuickHelp.showAppNotificationAdvanced(
            context: context, title: "not_connected".tr());
      } else {
        // Check for specific error code 10 (DEVELOPER_ERROR)
        String errorMessage = "auth.gg_login_error".tr();
        if (error.toString().contains('ApiException: 10') || 
            error.toString().contains('DEVELOPER_ERROR')) {
          errorMessage = "Google Sign-In configuration error. Please check:\n"
              "1. SHA-1 fingerprint is added in Firebase Console\n"
              "2. Firebase Google provider is configured\n"
              "3. Package name matches: com.livestream.touchvoice";
        }
        QuickHelp.showAppNotificationAdvanced(
            context: context, 
            title: errorMessage,
            message: GoogleSignInDiagnostics.snackbarMessage(error),
            messageMaxLines: null,
            notificationHeight: 220);
      }

      await _googleSignIn.signOut();
      return null;
    }
  }

  void getGoogleUserDetails(
      UserModel user,
      GoogleSignInAccount googleUser,
      String idToken,
      BuildContext context,
      SharedPreferences preferences) async {
    Map<String, dynamic>? idMap = QuickHelp.getInfoFromToken(idToken);

    // Handle null values from ID token - use fallbacks from GoogleSignInAccount
    String firstName;
    String lastName;
    
    if (idMap != null && idMap["given_name"] != null) {
      firstName = idMap["given_name"] as String;
    } else {
      // Fallback: extract first name from display name
      String? displayName = googleUser.displayName;
      if (displayName != null && displayName.isNotEmpty) {
        List<String> nameParts = displayName.split(" ");
        firstName = nameParts.isNotEmpty ? nameParts.first : "User";
      } else {
        firstName = "User";
      }
    }
    
    if (idMap != null && idMap["family_name"] != null) {
      lastName = idMap["family_name"] as String;
    } else {
      // Fallback: extract last name from display name
      String? displayName = googleUser.displayName;
      if (displayName != null && displayName.isNotEmpty) {
        List<String> nameParts = displayName.split(" ");
        lastName = nameParts.length > 1 ? nameParts.sublist(1).join(" ") : "";
      } else {
        lastName = "";
      }
    }

    String username =
        lastName.replaceAll(" ", "") + firstName.replaceAll(" ", "");

    user.setFullName = googleUser.displayName ?? "$firstName $lastName".trim();
    user.setGoogleId = googleUser.id;
    user.setFirstName = firstName;
    user.setLastName = lastName;
    user.username = username.toLowerCase().trim() +
        QuickHelp.generateRandomNumber().toString();
    user.setEmail = googleUser.email;
    user.setEmailPublic = googleUser.email;
    //user.setGender = await getGender();
    user.setUid = QuickHelp.generateUId();
    user.setPopularity = 0;
    user.setUserRole = UserModel.roleUser;
    user.setPrefMinAge = Setup.minimumAgeToRegister;
    user.setPrefMaxAge = Setup.maximumAgeToRegister;
    user.setLocationTypeNearBy = true;
    user.addCredit = Setup.welcomeCredit;
    user.setBio = Setup.bio;
    user.setHasPassword = false;

    ParseACL acl = ParseACL();
    acl.setPublicReadAccess(allowed: true);
    user.setACL(acl);

    ParseResponse response = await user.save();

    if (response.success) {
      // Only download photo if photoUrl is available
      if (googleUser.photoUrl != null && googleUser.photoUrl!.isNotEmpty) {
      SocialLogin.getPhotoFromUrl(
          context, user, googleUser.photoUrl!, preferences);
      } else {
        QuickHelp.hideLoadingDialog(context);
        SocialLogin.goHome(context, user, preferences, isUserNameIncluded: true);
      }
    } else {
      QuickHelp.hideLoadingDialog(context);
      QuickHelp.showErrorResult(context, response.error!.code);
    }
  }

  signInWithApple(BuildContext context) {
    if (QuickHelp.getPlatform() == "IOS") {
    } else {
      QuickHelp.showAppNotificationAdvanced(
          title: "SignIn method not supported on device", context: context);
    }
  }

  signupWithApple(BuildContext context) {
    if (QuickHelp.getPlatform() == "IOS") {
    } else {
      QuickHelp.showAppNotificationAdvanced(
          title: "SignUp method not supported on device", context: context);
    }
  }

  void signUpWithUserName(BuildContext context, SharedPreferences preferences,
      String userName, String password) async {
    try {
      QuickHelp.showLoadingDialog(context);

      var user = UserModel(userName, password, null);

      ParseACL acl = ParseACL();
      acl.setPublicReadAccess(allowed: true);
      user.setACL(acl);

      var response = await user.signUp(allowWithoutEmail: true);

      if (response.success) {
        UserModel user = response.result;
        getUserDetails(user, context, preferences);
      } else {
        QuickHelp.hideLoadingDialog(context);
        QuickHelp.showAppNotificationAdvanced(
            title: response.error!.message, context: context);
      }
    } catch (e) {
      QuickHelp.hideLoadingDialog(context);

      QuickHelp.showAppNotificationAdvanced(
          title: e.toString(), context: context);
      print(e.toString());
    }
  }

  void signInWithUserName(BuildContext context, SharedPreferences preferences,
      String userName, String password) async {
    try {
      QuickHelp.showLoadingDialog(context);

      var user = UserModel(userName, password, null);

      var response = await user.login();

      if (response.success) {
        UserModel user = response.result;
        if (QuickHelp.isAccountDisabled(user) == false)
          SocialLogin.goHome(context, user, null, isUserNameIncluded: true);
        else {
          user.logout().then((value) {
            Get.back();
            QuickHelp.showAppNotificationAdvanced(
                title: 'This Account is deleted.', context: context);
          });
        }
      } else {
        QuickHelp.hideLoadingDialog(context);
        QuickHelp.showAppNotificationAdvanced(
            title: response.error!.message, context: context);
      }
    } catch (error) {
      QuickHelp.hideLoadingDialog(context);
      QuickHelp.showAppNotificationAdvanced(
          title: 'response.error!.message', context: context);
    }
  }

  void guestSignIn(
    BuildContext context,
  ) async {
    try {
      QuickHelp.showLoadingDialog(context);
      // String userName=getEmailUserName(email);

      var user = UserModel("smustafak", "123456", null);

      var response = await user.login();
      print(response.statusCode);
      print(response.error);
      print(response.result);
      if (response.success) {
        UserModel user = response.result;
        if (QuickHelp.isAccountDisabled(user) == false)
          SocialLogin.goHome(context, user, null, isUserNameIncluded: true);
        else {
          user.logout().then((value) {
            Get.back();
            QuickHelp.showAppNotificationAdvanced(
                title: 'This Account is deleted.', context: context);
          });
        }
      } else {
        QuickHelp.hideLoadingDialog(context);
        QuickHelp.showAppNotificationAdvanced(
            title: response.error!.message, context: context);
      }
    } catch (error) {
      QuickHelp.hideLoadingDialog(context);
      QuickHelp.showAppNotificationAdvanced(
          title: 'response.error!.message', context: context);
    }
  }

  void getUserDetails(
      UserModel user, BuildContext context, SharedPreferences preferences,
      {bool isUserNameIncluded = false}) async {
    user.setUid = QuickHelp.generateUId();
    user.setPopularity = 0;
    user.setUserRole = UserModel.roleUser;
    user.setPrefMinAge = Setup.minimumAgeToRegister;
    user.setPrefMaxAge = Setup.maximumAgeToRegister;
    user.setLocationTypeNearBy = true;
    user.addCredit = Setup.welcomeCredit;
    user.setBio = Setup.bio;
    user.setHasPassword = true;
    //user.setBirthday = QuickHelp.getDateFromString(_userData!['birthday'], QuickHelp.dateFormatFacebook);
    ParseResponse response = await user.save();

    if (response.success) {
      SocialLogin.goHome(context, user, preferences,
          isUserNameIncluded: isUserNameIncluded);
    } else {
      QuickHelp.hideLoadingDialog(context);
      QuickHelp.showErrorResult(context, response.error!.code);
    }
  }

  String getEmailUserName(String email) {
    List<String> parts = email.split('*');

    // Ensure that there is at least one part before the asterisk
    if (parts.length > 1) {
      return parts.first;
    } else {
      // If there is no asterisk, return the entire email
      return email;
    }
  }

  Future<void> forgetPassword(_emailOrAccountText, BuildContext context) async {
    QuickHelp.showLoadingDialog(context);

    if (!_emailOrAccountText.contains('@')) {
      QueryBuilder<UserModel> queryBuilder =
          QueryBuilder<UserModel>(UserModel.forQuery());
      queryBuilder.whereEqualTo(UserModel.keyUsername, _emailOrAccountText);
      ParseResponse apiResponse = await queryBuilder.query();

      if (apiResponse.success && apiResponse.results != null) {
        UserModel userModel = apiResponse.results!.first;
        _processLogin(userModel.getEmailPublic, context);
      } else {
        showError(apiResponse.error!.code, context);
      }
    } else {
      _processLogin(_emailOrAccountText, context);
    }
  }

  Future<void> _processLogin(String? email, BuildContext context) async {
    final user = ParseUser(null, null, email);

    var response = await user.requestPasswordReset();

    if (response.success) {
      showSuccess(context);
    } else {
      showError(response.error!.code, context);
    }
  }

  Future<void> showSuccess(BuildContext context) async {
    QuickHelp.hideLoadingDialog(context);

    QuickHelp.showAppNotificationAdvanced(
        context: context,
        title: "Email Sent",
        message: "Check your inbox for the password reset link.",
        isError: false);
  }

  void showError(int error, BuildContext context) {
    QuickHelp.hideLoadingDialog(context);

    if (error == DatooException.connectionFailed) {
      // Internet problem
      QuickHelp.showAppNotificationAdvanced(
          context: context,
          title: "error".tr(),
          message: "not_connected".tr(),
          isError: true);
    } /*else if(error == DatooException.accountBlocked){
      // Internet problem
      QuickHelp.showAlertError(context: context, title: "error".tr(), message: "auth.account_blocked".tr());
    }*/
    else {
      // Invalid credentials
      QuickHelp.showAppNotificationAdvanced(
          context: context,
          title: "error".tr(),
          message: "auth.invalid_credentials".tr(),
          isError: true);
    }
  }

  @override
  void onInit() {
    super.onInit();
  }
}
