import 'package:cloud_chest/screens/auth/auth_screen.dart';
import 'package:flutter/material.dart';

class WidgetFactory {
  static Widget create(String widgetName) {
    switch (widgetName) {
      case '/authScreen':
        return AuthScreen();
      default:
        return Container();
    }
  }
}
