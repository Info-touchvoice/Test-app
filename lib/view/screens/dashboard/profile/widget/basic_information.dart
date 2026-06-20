import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:tiki/utils/constants/app_constants.dart';
import 'package:tiki/view_model/edit_controller.dart';
import 'package:tiki/view_model/gender_controller.dart';
import 'package:tiki/view_model/relationship_status_controller.dart';
import 'package:tiki/view_model/userViewModel.dart';

import '../../../../../utils/theme/colors_constant.dart';
import '../../../../widgets/country_list.dart';
import 'gender_sheet.dart';

class BasicInformationSection extends StatelessWidget {
  final GenderController genderController = Get.find();
  final RelationshipStatusController relationStatusController = Get.find();

  final EditController editController = Get.find();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime initialDate =
        Get.find<UserViewModel>().currentUser.getBirthday ??
            DateTime.now().subtract(const Duration(days: 365 * 18));
    DateTime selectedDate = initialDate;
    
    final DateTime? confirmed = await showModalBottomSheet<DateTime>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: false,
      builder: (BuildContext context) {
        return SafeArea(
          top: false,
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.cardBg,
              borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
          border: Border(
                top: BorderSide(color: AppColors.white10, width: 1),
          ),
        ),
            child: SizedBox(
              height: 300.h,
          child: Column(
            children: [
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                    child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          style: TextButton.styleFrom(
                            foregroundColor:
                                AppColors.textSecondaryColor.withOpacity(0.9),
                          ),
                    child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () =>
                              Navigator.of(context).pop(selectedDate),
                          style: TextButton.styleFrom(
                            foregroundColor: AppColors.primaryColor,
                          ),
                    child: const Text('Done'),
                  ),
                ],
              ),
                  ),
                  Divider(height: 1, color: AppColors.white10),
              Expanded(
                    child: CupertinoTheme(
                      data: const CupertinoThemeData(
                        brightness: Brightness.dark,
                      ),
                child: CupertinoDatePicker(
                        backgroundColor: AppColors.cardBg,
                  initialDateTime: initialDate,
                  mode: CupertinoDatePickerMode.date,
                  maximumDate: DateTime.now(),
                  minimumDate: DateTime(1900),
                  use24hFormat: false,
                  onDateTimeChanged: (DateTime newDate) {
                    selectedDate = newDate;
                  },
                      ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
      },
    );

    if (confirmed != null) {
      final String formattedDate =
          "${confirmed.year}-${confirmed.month.toString().padLeft(2, '0')}-${confirmed.day.toString().padLeft(2, '0')}";
      editController.updateDate(formattedDate);
    }
  }

