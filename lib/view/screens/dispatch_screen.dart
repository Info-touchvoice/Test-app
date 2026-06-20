import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:location/location.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tiki/data/app/setup.dart';
import 'package:tiki/parse/UserModel.dart';
import 'package:tiki/view/screens/dashboard_screen.dart';
import 'package:tiki/view/screens/splash_screen.dart';

import '../../services/push_service.dart';
import '../../view_model/userViewModel.dart';
import 'authentication/gender_screen.dart';
import 'location_screen.dart';
import 'onBoarding.dart';

// ignore_for_file: must_be_immutable
class DispatchScreen extends StatefulWidget {
  static String route = "/check";

  UserModel? currentUser;
  SharedPreferences? preferences;
  bool fromProfile;

  DispatchScreen(
      {Key? key,
      this.currentUser,
      required this.preferences,
      this.fromProfile = false})
      : super(key: key);

  @override
  _DispatchScreenState createState() => _DispatchScreenState();
}

class _DispatchScreenState extends State<DispatchScreen> {
  late UserViewModel userViewModel;

  @override
  void initState() {
    userViewModel = Get.put(UserViewModel(widget.currentUser!));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    userViewModel.currentUser = widget.currentUser!;

    if (widget.currentUser != null) {
      loginUserPurchase(widget.currentUser!.objectId!);

      // Onboarding order: Gender -> Personal Detail -> (next steps...)
      // If ANY of these are missing (or empty), start at Gender screen.
      final String? gender = widget.currentUser!.getGender;
      final String? fullName = widget.currentUser!.getFullName;
      final birthday = widget.currentUser!.getBirthday;

      final bool isGenderMissing = gender == null || gender.isEmpty;
      final bool isNameMissing = fullName == null || fullName.isEmpty;
      final bool isBirthdayMissing = birthday == null;

      if (isGenderMissing || isNameMissing || isBirthdayMissing) {
        return SelectGenderScreen();
      } else {
        PushService(
          currentUser: widget.currentUser,
          context: context,
          preferences: widget.preferences,
        ).initialise();

        return DashboardView();
      }
    } else {
      logoutUserPurchase();

      return OnBoardingScreen();
    }
  }

  loginUserPurchase(String userId) async {
    if (!Setup.isPurchasesEnabled) {
      return;
    }

    LogInResult result = await Purchases.logIn(userId);
    if (result.created) {
      print("purchase created");
    } else {
      print("purchase logged");
    }
  }

  Widget checkLocation() {
    Location location = Location();

    return Scaffold(
      body: FutureBuilder<PermissionStatus>(
          future: location.hasPermission(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              PermissionStatus permissionStatus =
                  snapshot.data as PermissionStatus;
              if (permissionStatus == PermissionStatus.granted ||
                  permissionStatus == PermissionStatus.grantedLimited) {
                return DashboardView();
              } else {
                return LocationScreen(
                  currentUser: widget.currentUser,
                );
              }
            } else if (snapshot.hasError) {
              return LocationScreen(currentUser: widget.currentUser);
              //return AddCityScreen(currentUser: widget.currentUser,);
            } else {
              return SplashScreen();
            }
          }),
    );
  }

  logoutUserPurchase() async {
    if (!Setup.isPurchasesEnabled) {
      return;
    }

    await Purchases.logOut().then((value) => print("purchase logout"));
  }
}
