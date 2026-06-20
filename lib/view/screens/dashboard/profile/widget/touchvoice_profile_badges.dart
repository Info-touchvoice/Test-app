import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../helpers/quick_actions.dart';
import '../../../../../helpers/quick_help.dart';
import '../../../../../parse/UserModel.dart';
import '../touchvoice_profile_constants.dart';

class TouchVoiceProfileBadges extends StatelessWidget {
  const TouchVoiceProfileBadges({Key? key, required this.user}) : super(key: key);

  final UserModel? user;

  static bool isNewUser(UserModel? user) {
    final createdAt = user?.createdAt;
    if (createdAt == null) return false;
    return DateTime.now().difference(createdAt).inHours < 24;
  }

  int? _age(UserModel? user) {
    if (user?.getAge != null && user!.getAge! > 0) return user.getAge;
    final birthday = user?.getBirthday;
    if (birthday != null) return QuickHelp.getAgeFromDate(birthday);
    return null;
  }

  String _genderSymbol(String? gender) {
    switch (gender?.toLowerCase()) {
      case 'female':
        return '♀';
      case 'male':
        return '♂';
      default:
        return '•';
    }
  }

  @override
  Widget build(BuildContext context) {
    final badges = <Widget>[];

    if (isNewUser(user)) {
      badges.add(_pill(
        label: 'New',
        color: TouchVoiceProfileColors.newBadgeBlue,
        icon: Icons.auto_awesome,
      ));
    }

    final age = _age(user);
    if (age != null && user?.getHideMyBirthday != true) {
      badges.add(_pill(
        label: '$age',
        color: TouchVoiceProfileColors.ageBadgeBlue,
        prefix: _genderSymbol(user?.getGender),
      ));
    }

    if (user?.getHideMyLocation != true &&
        (user?.getCountry?.isNotEmpty ?? false)) {
      badges.add(
        Container(
          height: 24.h,
          width: 34.w,
          decoration: BoxDecoration(
            color: const Color(0xFFE53935),
            borderRadius: BorderRadius.circular(20.r),
          ),
          alignment: Alignment.center,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20.r),
            child: SvgPicture.asset(
              QuickActions.getCountryFlag(user),
              width: 22.w,
              height: 14.h,
              fit: BoxFit.cover,
            ),
          ),
        ),
      );
    }

    badges.add(_pill(
      label: '${user?.getCoins ?? 0}',
      color: TouchVoiceProfileColors.diamondBadge,
      icon: Icons.diamond_outlined,
    ));
    badges.add(_pill(
      label: '${user?.getBeans ?? 0}',
      color: TouchVoiceProfileColors.heartBadge,
      icon: Icons.favorite,
    ));
    badges.add(_pill(
      label: '0',
      color: TouchVoiceProfileColors.starBadge,
      icon: Icons.star_rounded,
    ));

    return Wrap(
      spacing: 6.w,
      runSpacing: 6.h,
      children: badges,
    );
  }

  Widget _pill({
    required String label,
    required Color color,
    String? prefix,
    IconData? icon,
  }) {
    return Container(
      height: 24.h,
      padding: EdgeInsets.symmetric(horizontal: 8.w),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 11.sp, color: Colors.white),
            SizedBox(width: 3.w),
          ],
          if (prefix != null) ...[
            Text(
              prefix,
              style: TextStyle(
                fontSize: 11.sp,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
            SizedBox(width: 2.w),
          ],
          Text(
            label,
            style: TextStyle(
              fontSize: 11.sp,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
