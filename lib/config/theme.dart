import 'package:flutter/material.dart';

class ThemeConfig {
  static ThemeData light(BuildContext context) {
    return ThemeData(
      fontFamily: 'Microsoft YaHei',
      scaffoldBackgroundColor: Colors.white,
      primaryColor: Colors.blue,
      colorScheme: ColorScheme.light(primary: Colors.blue),
      iconTheme: IconThemeData(color: Color(0xFF171717)),
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
            return Color(0xFF171717);
          }),
          fixedSize: WidgetStateProperty.all(Size(36.0, 36.0)),
          // iconSize: WidgetStateProperty.all(24.0),
          visualDensity: VisualDensity.compact,
          padding: WidgetStateProperty.all(EdgeInsets.zero),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        hintStyle: TextStyle(fontSize: 14.0),
        border: InputBorder.none,
        isCollapsed: true,
      ),
      textTheme: TextTheme(
        titleSmall: TextStyle(
          fontSize: 13.0,
          fontWeight: .bold,
          color: Color(0XFF121212),
        ),
        bodyMedium: TextStyle(fontSize: 14.0, color: Color(0XFF121212)),
        labelSmall: TextStyle(fontSize: 12.0, color: Colors.grey),
      ),
    );
  }
}
