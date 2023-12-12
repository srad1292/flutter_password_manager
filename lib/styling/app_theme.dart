import 'package:flutter/material.dart';
import 'package:password_manager/utils/size_config.dart';

import 'colors.dart';


class AppTheme {
  AppTheme._();

  static ThemeData lightTheme = ThemeData(
    scaffoldBackgroundColor: appBackgroundColor,
    appBarTheme: appBarTheme,
    floatingActionButtonTheme: fabThemeLight,
    brightness: Brightness.light,
    textTheme: lightTextTheme,
    inputDecorationTheme: inputDecorationThemeLight,
    iconTheme: iconThemeLight,
    elevatedButtonTheme: elevatedButtonThemeLight,
    toggleableActiveColor: primaryLightForeground,
  );

  static ThemeData darkTheme = ThemeData(
    scaffoldBackgroundColor: Colors.black87,
    appBarTheme: AppTheme.appBarThemeDark,
    brightness: Brightness.dark,
    textTheme: darkTextTheme,
  );

  static AppBarTheme appBarTheme = AppBarTheme(
    backgroundColor: appBarLight,
    foregroundColor: Colors.white,
    centerTitle: true,
    iconTheme: barIconThemeLight,
    toolbarTextStyle: lightTextTheme.bodyMedium,
    titleTextStyle: lightTextTheme.titleLarge,
  );

  static AppBarTheme appBarThemeDark = AppBarTheme(
    backgroundColor: appBarDark,
    foregroundColor: Colors.black87,
    centerTitle: true
  );

  static FloatingActionButtonThemeData fabThemeLight = FloatingActionButtonThemeData(
    backgroundColor: primaryLight,
    splashColor: primaryLightForeground
  );

  static IconThemeData barIconThemeLight = IconThemeData(
    color: Colors.black87
  );

  static TextTheme lightTextTheme = TextTheme(
    titleLarge: _titleLight,
    // headline4: _greetingLight,
    // headline3: _searchLight,
    titleMedium: _subTitleLight,
    titleSmall: _subTitle2Light,
    bodyMedium: _basicTextLight,
    // bodyText1: _unSelectedTabLight,
    // button: _buttonLight,
  );

  static TextTheme darkTextTheme = TextTheme(
    titleLarge: _titleDark,
    // headline4: _greetingDark,
    // headline3: _searchDark,
    // subtitle2: _subTitleDark,
    // bodyText2: _selectedTabDark,
    // bodyText1: _unSelectedTabDark,
    // button: _buttonDark,
  );

  static TextStyle _titleLight = TextStyle(
    color: Colors.black87,
    fontSize: 3 * SizeConfig.textMultiplier,
  );

  static TextStyle _subTitleLight = TextStyle(
    color: Colors.black87,
    fontSize: 2 * SizeConfig.textMultiplier,
    fontWeight: FontWeight.w400
  );

  static TextStyle _subTitle2Light = TextStyle(
      color: Colors.black87,
      fontSize: 1.5 * SizeConfig.textMultiplier,
      fontWeight: FontWeight.w600
  );

  static TextStyle _buttonLight = TextStyle(
    color: Colors.black,
    fontSize: 2.5 * SizeConfig.textMultiplier,
  );

  static TextStyle _greetingLight = TextStyle(
    color: Colors.black,
    fontSize: 2.0 * SizeConfig.textMultiplier,
  );

  static TextStyle _searchLight = TextStyle(
    color: Colors.black,
    fontSize: 2.3 * SizeConfig.textMultiplier,
  );

  static TextStyle _basicTextLight = TextStyle(
    color: Colors.black87,
    fontWeight: FontWeight.w400,
    fontSize: 2 * SizeConfig.textMultiplier,
  );

  static TextStyle _unSelectedTabLight = TextStyle(
    color: Colors.grey,
    fontSize: 2 * SizeConfig.textMultiplier,
  );

  static TextStyle _titleDark = _titleLight.copyWith(color: Colors.white70);

  static TextStyle _subTitleDark = _subTitleLight.copyWith(color: Colors.white70);

  static TextStyle _buttonDark = _buttonLight.copyWith(color: Colors.black);

  static TextStyle _greetingDark = _greetingLight.copyWith(color: Colors.black);

  static TextStyle _searchDark = _searchDark.copyWith(color: Colors.black);

  static TextStyle _selectedTabDark = _selectedTabDark.copyWith(color: Colors.white);

  static TextStyle _unSelectedTabDark = _selectedTabDark.copyWith(color: Colors.white70);

  static InputDecorationTheme inputDecorationThemeLight = InputDecorationTheme(
    floatingLabelBehavior: FloatingLabelBehavior.always,
    labelStyle: _labelStyleLight,
    hintStyle: _hintStyleLight,
    errorStyle: _errorStyleLight,
    border: _inputBorderLight,
    focusedBorder: _focusedBorderLight,
    focusedErrorBorder: _focusedErrorBorderLight,
    errorBorder: _errorBorderLight
  );

  static TextStyle _labelStyleLight = TextStyle(
    fontSize: 2 * SizeConfig.textMultiplier,
    fontWeight: FontWeight.w500,
    color: Colors.black87,
  );

  static TextStyle _hintStyleLight = TextStyle(
    fontSize: 2 * SizeConfig.textMultiplier,
    fontWeight: FontWeight.w400,
    color: Colors.black26
  );

  static TextStyle _errorStyleLight = TextStyle(
    fontSize: 1.6 * SizeConfig.textMultiplier,
    fontWeight: FontWeight.w500,
    color: Colors.redAccent
  );

  static InputBorder _inputBorderLight = OutlineInputBorder(
    borderSide: BorderSide(
      color: Colors.grey,
    )
  );

  static InputBorder _focusedBorderLight = OutlineInputBorder(
    borderSide: BorderSide(
      color: Colors.green,
    ),
  );

  static InputBorder _focusedErrorBorderLight = OutlineInputBorder(
    borderSide: BorderSide(
      color: Colors.redAccent,
    ),
  );

  static InputBorder _errorBorderLight = OutlineInputBorder(
    borderSide: BorderSide(
      color: Colors.redAccent,
    ),
  );

  static IconThemeData iconThemeLight = IconThemeData(
    color: Colors.black87
  );

  static ElevatedButtonThemeData elevatedButtonThemeLight = ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      foregroundColor: Colors.black87,
      backgroundColor: primaryLight,
      textStyle: TextStyle(
        color: Colors.black87,
        fontSize: 2.5 * SizeConfig.textMultiplier,
      ),
      padding: EdgeInsets.symmetric(
        vertical: 1.2 * SizeConfig.heightMultiplier,
        horizontal: 6 * SizeConfig.widthMultiplier
      ),
    ),
  );

}