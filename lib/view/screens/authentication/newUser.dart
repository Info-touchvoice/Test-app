import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl_phone_field_v2/country_picker_dialog.dart';
import 'package:intl_phone_field_v2/intl_phone_field.dart';
import 'package:tiki/utils/constants/app_constants.dart';
import 'package:tiki/utils/constants/typography.dart';
import 'package:tiki/utils/permission/choose_photo_permission.dart';
import 'package:tiki/utils/theme/colors_constant.dart';
import 'package:tiki/view/widgets/base_scaffold.dart';
import 'package:tiki/view/widgets/validation_checker.dart';

import '../../../helpers/quick_help.dart';
import '../../../parse/UserModel.dart';
import '../../../utils/routes/app_routes.dart';
import '../../../view_model/userViewModel.dart';
import '../../widgets/app_text_field.dart';
import '../../widgets/custom_buttons.dart';
import '../../../data/components/DateTextFormatter.dart';

class NewUser extends StatefulWidget {
  final UserModel? currentUser;
  NewUser({Key? key, this.currentUser}) : super(key: key);

  @override
  State<NewUser> createState() => _NewUserState();
}

class _NewUserState extends State<NewUser> {
  late final UserViewModel userViewModel;

  TextEditingController name = TextEditingController();
  TextEditingController dateOfBirth = TextEditingController();
  TextEditingController phoneNumber = TextEditingController();
  String? countryCode;
  String? phoneNumberValue;

  final _formKey = GlobalKey<FormState>(); // Add form key
  RxBool isFormDirty = false.obs;

  late UserModel currentUser;
  String? userAvatar;
  String? userCover;

  TextStyle hintStyle = sfProDisplayMedium.copyWith(
      fontSize: 12.sp, color: Colors.white.withOpacity(0.3));
  
  // Paler hint style specifically for phone number placeholder
  TextStyle phoneHintStyle = sfProDisplayMedium.copyWith(
      fontSize: 12.sp, color: Colors.white.withOpacity(0.15));

  _getUser() async {
    if (currentUser.getFullName != null) {
      name.text = currentUser.getFullName!;
    }

    if (currentUser.getBirthday != null) {
      dateOfBirth.text =
          QuickHelp.getBirthdayFromDate(currentUser.getBirthday!);
    }

    if (currentUser.getPhoneNumber != null) {
      // IntlPhoneField will automatically parse phone numbers with country codes
      phoneNumber.text = currentUser.getPhoneNumber!;
    }

    setState(() {
      userAvatar =
          currentUser.getAvatar != null ? currentUser.getAvatar!.url! : "";
      userCover =
          currentUser.getCover != null ? currentUser.getCover!.url! : "";
    });
  }

  updateUserModel(UserViewModel controller) {
    if (currentUser.getAvatar != null) {
      currentUser = controller.currentUser;
      userAvatar = controller.currentUser.getAvatar!.url;
    }
  }

