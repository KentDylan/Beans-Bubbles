import 'package:flutter/material.dart';

class ColorProvider extends ChangeNotifier {
  Color currentColor = Colors.orange;

  void changeColor(Color color) {
    currentColor = color;
    notifyListeners();
  }
}
