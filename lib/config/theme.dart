import 'package:flutter/material.dart';

class ThemeConfig {
  static ThemeData light(BuildContext context) {
    return ThemeData(
      fontFamily: 'Microsoft YaHei',
      scaffoldBackgroundColor: Colors.white,
      primaryColor: Colors.blue,
      colorScheme: ColorScheme.light(primary: Colors.blue),
      inputDecorationTheme: InputDecorationTheme(
        hintStyle: TextStyle(fontSize: 14.0),
        border: InputBorder.none,
        isCollapsed: true,
      ),
      iconButtonTheme: IconButtonThemeData(
        style: ButtonStyle(
          mouseCursor: WidgetStateProperty.resolveWith((state) {
            if (state.contains(WidgetState.disabled)) {
              return SystemMouseCursors.basic;
            }
            return SystemMouseCursors.click;
          }),
          iconColor: WidgetStateProperty.resolveWith((state) {
            if (state.contains(WidgetState.disabled)) {
              return Theme.of(context).disabledColor;
            }
            return Colors.blue;
          }),
          fixedSize: WidgetStateProperty.all(Size(36.0, 36.0)),
          // iconSize: WidgetStateProperty.all(24.0),
          visualDensity: VisualDensity.compact,
          padding: WidgetStateProperty.all(EdgeInsets.zero),
        ),
      ),
    );
  }
}
