import 'package:flutter/material.dart';

class AppColors {
  const AppColors._();

  static const Color background = Color(0xFF090815);
  static const Color secondaryBackground = Color(0xFF111126);
  static const Color cardBackground = Color(0xFF161327);
  static const Color primaryPurple = Color(0xFF8B2CF5);
  static const Color primaryBlue = Color(0xFF3B82F6);
  static const Color buttonGradientStart = Color(0xFF7C3AED);
  static const Color buttonGradientEnd = Color(0xFF2563EB);
  static const Color vipGold = Color(0xFFFFC83D);
  static const Color diamondBlue = Color(0xFF38BDF8);
  static const Color error = Color(0xFFFF4D6D);
  static const Color success = Color(0xFF00D084);
  static const Color textPrimaryColor = Color(0xFFFFFFFF);
  static const Color textSecondaryColor = Color(0xFFB9B6D3);
  static const Color dividerColor = Color(0x14FFFFFF);
  static const Color borderColor = Color(0x1AFFFFFF);
  static const Color cardBorderColor = Color(0x14FFFFFF);
  static const double cardRadius = 18;
  static const double buttonRadius = 18;

  static const Color darkBGColor = background;
  static const Color darkBGShadeColor = secondaryBackground;
  static const Color bgShadeColor = secondaryBackground;
  static const Color bgShadeColor2 = cardBackground;
  static const Color lightBGColor = background;
  static const Color lightShadeColor = secondaryBackground;
  static const Color navBarColor = secondaryBackground;
  static const Color kWhite = textPrimaryColor;
  static const Color kBlack = textPrimaryColor;
  static const Color white = textPrimaryColor;
  static const Color black = background;
  static const Color white100 = textPrimaryColor;
  static const Color divider = dividerColor;
  static const Color grey400 = secondaryBackground;
  static const Color grey500 = secondaryBackground;
  static const Color grey700 = background;
  static const Color cardBg = cardBackground;
  static const Color card = cardBackground;
  static const Color button = primaryPurple;
  static const Color buttonWhite = textPrimaryColor;
  static const Color buttonGrey = secondaryBackground;
  static const Color strokeWhite = borderColor;
  static const Color textWhite = textPrimaryColor;

  static final Color dHintColor = textPrimaryColor.withOpacity(0.7);
  static final Color lHintColor = textPrimaryColor.withOpacity(0.7);
  static const Color lTxtColor = textPrimaryColor;
  static final Color dTxtColor = textPrimaryColor.withOpacity(0.7);
  static final Color txtBtnColor = primaryPurple.withOpacity(0.85);
  static const Color yellowColor = vipGold;
  static const Color greyColor = textSecondaryColor;
  static const Color lightOrange = vipGold;
  static const Color yellowBtnColor = primaryPurple;
  static const Color darkOrange = error;
  static const Color darkBlue = secondaryBackground;
  static const Color progressPinkColor = error;
  static final Color progressPinkColor2 = error.withOpacity(0.75);
  static const Color progressLinearOrangeColor1 = primaryPurple;
  static const Color progressLinearOrangeColor2 = primaryBlue;
  static const Color wishSheetColor = cardBackground;
  static const Color progressLinearGreenColor1 = success;
  static final Color progressLinearGreenColor2 = success.withOpacity(0.75);
  static const Color progressBgColor = secondaryBackground;
  static const Color greyText = textSecondaryColor;
  static const Color orangeContainer = vipGold;
  static const Color purpleColor = primaryPurple;
  static const Color darkPink = error;
  static const Color greyT = textSecondaryColor;
  static const Color primaryColor = primaryPurple;
  static const Color secondaryColor = primaryBlue;
  static final Color strokeColor = textPrimaryColor.withOpacity(0.10);
  static const Color brand = vipGold;
  static final Color textFieldFilledColor = textPrimaryColor.withOpacity(0.08);
  static final Color white07 = textPrimaryColor.withOpacity(0.07);
  static final Color white10 = textPrimaryColor.withOpacity(0.10);
  static final Color white20 = textPrimaryColor.withOpacity(0.20);
  static final Color white50 = textPrimaryColor.withOpacity(0.50);
  static final Color white80 = textPrimaryColor.withOpacity(0.80);
  static const Color sunshineYellow = vipGold;
  static const Color goldGlow = vipGold;
  static const Color violetVibe = primaryPurple;
  static const Color liveLavender = primaryPurple;
  static const Color steelGray = textSecondaryColor;
  static const Color neutralSlate = textSecondaryColor;
  static const Color oceanBlue = primaryBlue;
  static const Color soundWaveBlue = primaryBlue;
  static const Color emeraldGreen = success;
  static const Color explorerGreen = success;
  static const Color red = error;
  static final Color lTextFieldFilled = textPrimaryColor.withOpacity(0.08);
  static final Color dTextFieldFilled = textPrimaryColor.withOpacity(0.08);
  static const Color orange = vipGold;
  static const Color yellowish = vipGold;
  static const Color yellow = vipGold;
  static const Color lightPurple = primaryPurple;
  static const Color darkPurple = secondaryBackground;
  static const Color grey = textSecondaryColor;
  static const Color blurPurple100 = primaryPurple;
  static final Color blurPurple50 = primaryPurple.withOpacity(0.5);
  static final Color blurYellow20 = vipGold.withOpacity(0.2);
  static final Color textWhite70 = textPrimaryColor.withOpacity(0.7);

