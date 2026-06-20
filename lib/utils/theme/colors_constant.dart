import 'package:flutter/material.dart';

class AppColors {
  static const darkBGColor = Color(0xff010101);
  static const darkBGShadeColor = Color(0xff480B44);
  static const bgShadeColor = Color(0xff3B3740);
  static const bgShadeColor2 = Color(0xff323036);
  static const lightBGColor = Color(0xffFFFFFF);
  static const lightShadeColor = Color(0xffFEF3DB);
  static const navBarColor = Color(0xff252626);
  static const kWhite = Color(0xFFFFFFFF);
  static const kBlack = Color(0xFF000000);
  static Color dHintColor = const Color(0xFFFFFFFF).withOpacity(0.7);
  static Color lHintColor = const Color(0xFF000000).withOpacity(0.7);
  static Color lTxtColor = const Color(0xFF000000);
  static Color dTxtColor = const Color(0xFFFFFFFF).withOpacity(0.7);
  static Color txtBtnColor = primaryColor.withOpacity(0.7);
  static Color yellowColor = primaryColor;
  static Color greyColor = const Color(0xFF777777);
  static Color lightOrange = const Color(0xFFFEB749);
  static Color yellowBtnColor = primaryColor;
  static Color darkOrange = const Color(0xFFFB461B);
  static Color darkBlue = const Color(0xFF1D1A25);
  static Color borderColor = const Color(0xFFCFCFFC);
  static Color progressPinkColor = const Color(0xFFD92348);
  static Color progressPinkColor2 = const Color(0xFFFF6381);
  static Color progressLinearOrangeColor1 = const Color(0xFFFB461B);
  static Color progressLinearOrangeColor2 = const Color(0xFFFEB749);
  static Color wishSheetColor = const Color(0xFF1D1927);
  static Color progressLinearGreenColor1 = const Color(0xFF21CF46);
  static Color progressLinearGreenColor2 = const Color(0xFF67FF7D);
  static Color progressBgColor = const Color(0xFFD9D1C2);
  static Color greyText = const Color(0xFF877777);
  static Color orangeContainer = const Color(0xFFEF8D32);
  static Color purpleColor = const Color(0xFFBD8DF4);
  static Color darkPink = const Color(0xFFFF4242);
  static Color greyT = const Color(0xFF494A4A);

  static final List<Color> darkBGGradientColor = [
    darkBGColor,
    darkBGShadeColor,
  ];
  static final List<Color> lightBGGradientColor = [
    lightBGColor,
    lightShadeColor
  ];

  static final List<Color> orangeGradientColor = [
    orange,
    yellowish,
  ];

  static LinearGradient gradient({List<double>? stops}) {
    return LinearGradient(
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
      colors: [
        Color(0xFF4F0070), // Deep purple
        Color(0xFFFF2500), // Bright red
      ],
      stops: stops ?? [0.3, 1.0], // Matches your gradient stops (30% → 100%)
    );
  }

  static LinearGradient secondaryGradient({List<double>? stops}) {
    return LinearGradient(
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
      colors: [
        Color(0xFFFF2500),
        Color(0xFF7D19A7), // Deep purple
        // Bright red
      ],
      stops: stops ?? [0.3, 1.0], // Matches your gradient stops (30% → 100%)
    );
  }

  static Color primaryColor = const Color(0xFFFA036FF);
  static Color secondaryColor = const Color(0xFF5D3B85);
  static Color textPrimaryColor = Colors.white;
  static Color textSecondaryColor = const Color(0x99EBEBF5);

  static Color primaryText(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? kBlack
        : kWhite;
  }

  static Color secondaryText(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? greyT
        : textSecondaryColor;
  }

  static Color hintText(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? lHintColor
        : dHintColor;
  }
  static Color strokeColor = Colors.white.withOpacity(0.3);
  static Color brand = Color(0xffF9C034);

  static Color textFieldFilledColor = Colors.white.withOpacity(0.1);

  static const white = Color(0xffFFFFFF);
  static Color white07 = const Color(0xffFFFFFF).withOpacity(0.07);
  static Color white10 = const Color(0xffFFFFFF).withOpacity(0.1);
  static Color white20 = const Color(0xffFFFFFF).withOpacity(0.2);
  static Color white50 = const Color(0xffFFFFFF).withOpacity(0.5);
  static Color white80 = const Color(0xffFFFFFF).withOpacity(0.8);

  static Color sunshineYellow = Color(0xffFFEE94);
  static Color goldGlow = Color(0xffC48A0B);
  static Color violetVibe = Color(0xffB793F7);
  static Color liveLavender = Color(0xff955AFF);
  static Color steelGray = Color(0xffB0ACA9);
  static Color neutralSlate = Color(0xff9AA0A9);
  static Color oceanBlue = Color(0xff519FF4);
  static Color soundWaveBlue = Color(0xff0B71C4);
  static Color emeraldGreen = Color(0xff24AFA6);
  static Color explorerGreen = Color(0xff63D5BB);

  static Color red = Color(0xffFF0000);

  static Color lTextFieldFilled = const Color(0xFFE5E5E5);
  static Color dTextFieldFilled = const Color(0xFF363339);
  static Color orange = const Color(0xFFFB461B);
  static Color yellowish = const Color(0xFFFEB749);
  static Color yellow = const Color(0xFFFFCC00);
  static Color lightPurple = const Color(0xFFA036FF);
  static Color darkPurple = const Color(0xFF3B0073);
  static Color grey = const Color(0xFFBABABA);

  static const black = Color(0xff000000);
  static const white100 = Color(0xffF3F5F7);
  static const divider = Color(0xff494848);
  static const grey400 = Color(0xff363339);
  static const grey500 = Color(0xff252626);
  static const grey700 = Color(0xff1E2121);
  static const cardBg = Color(0xff0F0C15);
  static const card = Color(0xff212121);
  static const button = Color(0xff323232);
  static const buttonWhite = Color(0xffE5E5E5);
  static const buttonGrey = Color(0xff363339);
  static const strokeWhite = Color(0xffF1F1F5);
  static const blurPurple100 = Color(0xff433D48);
  static final blurPurple50 = const Color(0xff433D48).withOpacity(0.5);
  static final blurYellow20 = primaryColor.withOpacity(0.2);
  static const textWhite = Color(0xffFFFFFF);
  static final textWhite70 = const Color(0xffFFFFFF).withOpacity(0.7);
}
