import 'package:flutter/material.dart';

const Color _customColor = Color(0xFF6949FF);

const List<Color> _colorTheme = [
  _customColor,
  Colors.blue,
  Colors.purple,
];

class AppTheme {
  final int selectedColor;

  AppTheme({this.selectedColor = 0})
      : assert(
          selectedColor >= 0 && selectedColor < _colorTheme.length,
          'Invalid color index',
        );

  ThemeData theme() {
    return ThemeData(
      useMaterial3: true,
      colorSchemeSeed: _colorTheme[selectedColor],
    );
  }
}
