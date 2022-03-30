import 'package:flutter/material.dart';

class ChangePasswordViewModel extends ChangeNotifier {
  final data = {'password': '', 'confirm': ''};
  bool _isButtonVisible = false;

  bool get isButtonVBisible => _isButtonVisible;

  void setValue(String key, String value) {
    if (!isData()) _toggleButton();

    data[key] = value;

    print(key + ' set to ' + value);

    if (!isData()) _toggleButton();
  }

  void _toggleButton() {
    _isButtonVisible = !_isButtonVisible;
    notifyListeners();
  }

  bool isData() {
    return !(data['password'] == '' && data['confirm'] == '');
  }

  bool areSame() {
    return data['password'] == data['confirm'];
  }

  void clear() {
    data['password'] = '';
    data['confirm'] = '';
  }
}
