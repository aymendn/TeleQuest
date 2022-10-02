import 'package:flutter/material.dart';
import 'app_color.dart';

class AppTheme {
  static const fontFamily = 'nunito';

  static final onBg = colorScheme.onBackground;
  static ThemeData myThemeData = ThemeData(
    // useMaterial3: true,
    colorScheme: colorScheme,
    primaryColor: colorScheme.primary,
    fontFamily: fontFamily,
    textTheme: TextTheme(
      headline1: TextStyle(fontWeight: _bold, fontSize: 48, color: onBg),
      headline2: TextStyle(fontWeight: _bold, fontSize: 38, color: onBg),
      headline3: TextStyle(fontWeight: _semiBold, fontSize: 32, color: onBg),
      headline4: TextStyle(fontWeight: _semiBold, fontSize: 24, color: onBg),
      headline5: TextStyle(fontWeight: _medium, fontSize: 20, color: onBg),
      headline6: TextStyle(fontWeight: _regular, fontSize: 18, color: onBg),
      //
      bodyText1: const TextStyle(fontWeight: _regular, fontSize: 16),
      bodyText2: const TextStyle(fontWeight: _bold, fontSize: 16),
      //
      caption: const TextStyle(fontWeight: _semiBold, fontSize: 16),
      button: const TextStyle(fontWeight: _bold, fontSize: 18),
      //
    ),
  );

  static final ColorScheme colorScheme = ColorScheme.fromSeed(
    seedColor: AppColor.primary,
    secondary: AppColor.secondary,
    brightness: Brightness.dark,
  );

  static const _regular = FontWeight.w400;
  static const _medium = FontWeight.w500;
  static const _semiBold = FontWeight.w600;
  static const _bold = FontWeight.w700;
}
