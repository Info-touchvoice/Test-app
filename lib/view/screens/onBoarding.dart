import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../services/google_sign_in_factory.dart';
import '../../data/app/constants.dart';
import '../../utils/constants/app_constants.dart';
import '../../utils/constants/typography.dart';
import '../../utils/theme/colors_constant.dart';
import '../../view_model/auth_controller.dart';
import '../widgets/base_scaffold.dart';
import '../widgets/custom_buttons.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({Key? key}) : super(key: key);

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen>
    with WidgetsBindingObserver {
  final GoogleSignIn _googleSignIn = GoogleSignInFactory.create();
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  late SharedPreferences preferences;
  AuthViewModel authViewModel = Get.put(AuthViewModel());

  @override
  void initState() {
    initSharedPref();
    super.initState();
  }

  initSharedPref() async {
    preferences = await SharedPreferences.getInstance();
    Constants.queryParseConfig(preferences);
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
        body: Stack(
      fit: StackFit.expand,
      children: [
        Positioned(
          top: 105.h,
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Image.asset(
                  AppImagePath.onBoardingImage,
                  width: MediaQuery.of(context).size.width * 0.9,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 47.h, horizontal: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const Spacer(),
              PrimaryButtonIcon(
                title: "Continue with Apple",
                onTap: () => authViewModel.signupWithApple(context),
                textColor: AppColors.kWhite,
                icon: AppImagePath.appleIcon,
                bgColor: AppColors.white.withOpacity(0.1),
                borderColor: AppColors.white.withOpacity(0.15),
              ),
              SizedBox(height: 12.h),
              PrimaryButtonIcon(
                title: "Continue with Google",
                onTap: () {
                  authViewModel.signUpWithGoogle(
                      _googleSignIn, firebaseAuth, context, preferences);
                },
                textColor: AppColors.kWhite,
                icon: AppImagePath.googleIcon,
                bgColor: AppColors.white.withOpacity(0.2),
                borderColor: Colors.transparent,
              ),
              SizedBox(
                height: 12.h,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "By proceeding to use StreamT, you agree to our",
                    style: sfProDisplayRegular.copyWith(
                        fontSize: 12, color: AppColors.textSecondaryColor),
                  ),
                  Text(
                    "terms of service and privacy policy.",
                    style: sfProDisplayRegular.copyWith(
                        fontSize: 12, color: AppColors.textPrimaryColor),
                  ),
                ],
              ),
            ],
          ),
        )
      ],
    ));
  }

  Widget guestLogin(BuildContext context) {
    AuthViewModel authViewModel = Get.put(AuthViewModel());
    return InkWell(
      onTap: () => authViewModel.guestSignIn(context),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            'Guest',
            style: sfProDisplayBold.copyWith(fontSize: 14),
          ),
          Icon(Icons.keyboard_double_arrow_right_outlined),
          SizedBox(width: 12.w)
        ],
      ),
    );
  }
}