  static final List<Color> darkBGGradientColor = [
    background,
    secondaryBackground,
  ];

  static final List<Color> lightBGGradientColor = [
    background,
    secondaryBackground,
  ];

  static const List<Color> primaryGradientColors = [
    primaryPurple,
    primaryBlue,
  ];

  static const List<Color> buttonGradientColors = [
    buttonGradientStart,
    buttonGradientEnd,
  ];

  static const List<Color> orangeGradientColor = buttonGradientColors;

  static LinearGradient gradient({List<double>? stops}) {
    return LinearGradient(
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
      colors: primaryGradientColors,
      stops: stops,
    );
  }

  static LinearGradient secondaryGradient({List<double>? stops}) {
    return LinearGradient(
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
      colors: buttonGradientColors,
      stops: stops,
    );
  }

  static LinearGradient backgroundGradient() {
    return const LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        secondaryBackground,
        background,
      ],
    );
  }

  static LinearGradient cardGradient() {
    return LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        cardBackground.withOpacity(0.98),
        secondaryBackground.withOpacity(0.94),
      ],
    );
  }

  static List<BoxShadow> softShadow({
    Color color = primaryPurple,
    double opacity = 0.16,
    double blurRadius = 24,
    Offset offset = const Offset(0, 12),
  }) {
    return [
      BoxShadow(
        color: color.withOpacity(opacity),
        blurRadius: blurRadius,
        offset: offset,
      ),
    ];
  }

  static BoxDecoration cardDecoration({
    double radius = cardRadius,
    Color? color,
    bool shadow = true,
  }) {
    return BoxDecoration(
      color: color ?? cardBackground,
      borderRadius: BorderRadius.circular(radius),
      border: Border.all(color: cardBorderColor),
      boxShadow: shadow
          ? softShadow(color: Colors.black, opacity: 0.20, blurRadius: 18)
          : null,
    );
  }

  static BoxDecoration primaryButtonDecoration({
    double radius = buttonRadius,
    bool shadow = true,
  }) {
    return BoxDecoration(
      gradient: secondaryGradient(),
      borderRadius: BorderRadius.circular(radius),
      boxShadow: shadow
          ? softShadow(
              color: primaryPurple,
              opacity: 0.20,
              blurRadius: 18,
              offset: const Offset(0, 8),
            )
          : null,
    );
  }

  static TextStyle get hintTextStyle => TextStyle(
        color: textPrimaryColor.withOpacity(0.70),
      );

  static Color primaryText(BuildContext context) => textPrimaryColor;

  static Color secondaryText(BuildContext context) => textSecondaryColor;

  static Color hintText(BuildContext context) => textPrimaryColor.withOpacity(0.70);
}