  @override
  void initState() {
    userViewModel = Get.put(UserViewModel(widget.currentUser!));
    currentUser = widget.currentUser!;
    _getUser();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      body: Padding(
        padding: EdgeInsets.only(top: 55.h, left: 21.w, right: 21.w),
        child: SingleChildScrollView(
          child: GetBuilder<UserViewModel>(
              init: userViewModel,
              builder: (controller) {
                updateUserModel(controller);
                return Column(
                  children: [
                    Obx(() {
                      return Form(
                        key: _formKey, // Assign form key to the form
                        autovalidateMode: isFormDirty.value
                            ? AutovalidateMode.onUserInteraction
                            : AutovalidateMode.disabled,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image.asset(AppImagePath.personalIcon),
                            SizedBox(
                              height: ScreenUtil().setHeight(16.h),
                            ),
                            Text(
                              'Personal Detail',
                              style: sfProDisplaySemiBold.copyWith(
                                  color: AppColors.textPrimaryColor,
                                  fontSize: 24.sp),
                            ),
                            SizedBox(
                              height: ScreenUtil().setHeight(10.h),
                            ),
                            Text(
                              'Tell us a little about yourself',
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
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CircleAvatar(
                                  radius: ScreenUtil().setWidth(35),
                                  backgroundImage:
                                      QuickHelp.getUserAvatarProvider(currentUser),
                                ),
                                SizedBox(
                                  width: ScreenUtil().setWidth(20.w),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Upload Image',
                                      style: sfProDisplaySemiBold.copyWith(
                                          color: AppColors.textPrimaryColor,
                                          fontSize: 16.sp),
                                    ),
                                    SizedBox(
                                      height: ScreenUtil().setHeight(4.h),
                                    ),
                                    Text(
                                      'Min 400x400px, PNG or JPEG',
                                      style: sfProDisplayRegular.copyWith(
                                          color: AppColors.textSecondaryColor,
                                          fontSize: 14.sp),
                                    ),
                                    SizedBox(
                                      height: ScreenUtil().setHeight(12.h),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        PermissionHandler.checkPermission(
                                            true, context);
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(8.r),
                                          border: Border.all(
                                            color: AppColors.strokeColor,
                                          ),
                                        ),
                                        padding: EdgeInsets.symmetric(
                                            horizontal:
                                                ScreenUtil().setWidth(6.w),
                                            vertical:
                                                ScreenUtil().setHeight(6.h)),
                                        child: Text(
                                          'Upload',
                                          style: sfProDisplaySemiBold.copyWith(
                                              color: AppColors.textPrimaryColor,
                                              fontSize: 13.5.sp),
                                        ),
                                      ),
                                    )
                                  ],
                                )
                              ],
                            ),
                            SizedBox(
                              height: ScreenUtil().setHeight(16.h),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                AppTextFormField(
                                  controller: name,
                                  enableHeadingText: true,
                                  headingText: 'Name',
                                  hintStyle: hintStyle,
                                  txtColor: AppColors.primaryColor,
                                  textInputAction: TextInputAction.next,
                                  autoValidateMode: AutovalidateMode.disabled,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter your name';
                                    }
                                    return null;
                                  },
                                  hintText: "Full name",
                                  isSuffixIcon: true,
                                  suffixIcon:
                                      Image.asset(AppImagePath.nameIcon),
                                ),
                                // SizedBox(
                                //   height: ScreenUtil().setHeight(16.h),
                                // ),
                                // Text(
                                //   '  Home Country',
                                //   style: formStyle,
                                // ),
                                // SizedBox(
                                //   height: ScreenUtil().setHeight(8),
                                // ),
                                // CountryPickerFormField(
                                //   validator: (value) {
                                //     if (value == null || value.isEmpty) {
                                //       return 'Select your country';
                                //     }
                                //     return null;
                                //   },
                                //   selectedCountry: selectedCountry,
                                //   onChanged: (newCountry) {
                                //     setState(() {
                                //       selectedCountry = newCountry;
                                //     });
                                //   },
                                // ),
                                SizedBox(
                                  height: ScreenUtil().setHeight(16.h),
                                ),
                                AppTextFormField(
                                    controller: dateOfBirth,
                                    keyboardType: TextInputType.number,
                                    inputFormatters: [
                                      UsDateFormatter(),
                                      LengthLimitingTextInputFormatter(10),
                                            ],
                                    readOnly: false,
                                      autoFocus: false,
                                      enableHeadingText: true,
                                      isSuffixIcon: true,
                                    suffixIcon: Padding(
                                      padding: EdgeInsets.all(12.r),
                                      child: Image.asset(
                                          AppImagePath.calendarIcon,
                                        ),
                                      ),
                                      headingText: 'Date of Birth',
                                      hintStyle: hintStyle,
                                      txtColor: AppColors.primaryColor,
                                      textInputAction: TextInputAction.next,
                                    autoValidateMode:
                                        AutovalidateMode.disabled,
                                      validator: (value) {
                                      return dateOfBirthValidator(value);
                                      },
                                    hintText:
                                        "MM/DD/YYYY"),
                                SizedBox(
                                  height: ScreenUtil().setHeight(16.h),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Phone Number',
                                      style: sfProDisplayMedium.copyWith(
                                        fontSize: 12.sp,
                                        color: AppColors.primaryColor,
                                      ),
                                    ),
                                    SizedBox(height: 8.h),
                                    IntlPhoneField(
                                      controller: phoneNumber,
                                      initialValue: currentUser.getPhoneNumber,
                                      disableLengthCheck: true,
                                      decoration: InputDecoration(
                                        filled: true,
                                        fillColor: AppColors.textFieldFilledColor,
                                        hintText: 'Enter phone number',
                                    hintStyle: phoneHintStyle,
                                        contentPadding: EdgeInsets.symmetric(
                                          vertical: 14.h,
                                          horizontal: 15.w,
                                        ),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(8.r),
                                          borderSide: BorderSide(
                                            color: Colors.white.withOpacity(0.0),
                                          ),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(8.r),
                                          borderSide: BorderSide(
                                            color: Colors.white.withOpacity(0.0),
                                          ),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(8.r),
                                          borderSide: BorderSide(
                                            color: AppColors.primaryColor.withOpacity(0.0),
                                          ),
                                        ),
                                        errorBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(8.r),
                                          borderSide: const BorderSide(color: Colors.red),
                                        ),
                                        focusedErrorBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(8.r),
                                          borderSide: const BorderSide(color: Colors.red),
                                        ),
                                      ),
                                      initialCountryCode: 'US',
                                      onChanged: (phone) {
                                        countryCode = phone.countryCode;
                                        phoneNumberValue = phone.number;
                                        setState(() {});
                                      },
                                      onCountryChanged: (country) {
                                        countryCode = country.code;
                                        setState(() {});
                                      },
                                      textAlignVertical: TextAlignVertical.center,
                                      flagsButtonPadding: EdgeInsets.only(left: 12.w, right: 8.w),
                                      flagsButtonMargin: EdgeInsets.zero,
                                      validator: (phone) {
                                        if (phone == null || phone.number.isEmpty) {
                                          return 'Please enter phone number';
                                        }
                                        final digitsOnly = phone.number
                                            .replaceAll(RegExp(r'[^0-9]'), '');
                                        // International numbers vary a lot; keep it permissive.
                                        // (The old package length check was too strict for some countries.)
                                        if (digitsOnly.length < 6 ||
                                            digitsOnly.length > 15) {
                                          return 'Please enter a valid phone number';
                                        }
                                        return null;
                                      },
                                      pickerDialogStyle: PickerDialogStyle(
                                        searchFieldInputDecoration: InputDecoration(
                                          hintText: 'Search country',
                                          hintStyle: phoneHintStyle,
                                        ),
                                      ),
                                      showCountryFlag: true,
                                      dropdownIcon: Icon(
                                        Icons.arrow_drop_down,
                                        color: Colors.white.withOpacity(0.7),
                                      ),
                                      style: sfProDisplayRegular.copyWith(
                                        fontSize: 14.sp,
                                        color: AppColors.textPrimaryColor,
                                      ),
                                      dropdownTextStyle: sfProDisplayRegular.copyWith(
                                        fontSize: 14.sp,
                                        color: AppColors.textPrimaryColor,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: ScreenUtil().setHeight(
                                      isFormDirty.value == true ? 28 : 32.h),
                                ),
                                PrimaryButton(
                                    title: "Next",
                                    onTap: () {
                                      if (_formKey.currentState!.validate()) {
                                          // Combine country code with phone number
                                          String fullPhoneNumber = phoneNumberValue ?? phoneNumber.text;
                                          if (countryCode != null && fullPhoneNumber.isNotEmpty) {
                                            fullPhoneNumber = '+$countryCode$fullPhoneNumber';
                                          }
                                          
                                          userViewModel.updatePersonalDetails(
                                              name.text,
                                              fullPhoneNumber,
                                              dateOfBirth.text);

                                          // Gender is collected first now, so continue to Language.
                                          Get.toNamed(AppRoutes.languageScreen);
                                      } else {
                                        isFormDirty.value = true;
                                      }
                                    }),
                              ],
                            ),
                          ],
                        ),
                      );
                    }),
                  ],
                );
              }),
        ),
      ),
    );
  }
}
