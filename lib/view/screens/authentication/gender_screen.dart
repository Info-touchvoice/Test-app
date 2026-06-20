import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:tiki/utils/constants/app_constants.dart';
import 'package:tiki/utils/constants/typography.dart';
import 'package:tiki/utils/theme/colors_constant.dart';
import 'package:tiki/view/widgets/base_scaffold.dart';

import '../../../utils/routes/app_routes.dart';
import '../../../view_model/userViewModel.dart';
import 'newUser.dart';
import '../../widgets/custom_buttons.dart';

class SelectGenderScreen extends StatefulWidget {
  SelectGenderScreen({Key? key}) : super(key: key);

  @override
  State<SelectGenderScreen> createState() => _SelectGenderScreenState();
}

class _SelectGenderScreenState extends State<SelectGenderScreen> {
  late final UserViewModel userViewModel;

  Gender selectedGender = Gender.male;

  @override
  void initState() {
    userViewModel = Get.find();
    String? gender = userViewModel.currentUser.getGender;
    if (gender != null && gender.toLowerCase() == 'female') {
      selectedGender = Gender.female;
    } else {
      selectedGender = Gender.male;
    }
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final ImageProvider avatarProvider = AssetImage(
      selectedGender == Gender.female
          ? AppImagePath.defaultFemaleAvatar
          : AppImagePath.defaultMaleAvatar,
    );

    return BaseScaffold(
        body: Padding(
            padding: EdgeInsets.only(top: 55.h, left: 21.w, right: 21.w),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: 64.r,
                        height: 64.r,
                        padding: EdgeInsets.all(6.r),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withOpacity(0.08),
                      ),
                        child: CircleAvatar(
                          backgroundColor: Colors.transparent,
                          backgroundImage: avatarProvider,
                        ),
                      ),
                      SizedBox(
                        height: ScreenUtil().setHeight(16.h),
                      ),
                      Text(
                        'Select Gender',
                        style: sfProDisplaySemiBold.copyWith(
                            color: AppColors.textPrimaryColor, fontSize: 24.sp),
                      ),
                      SizedBox(
                        height: ScreenUtil().setHeight(10.h),
                      ),
                      Text(
                        'Identify your personal info',
                        style: sfProDisplayRegular.copyWith(
                            color: AppColors.textSecondaryColor,
                            fontSize: 16.sp),
                      ),
                      SizedBox(
                        height: ScreenUtil().setHeight(32.h),
                      ),
                      Image.asset(AppImagePath.progressIndicator),
                      SizedBox(
                        height: ScreenUtil().setHeight(32.h),
                      ),
                      GenderSelector(
                        initial: selectedGender,
                        onChanged: (g) {
                          setState(() => selectedGender = g);
                        },
                      ),
                      SizedBox(
                        height: ScreenUtil().setHeight(32.h),
                      ),
                      PrimaryButton(
                          title: "Next",
                          onTap: () {
                            String gender = selectedGender == Gender.male
                                ? 'male'
                                : 'female';
                            userViewModel.updateGender(gender).then((value) {
                              // Next step after gender is Personal Detail (if missing).
                              if (userViewModel.currentUser.getFullName ==
                                      null ||
                                  userViewModel.currentUser.getBirthday ==
                                      null) {
                                Get.to(() => NewUser(
                                      currentUser: userViewModel.currentUser,
                                    ));
                              } else {
                                // If already has personal details, continue.
                                // (We keep this fallback to avoid blocking returning users.)
                              Get.toNamed(AppRoutes.languageScreen);
                              }
                            });
                          }),
                    ],
                  ),
                ],
              ),
            )));
  }
}

enum Gender { male, female }

class GenderSelector extends StatefulWidget {
  final Gender? initial;
  final ValueChanged<Gender> onChanged;
  final double width;
  final double height;
  final double radius;
  final double gap;

  const GenderSelector({
    this.initial,
    required this.onChanged,
    this.width = 164.0,
    this.height = 134.0,
    this.radius = 16.0,
    this.gap = 14.0,
  });

  @override
  State<GenderSelector> createState() => _GenderSelectorState();
}

class _GenderSelectorState extends State<GenderSelector> {
  late Gender? _selected = widget.initial;

  void _set(Gender g) {
    setState(() => _selected = g);
    widget.onChanged(g);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double gap = widget.gap.w;
        final double maxWidth = constraints.maxWidth;
        final double candidateWidth = (maxWidth - gap) / 2;
        final double cardWidth =
            candidateWidth < widget.width ? candidateWidth : widget.width;

    return Row(
          mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _GenderCard(
          label: 'Male',
          icon: AppImagePath.maleIcon,
          isSelected: _selected == Gender.male,
          onTap: () => _set(Gender.male),
              width: cardWidth,
          height: widget.height,
          radius: widget.radius,
        ),
            SizedBox(width: gap),
        _GenderCard(
          label: 'Female',
          icon: AppImagePath.femaleIcon,
          isSelected: _selected == Gender.female,
          onTap: () => _set(Gender.female),
              width: cardWidth,
          height: widget.height,
          radius: widget.radius,
        ),
      ],
        );
      },
    );
  }
}

class _GenderCard extends StatelessWidget {
  final String label;
  final String icon;
  final bool isSelected;
  final VoidCallback onTap;
  final double width;
  final double height;
  final double radius;

  const _GenderCard({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
    required this.width,
    required this.height,
    required this.radius,
  });

  // Colors from your design
  static const _white10 =
      Color(0x1AFFFFFF); // 10% white (background for unselected)
  static const _white06 = Color(0x99FFFFFF); // 60% white text for unselected

  @override
  Widget build(BuildContext context) {
    final decoration = BoxDecoration(
      color: isSelected ? null : _white10,
      border: isSelected ? Border.all(color: _white10, width: 1) : null,
      gradient: isSelected
          ? LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                const Color(0xFFEA773F).withOpacity(0.2), // 👈 20% opacity
                const Color(0xFFFFFFFF).withOpacity(0.02), // very subtle fade
              ],
              stops: const [0.21, 1.0],
            )
          : null,
      borderRadius: BorderRadius.circular(radius),
    );

    final iconColor = isSelected ? Colors.white : _white06;
    final textColor = isSelected ? Colors.white : _white06;

    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(radius),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(radius),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOut,
          width: width,
          height: height,
          decoration: decoration,
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(icon, color: iconColor),
              SizedBox(height: 24.h),
              Text(
                label,
                style: sfProDisplayMedium.copyWith(
                  color: textColor,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
