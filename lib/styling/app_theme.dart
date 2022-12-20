import 'package:flutter/material.dart';
import 'package:password_manager/utils/size_config.dart';

import 'colors.dart';


class AppTheme {
  AppTheme._();

  static final ThemeData lightTheme = ThemeData(
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

  static final ThemeData darkTheme = ThemeData(
    scaffoldBackgroundColor: Colors.black87,
    appBarTheme: AppTheme.appBarThemeDark,
    brightness: Brightness.dark,
    textTheme: darkTextTheme,
  );

  static final AppBarTheme appBarTheme = AppBarTheme(
    backgroundColor: appBarLight,
    foregroundColor: Colors.white,
    centerTitle: true,
    iconTheme: barIconThemeLight,
    toolbarTextStyle: lightTextTheme.bodyText2,
    titleTextStyle: lightTextTheme.headline6,
  );

  static final AppBarTheme appBarThemeDark = AppBarTheme(
    backgroundColor: appBarDark,
    foregroundColor: Colors.black87,
    centerTitle: true
  );

  static final FloatingActionButtonThemeData fabThemeLight = FloatingActionButtonThemeData(
    backgroundColor: primaryLight,
    splashColor: primaryLightForeground
  );

  static final IconThemeData barIconThemeLight = IconThemeData(
    color: Colors.black87
  );

  static final TextTheme lightTextTheme = TextTheme(
    headline6: _titleLight,
    // headline4: _greetingLight,
    // headline3: _searchLight,
    subtitle1: _subTitleLight,
    subtitle2: _subTitle2Light,
    bodyText2: _basicTextLight,
    // bodyText1: _unSelectedTabLight,
    // button: _buttonLight,
  );

  static final TextTheme darkTextTheme = TextTheme(
    headline6: _titleDark,
    // headline4: _greetingDark,
    // headline3: _searchDark,
    // subtitle2: _subTitleDark,
    // bodyText2: _selectedTabDark,
    // bodyText1: _unSelectedTabDark,
    // button: _buttonDark,
  );

  static final TextStyle _titleLight = TextStyle(
    color: Colors.black87,
    fontSize: 3 * SizeConfig.textMultiplier,
  );

  static final TextStyle _subTitleLight = TextStyle(
    color: Colors.black87,
    fontSize: 2 * SizeConfig.textMultiplier,
    fontWeight: FontWeight.w400
  );

  static final TextStyle _subTitle2Light = TextStyle(
      color: Colors.black87,
      fontSize: 1.5 * SizeConfig.textMultiplier,
      fontWeight: FontWeight.w600
  );

  static final TextStyle _buttonLight = TextStyle(
    color: Colors.black,
    fontSize: 2.5 * SizeConfig.textMultiplier,
  );

  static final TextStyle _greetingLight = TextStyle(
    color: Colors.black,
    fontSize: 2.0 * SizeConfig.textMultiplier,
  );

  static final TextStyle _searchLight = TextStyle(
    color: Colors.black,
    fontSize: 2.3 * SizeConfig.textMultiplier,
  );

  static final TextStyle _basicTextLight = TextStyle(
    color: Colors.black87,
    fontWeight: FontWeight.w400,
    fontSize: 2 * SizeConfig.textMultiplier,
  );

  static final TextStyle _unSelectedTabLight = TextStyle(
    color: Colors.grey,
    fontSize: 2 * SizeConfig.textMultiplier,
  );

  static final TextStyle _titleDark = _titleLight.copyWith(color: Colors.white70);

  static final TextStyle _subTitleDark = _subTitleLight.copyWith(color: Colors.white70);

  static final TextStyle _buttonDark = _buttonLight.copyWith(color: Colors.black);

  static final TextStyle _greetingDark = _greetingLight.copyWith(color: Colors.black);

  static final TextStyle _searchDark = _searchDark.copyWith(color: Colors.black);

  static final TextStyle _selectedTabDark = _selectedTabDark.copyWith(color: Colors.white);

  static final TextStyle _unSelectedTabDark = _selectedTabDark.copyWith(color: Colors.white70);

  static final InputDecorationTheme inputDecorationThemeLight = InputDecorationTheme(
    floatingLabelBehavior: FloatingLabelBehavior.always,
    labelStyle: _labelStyleLight,
    hintStyle: _hintStyleLight,
    errorStyle: _errorStyleLight,
    border: _inputBorderLight,
    focusedBorder: _focusedBorderLight,
    focusedErrorBorder: _focusedErrorBorderLight,
    errorBorder: _errorBorderLight
  );

  static final TextStyle _labelStyleLight = TextStyle(
    fontSize: 2 * SizeConfig.textMultiplier,
    fontWeight: FontWeight.w500,
    color: Colors.black87,
  );

  static final TextStyle _hintStyleLight = TextStyle(
    fontSize: 2 * SizeConfig.textMultiplier,
    fontWeight: FontWeight.w400,
    color: Colors.black26
  );

  static final TextStyle _errorStyleLight = TextStyle(
    fontSize: 1.6 * SizeConfig.textMultiplier,
    fontWeight: FontWeight.w500,
    color: Colors.redAccent
  );

  static final InputBorder _inputBorderLight = OutlineInputBorder(
    borderSide: BorderSide(
      color: Colors.grey,
    )
  );

  static final InputBorder _focusedBorderLight = OutlineInputBorder(
    borderSide: BorderSide(
      color: Colors.green,
    ),
  );

  static final InputBorder _focusedErrorBorderLight = OutlineInputBorder(
    borderSide: BorderSide(
      color: Colors.redAccent,
    ),
  );

  static final InputBorder _errorBorderLight = OutlineInputBorder(
    borderSide: BorderSide(
      color: Colors.redAccent,
    ),
  );

  static final IconThemeData iconThemeLight = IconThemeData(
    color: Colors.black87
  );

  static final ElevatedButtonThemeData elevatedButtonThemeLight = ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      onPrimary: Colors.black87,
      primary: primaryLight,
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