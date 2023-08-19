import 'package:flutter/material.dart';

List<Color> _colorTheme = [
  Colors.indigoAccent.shade700,
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
