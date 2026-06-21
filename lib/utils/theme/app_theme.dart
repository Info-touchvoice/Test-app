import 'package:flutter/material.dart';
import 'package:tiki/utils/theme/colors_constant.dart';

class AppTheme {
  const AppTheme._();

  static ThemeData get theme => ThemeData(
        useMaterial3: false,
        brightness: Brightness.dark,
        primaryColor: AppColors.primaryPurple,
        scaffoldBackgroundColor: AppColors.background,
        canvasColor: AppColors.background,
        dividerColor: AppColors.dividerColor,
        disabledColor: AppColors.textSecondaryColor.withOpacity(0.35),
        colorScheme: const ColorScheme.dark(
          primary: AppColors.primaryPurple,
          secondary: AppColors.primaryBlue,
          surface: AppColors.cardBackground,
          background: AppColors.background,
          error: AppColors.error,
          onPrimary: AppColors.textPrimaryColor,
          onSecondary: AppColors.textPrimaryColor,
          onSurface: AppColors.textPrimaryColor,
          onBackground: AppColors.textPrimaryColor,
          onError: AppColors.textPrimaryColor,
        ),
        fontFamily: 'SFProDisplay',
        textTheme: _textTheme,
        primaryTextTheme: _textTheme,
        iconTheme: const IconThemeData(color: AppColors.textPrimaryColor),
        primaryIconTheme: const IconThemeData(color: AppColors.textPrimaryColor),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          foregroundColor: AppColors.textPrimaryColor,
          elevation: 0,
          centerTitle: true,
          iconTheme: IconThemeData(color: AppColors.textPrimaryColor),
          actionsIconTheme: IconThemeData(color: AppColors.textPrimaryColor),
          titleTextStyle: TextStyle(
            color: AppColors.textPrimaryColor,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        cardTheme: CardTheme(
          color: AppColors.cardBackground,
          elevation: 0,
          margin: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppColors.cardRadius),
            side: BorderSide(color: AppColors.cardBorderColor),
          ),
        ),
        dialogTheme: DialogTheme(
          backgroundColor: AppColors.cardBackground,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppColors.cardRadius),
            side: BorderSide(color: AppColors.borderColor),
          ),
          titleTextStyle: const TextStyle(
            color: AppColors.textPrimaryColor,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
          contentTextStyle: const TextStyle(
            color: AppColors.textSecondaryColor,
            fontSize: 14,
          ),
        ),
        bottomSheetTheme: const BottomSheetThemeData(
          backgroundColor: AppColors.cardBackground,
          modalBackgroundColor: AppColors.cardBackground,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: AppColors.secondaryBackground,
          selectedItemColor: AppColors.textPrimaryColor,
          unselectedItemColor: AppColors.textSecondaryColor,
          type: BottomNavigationBarType.fixed,
          elevation: 0,
        ),
        tabBarTheme: const TabBarTheme(
          labelColor: AppColors.textPrimaryColor,
          unselectedLabelColor: AppColors.textSecondaryColor,
          indicatorSize: TabBarIndicatorSize.label,
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppColors.textFieldFilledColor,
          hintStyle: AppColors.hintTextStyle,
          labelStyle: const TextStyle(color: AppColors.textSecondaryColor),
          prefixIconColor: AppColors.textSecondaryColor,
          suffixIconColor: AppColors.textSecondaryColor,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: BorderSide(color: AppColors.borderColor),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: BorderSide(color: AppColors.borderColor),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: const BorderSide(color: AppColors.primaryPurple),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: const BorderSide(color: AppColors.error),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: const BorderSide(color: AppColors.error),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            foregroundColor: AppColors.textPrimaryColor,
            backgroundColor: AppColors.primaryPurple,
            shadowColor: AppColors.primaryPurple.withOpacity(0.2),
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
            textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: AppColors.primaryBlue,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.textPrimaryColor,
            side: BorderSide(color: AppColors.borderColor),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
          ),
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: AppColors.primaryPurple,
          foregroundColor: AppColors.textPrimaryColor,
          elevation: 0,
        ),
        chipTheme: ChipThemeData(
          backgroundColor: AppColors.cardBackground,
          selectedColor: AppColors.primaryPurple.withOpacity(0.24),
          disabledColor: AppColors.secondaryBackground,
          labelStyle: const TextStyle(color: AppColors.textPrimaryColor),
          secondaryLabelStyle: const TextStyle(color: AppColors.textPrimaryColor),
          side: BorderSide(color: AppColors.borderColor),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          brightness: Brightness.dark,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        ),
        popupMenuTheme: PopupMenuThemeData(
          color: AppColors.cardBackground,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
            side: BorderSide(color: AppColors.borderColor),
          ),
          textStyle: const TextStyle(color: AppColors.textPrimaryColor),
        ),
        snackBarTheme: SnackBarThemeData(
          backgroundColor: AppColors.cardBackground,
          contentTextStyle: const TextStyle(color: AppColors.textPrimaryColor),
          actionTextColor: AppColors.primaryBlue,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          behavior: SnackBarBehavior.floating,
        ),
        dividerTheme: DividerThemeData(
          color: AppColors.dividerColor,
          thickness: 1,
          space: 1,
        ),
        progressIndicatorTheme: const ProgressIndicatorThemeData(
          color: AppColors.primaryPurple,
          circularTrackColor: AppColors.secondaryBackground,
          linearTrackColor: AppColors.secondaryBackground,
        ),
        switchTheme: SwitchThemeData(
          thumbColor: MaterialStateProperty.resolveWith(
            (_) => AppColors.textPrimaryColor,
          ),
          trackColor: MaterialStateProperty.resolveWith(
            (states) => states.contains(MaterialState.selected)
                ? AppColors.primaryPurple.withOpacity(0.55)
                : AppColors.borderColor,
          ),
        ),
        checkboxTheme: CheckboxThemeData(
          fillColor: MaterialStateProperty.resolveWith(
            (states) => states.contains(MaterialState.selected)
                ? AppColors.primaryPurple
                : Colors.transparent,
          ),
          checkColor: MaterialStateProperty.all(AppColors.textPrimaryColor),
          side: BorderSide(color: AppColors.borderColor),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        ),
        radioTheme: RadioThemeData(
          fillColor: MaterialStateProperty.resolveWith(
            (states) => states.contains(MaterialState.selected)
                ? AppColors.primaryPurple
                : AppColors.textSecondaryColor,
          ),
        ),
        sliderTheme: SliderThemeData(
          activeTrackColor: AppColors.primaryPurple,
          inactiveTrackColor: AppColors.borderColor,
          thumbColor: AppColors.primaryBlue,
          overlayColor: AppColors.primaryPurple.withOpacity(0.18),
        ),
        textSelectionTheme: TextSelectionThemeData(
          cursorColor: AppColors.primaryBlue,
          selectionColor: AppColors.primaryPurple.withOpacity(0.35),
          selectionHandleColor: AppColors.primaryPurple,
        ),
      );

  static final TextTheme _textTheme = TextTheme(
    displayLarge: _textStyle(36, FontWeight.w700),
    displayMedium: _textStyle(32, FontWeight.w700),
    displaySmall: _textStyle(28, FontWeight.w700),
    headlineLarge: _textStyle(24, FontWeight.w700),
    headlineMedium: _textStyle(22, FontWeight.w700),
    headlineSmall: _textStyle(20, FontWeight.w700),
    titleLarge: _textStyle(18, FontWeight.w700),
    titleMedium: _textStyle(16, FontWeight.w600),
    titleSmall: _textStyle(14, FontWeight.w600),
    bodyLarge: _textStyle(16, FontWeight.w400),
    bodyMedium: _textStyle(14, FontWeight.w400),
    bodySmall: _textStyle(12, FontWeight.w400, AppColors.textSecondaryColor),
    labelLarge: _textStyle(14, FontWeight.w700),
    labelMedium: _textStyle(12, FontWeight.w600),
    labelSmall: _textStyle(11, FontWeight.w500, AppColors.textSecondaryColor),
  );

  static TextStyle _textStyle(
    double size,
    FontWeight weight, [
    Color color = AppColors.textPrimaryColor,
  ]) {
    return TextStyle(
      color: color,
      fontSize: size,
      fontWeight: weight,
    );
  }
}
