import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:parse_server_sdk/parse_server_sdk.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/app/config.dart';
import '../data/app/constants.dart';
import '../data/app/navigation_service.dart';
import '../helpers/quick_help.dart';

import '../parse/InvitedUsersModel.dart';
import '../parse/UserModel.dart';
import '../utils/shared_manager.dart';

class DynamicLinkService {

  Uri _buildDeepLinkUri({required String id, required bool reels}) {
    final String suffix = reels ? Config.reelsSuffix : Config.postSuffix;

    // Prefer a non-Firebase domain for the deep-link target (the "link" parameter).
    // Firebase Dynamic Links will redirect to this URL after resolving the short/long dynamic link.
    //
    // NOTE: Config.appOrCompanyUrl should be a Tiki-controlled domain.
    final Uri base =
        Uri.tryParse(Config.appOrCompanyUrl) ?? Uri.parse("https://tiki.page.link");

    return base.replace(
      path: "/$suffix",
      queryParameters: <String, String>{'id': id},
    );
  }

  Future<Uri?> createDynamicLink(String? id, {bool reels = false}) async {
    try {
      if (id == null || id.isEmpty) {
        print("DynamicLinkService: ID is null or empty");
        return null;
      }

      final Uri deepLinkUri = _buildDeepLinkUri(id: id, reels: reels);
      print("DynamicLinkService: Creating dynamic link for: $deepLinkUri");

      final DynamicLinkParameters parameters = DynamicLinkParameters(
        // The Dynamic Link URI domain. You can view created URIs on your Firebase console
        uriPrefix: Config.uriPrefix,
        // The deep Link passed to your application which you can use to affect change
        link: deepLinkUri,
        // Android application details needed for opening correct app on device/Play Store
        androidParameters: AndroidParameters(
          packageName: Constants.appPackageName(),
          minimumVersion: 1,
        ),
        // iOS application details needed for opening correct app on device/App Store
        iosParameters: IOSParameters(
          bundleId: Constants.appPackageName(),
          appStoreId: Config.iosAppStoreId,
          minimumVersion: '1',
        ),
      );

      // 1) Try to generate a long dynamic link locally (usually more reliable than short).
      // 2) Try to shorten it; if that fails, fall back to long.
      // 3) If anything fails, fall back to the deep link (still allows share sheet to open).
      try {
        final Uri longLink = await FirebaseDynamicLinks.instance.buildLink(parameters);
        print("DynamicLinkService: Created long link: $longLink");

        try {
          final ShortDynamicLink shortDynamicLink =
              await FirebaseDynamicLinks.instance.buildShortLink(parameters);
          final Uri shortUri = shortDynamicLink.shortUrl;
          print("DynamicLinkService: Created short link: $shortUri");
          return shortUri;
        } catch (e) {
          print("DynamicLinkService: Failed to shorten link, using long link. Error: $e");
          return longLink;
        }
      } catch (e) {
        print("DynamicLinkService: Failed to build dynamic link, using deep link. Error: $e");
        return deepLinkUri;
      }

    } catch (e) {
      print("DynamicLinkService: Error creating dynamic link: $e");
      print("DynamicLinkService: Stack trace: ${StackTrace.current}");
      return null;
    }
  }

  Future<void> retrieveDynamicLink() async {

    try {
      final PendingDynamicLinkData? data = await FirebaseDynamicLinks.instance.getInitialLink();
      Uri? deepLink = data?.link;


      if (deepLink == null) {
        print("DeepLink not found");
        return;
      }

      // Expected deep link format:
      // - https://<your-domain>/reel?id=<postId>
      // - https://<your-domain>/post?id=<postId>
      final String? id = deepLink.queryParameters['id'];
      final bool isReel = deepLink.path.contains("/${Config.reelsSuffix}");
      final bool isPost = deepLink.path.contains("/${Config.postSuffix}");

      if (id != null && id.isNotEmpty && (isReel || isPost)) {
        print("DeepLink found (${isReel ? "reel" : "post"}): id=$id");
      } else {
        print("DeepLink found but unrecognized format: ${deepLink.toString()}");
      }

    } catch (e) {
      print("DeepLink invited by Error: $e");
    }
  }

