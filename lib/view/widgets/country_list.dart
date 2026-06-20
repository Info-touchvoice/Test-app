import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tiki/utils/theme/colors_constant.dart';

import '../../utils/constants/app_constants.dart';
import '../../utils/constants/typography.dart';

// Define your country names and corresponding flag images
List<String> countryNames = [
  "Argentina",
  "Bangladesh",
  "Bolivia",
  "Brazil",
  "Canada",
  "Chile",
  "China",
  "Colombia",
  "Costa Rico",
  "Ecuador",
  "EL Salvador",
  "France",
  "Germany",
  "India",
  "Israel",
  "Italy",
  "Mexico",
  "Nigeria",
  "Pakistan",
  "Panama",
  "Peru",
  "Qatar",
  "Turkey",
  "UAE",
  "UK",
  "USA",
  "Uruguay",
  "Venezuela",
];

List<String> countryImages = [
  AppImagePath.Argentina,
  AppImagePath.bangladeshFlag,
  AppImagePath.Bolivia,
  AppImagePath.Brazil,
  AppImagePath.canadaFlag,
  AppImagePath.Chile,
  AppImagePath.China,
  AppImagePath.Colombia,
  AppImagePath.Costa_Rico,
  AppImagePath.Ecuador,
  AppImagePath.EL_Salvador,
  AppImagePath.franceFlag,
  AppImagePath.Germany,
  AppImagePath.India,
  AppImagePath.Israel,
  AppImagePath.Italy,
  AppImagePath.Mexico,
  AppImagePath.Nigeria,
  AppImagePath.pakistanFlag,
  AppImagePath.Panama,
  AppImagePath.Peru,
  AppImagePath.Qatar,
  AppImagePath.Turkey,
  AppImagePath.UAE,
  AppImagePath.UK,
  AppImagePath.USA,
  AppImagePath.Uruguay,
  AppImagePath.Venezuela,
];

class CountryPickerFormField extends StatefulWidget {
  final String? Function(String?)? validator;
  final String? selectedCountry;
  final Function(String)? onChanged;

  const CountryPickerFormField({
    this.validator,
    this.selectedCountry,
    this.onChanged,
  });

  @override
  _CountryPickerFormFieldState createState() => _CountryPickerFormFieldState();
}

class _CountryPickerFormFieldState extends State<CountryPickerFormField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: widget.validator,
      autovalidateMode: AutovalidateMode.disabled,
      readOnly: true,
      controller: TextEditingController(text: widget.selectedCountry),
      style: sfProDisplayMedium.copyWith(
          fontSize: 12.sp, color: Colors.white.withOpacity(0.7)),
      decoration: InputDecoration(
          contentPadding:
              const EdgeInsets.symmetric(vertical: 14.0, horizontal: 15.0),
          hintText: "Select your Country",
          hintStyle: sfProDisplayMedium.copyWith(
              fontSize: 12.sp, color: Colors.white.withOpacity(0.3)),
          border: InputBorder.none,
          suffixIcon: widget.selectedCountry != null
              ? Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: SvgPicture.asset(
                    countryImages[
                        countryNames.indexOf(widget.selectedCountry!)],
                    width: 32,
                    height: 32,
                  ),
                )
              : null,
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(100),
              borderSide: const BorderSide(color: Colors.transparent)),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(100),
              borderSide: const BorderSide(color: Colors.transparent)),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(100),
            borderSide: const BorderSide(color: Colors.red),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(100),
            borderSide: const BorderSide(color: Colors.red),
          )),
    );
  }
}

void showCountryPicker(BuildContext context, Function(String)? onChanged) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      backgroundColor: AppColors.card,
      title: const Text('Select Country'),
      content: SingleChildScrollView(
        child: Column(
          children: [
            for (int i = 0; i < countryNames.length; i++)
              ListTile(
                onTap: () {
                  Navigator.pop(context);
                  if (onChanged != null) {
                    onChanged!(countryNames[i]);
                  }
                },
                title: Row(
                  children: [
                    SvgPicture.asset(
                      countryImages[i],
                      width: 24,
                      height: 24,
                    ),
                    const SizedBox(width: 8),
                    Text(countryNames[i]),
                  ],
                ),
              ),
          ],
        ),
      ),
    ),
  );
}
