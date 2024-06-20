import 'package:blog_app/core/theme/pallete.dart';
import 'package:flutter/material.dart';

//SET THE THEME FOR ALL THE SCAFFOLDS (SCAFFOLD)
//SET THE THEME FOR ALL THE INPUTDECORATION
class AppTheme {
  static _inputBorder([Color color = AppPallete.borderColor]) =>
      OutlineInputBorder(
        borderSide: BorderSide(color: color, width: 3),
        borderRadius: BorderRadius.circular(10),
      );

  static final darkThemeMode = ThemeData.dark().copyWith(
    appBarTheme: const AppBarTheme(
      backgroundColor: AppPallete.backgroundColor,
    ),
    chipTheme: const ChipThemeData(
        side: BorderSide.none,
        color: MaterialStatePropertyAll(AppPallete.backgroundColor)),
    scaffoldBackgroundColor: AppPallete.backgroundColor,
    inputDecorationTheme: InputDecorationTheme(
        contentPadding: const EdgeInsets.all(27),
        border: _inputBorder(),
        focusedBorder: _inputBorder(AppPallete.gradient2),
        enabledBorder: _inputBorder(),
        errorBorder: _inputBorder(AppPallete.errorColor)),
  );
}