  Widget _buildInputField(
    String labelText,
    String hintText,
    String suffixIconPath,
    Color iconColor,
    VoidCallback? onTap,
    TextEditingController textEditingController, {
    bool readOnly = false,
  }) {
    return TextFormField(
      controller: textEditingController,
      readOnly: readOnly,
      decoration: InputDecoration(
        filled: false,
        labelText: labelText,
        labelStyle: TextStyle(
          color: Colors.grey,
          fontSize: 14.sp,
          fontWeight: FontWeight.w500,
        ),
        hintText: hintText,
        hintStyle: TextStyle(
          color: readOnly ? Colors.grey : Colors.white,
          fontSize: 12.sp,
          fontWeight: FontWeight.w400,
          height: 2.0,
        ),
        suffixIcon: suffixIconPath.isNotEmpty
            ? GestureDetector(
                onTap: onTap != null
                    ? () {
                        onTap();
                        textEditingController.selection =
                            TextSelection.collapsed(
                                offset: textEditingController.text.length);
                      }
                    : null,
                child: Image.asset(
                  suffixIconPath,
                  color: iconColor,
                  width: 24,
                  height: 24,
                ),
              )
            : null,
        floatingLabelBehavior: FloatingLabelBehavior.always,
        floatingLabelAlignment: FloatingLabelAlignment.start,
        contentPadding: EdgeInsets.symmetric(
          vertical: 18.0,
          horizontal: 10.0,
        ),
        border: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.grey),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.grey),
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.grey),
        ),
        errorBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.grey),
        ),
        focusedErrorBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.grey),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isLightTheme = Theme.of(context).brightness == Brightness.light;
    final textColor = isLightTheme ? Colors.black : Colors.white;
    final backgroundColor = isLightTheme ? Colors.white : AppColors.grey500;

    UserViewModel userViewModel = Get.find();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Basic Information",
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w700,
            // color: Colors.white,
            color: textColor,
          ),
        ),
        SizedBox(height: 20.h),
        _buildInputField(
            "Name*",
            userViewModel.currentUser.getFullName ?? '',
            AppImagePath.editTextIcon,
            // Colors.white,
            textColor,
            () {},
            editController.nameEditingController),
        SizedBox(height: 20.h),
        Obx(() => _buildInputField(
              "Gender*",
              genderController.selectedGender.value.isNotEmpty
                  ? genderController.selectedGender.value
                  : "Select",
              AppImagePath.dropDownIcon,
              // Colors.white,
              textColor,

              () {
                showModalBottomSheet(
                  context: context,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  isScrollControlled: true,
                  backgroundColor: backgroundColor,
                  builder: (context) => GenderSheet(),
                ).then((value) {
                  editController.genderEditingController.text =
                      genderController.selectedGender.value.isNotEmpty
                          ? genderController.selectedGender.value
                          : "Select";
                });
              },
              editController.genderEditingController,
              readOnly: true,
            )),
        SizedBox(height: 20.h),
        Obx(() => _buildInputField(
              "Birthday*",
              editController.selectedDate.value.isNotEmpty
                  ? editController.selectedDate.value
                  : '${Get.find<UserViewModel>().currentUser.getBirthday!.year}-${doubleDigit(Get.find<UserViewModel>().currentUser.getBirthday!.month.toString())}-${doubleDigit(Get.find<UserViewModel>().currentUser.getBirthday!.day.toString())}',
              AppImagePath.dropDownIcon,
              // Colors.white,
              textColor,

              () {
                _selectDate(context).then((value) => editController
                        .selectedDate.value.isNotEmpty
                    ? editController.birthdayEditingController.text =
                        editController.selectedDate.value
                    : editController.birthdayEditingController.text =
                        '${Get.find<UserViewModel>().currentUser.getBirthday!.year}-${doubleDigit(Get.find<UserViewModel>().currentUser.getBirthday!.month.toString())}-${doubleDigit(Get.find<UserViewModel>().currentUser.getBirthday!.day.toString())}');
                print("Birthday icon tapped");
              },
              editController.birthdayEditingController,
              readOnly: true,
            )),
        SizedBox(height: 20.h),
        _buildInputField(
          "Country",
          (userViewModel.currentUser.getCountry?.isEmpty ?? true)
              ? "Select"
              : userViewModel.currentUser.getCountry!,
          AppImagePath.dropDownIcon,
          // Colors.white,
          textColor,

          () {
            showCountryPicker(context, (value) {
              editController.countryEditingController.text = value;
            });
          },
          editController.countryEditingController,
          readOnly: true,
        ),
        SizedBox(height: 20.h),
        _buildInputField(
            "Bio",
            userViewModel.currentUser.getBio ?? '',
            AppImagePath.editTextIcon,
            // Colors.white,
            textColor, () {
          print("Bio icon tapped");
        }, editController.bioEditingController),
        SizedBox(height: 20.h),
        _buildInputField(
            "Website",
            userViewModel.currentUser.getWebsite ??
                'https://tiki.page.link',
            AppImagePath.editTextIcon,
            // Colors.white,
            textColor, () {
          print("Bio icon tapped");
        }, editController.websiteEditingController),
        SizedBox(height: 20.h),
      ],
    );
  }

  String doubleDigit(String value) {
    if (int.parse(value) <= 9)
      return "0$value";
    else
      return value;
  }
}
