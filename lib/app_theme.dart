import 'package:flutter/material.dart';
import 'package:urban_council/widgets/colors.dart';

class AppTheme {
  static _border([Color color = ColorTheme.blackColor]) => OutlineInputBorder(
    borderSide: BorderSide(color: color, width: 2.0),
    borderRadius: BorderRadius.circular(12.0),
  );

  final lightTheme = ThemeData.light().copyWith(
      scaffoldBackgroundColor: ColorTheme.whiteColor,
      inputDecorationTheme: InputDecorationTheme(
        border: _border(),
        focusedBorder: _border(ColorTheme.focusedColor),
        enabledBorder: _border(),
      ));
}