import 'package:flutter/material.dart';

class ContainerProvider extends ChangeNotifier {
  var _color = Colors.red;

  Color get color => _color;

  void onTap() {
    if (_color == Colors.red) {
      _color = Colors.green;
    } else {
      _color = Colors.red;
    }
    notifyListeners();
  }
}