  listenDynamicLink(BuildContext context) async{
    print("DeepLink listenDynamicLink");

    SharedPreferences preferences = await SharedPreferences.getInstance();

    FirebaseDynamicLinks.instance.onLink.listen((dynamicLinkData) async {
      print("DeepLink Listen invited by: ${dynamicLinkData.link.path}");

      final Uri link = dynamicLinkData.link;
      final String? id = link.queryParameters['id'];

      if (link.path.contains("/${Config.reelsSuffix}")) {
        if (id == null || id.isEmpty) {
          print("DeepLink: reel link missing id param: $link");
          return;
        }
        UserModel? currentUser = await ParseUser.currentUser();
        if(currentUser != null ){
          // QuickHelp.goToNavigatorScreen(NavigationService.navigatorKey.currentContext!, ReelsHomeScreen(currentUser: currentUser,deepLink:true,postId: id,));
        }
        else{
          var user =  UserModel("Guest", "123456", null);
          var response = await user.login();
          print(response.statusCode);
          print(response.error);
          print(response.result);
          if (response.success)
          {
            UserModel user = response.result;
            // QuickHelp.goToNavigatorScreen(NavigationService.navigatorKey.currentContext!, ReelsHomeScreen(currentUser: user,deepLink: true,postId: id,));
          }
      }
      }

      else if (link.path.contains("/${Config.postSuffix}")) {
        if (id == null || id.isEmpty) {
          print("DeepLink: post link missing id param: $link");
          return;
        }
        print('post id $id');
        UserModel? currentUser = await ParseUser.currentUser();
        if(currentUser != null ){
          // QuickHelp.goToNavigatorScreen(NavigationService.navigatorKey.currentContext!, Community(currentUser: currentUser,deepLink: true,postId: id,));
        }
        else{
          var user =  UserModel("Guest", "123456", null);
          var response = await user.login();
          print(response.statusCode);
          print(response.error);
          print(response.result);
          if (response.success)
          {
            UserModel user = response.result;
            // QuickHelp.goToNavigatorScreen(NavigationService.navigatorKey.currentContext!, Community(currentUser: user,deepLink: true,postId: id,));
          }
        }
      }

      // SharedManager().setInvitee(preferences, id);
      //
      // print("DeepLink ID invited by: $id");

    }).onError((error) {
      print("DeepLink listen by Error: $error");
      // Handle errors
    });
  }

  registerInviteBy(UserModel currentUser, String inviteeId, BuildContext context ) async {

    QuickHelp.showLoadingDialog(context);

    QueryBuilder<UserModel> queryFrom = QueryBuilder<UserModel>(UserModel.forQuery());

    queryFrom.whereEqualTo(UserModel.keyId, inviteeId);

    ParseResponse apiResponse = await queryFrom.query();

    if (apiResponse.success) {

      if (apiResponse.results != null) {

        InvitedUsersModel invitedUsersModel = InvitedUsersModel();

        invitedUsersModel.setAuthor = currentUser;
        invitedUsersModel.setAuthorId = currentUser.objectId!;

        invitedUsersModel.setInvitedBy = apiResponse.results!.first! as UserModel;
        invitedUsersModel.setInvitedById = inviteeId;

        invitedUsersModel.setValidUntil = DateTime.now().add(Duration(days: 730));
        ParseResponse response = await invitedUsersModel.save();

        if(response.success){

          currentUser.setInvitedByAnswer = true;
          currentUser.setInvitedByUser = inviteeId;

          ParseResponse user = await currentUser.save();
          if(user.success){
           currentUser = user.results!.first! as UserModel;
          }
        }
      }
    }
  }
}