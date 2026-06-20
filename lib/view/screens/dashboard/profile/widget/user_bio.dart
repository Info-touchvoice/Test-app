import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../parse/UserModel.dart';
import '../../../../../utils/Utils.dart';
import '../../../../../utils/constants/app_constants.dart';
import '../../../../../utils/theme/colors_constant.dart';

class UserBio extends StatelessWidget {
  final UserModel? userModel;
  const UserBio({Key? key, this.userModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if ((userModel?.getBio ?? '').isNotEmpty) ...[
          SizedBox(height: 24.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Text(
                    userModel?.getBio ?? "",
                    textAlign: TextAlign.center,
                    style: SafeGoogleFont(
                      'SFProDisplay',
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w400,
                      color: AppColors.hintText(context),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
        // Website intentionally hidden on public profile as requested.
      ],
    );
  }
}
