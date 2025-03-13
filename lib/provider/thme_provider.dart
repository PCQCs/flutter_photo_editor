import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  bool _lightModeEnable = true;

  bool get lightModeEnable => _lightModeEnable;

  set lightModeEnable(bool value) {
    _lightModeEnable = value;
  }

  changeMode() {
    if (_lightModeEnable == true) {
      _lightModeEnable = false;
      notifyListeners();
    } else if (_lightModeEnable == false) {
      _lightModeEnable = true;
      notifyListeners();
    }
  }
}
