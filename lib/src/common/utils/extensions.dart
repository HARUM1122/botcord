import 'package:flutter/material.dart';

extension BuildContextExtension on BuildContext {
  Size get getSize => MediaQuery.of(this).size;
  EdgeInsets get padding => MediaQuery.of(this).padding;
  void pushNamed(String name, {Object? arguments}) {
    if (!mounted) return;
    Navigator.pushNamed(this, name, arguments: arguments);
  }
  void pop() {
    if (!mounted) return;
    Navigator.pop(this);
  }
}

extension StringExtension on String {
  List<int> getIndicies(String substr) {
    int idx = 0;
    String sub = '';
    for (int i = 0; i < length; i++) {
      if (substr == sub) {
        return [i - substr.length, i];
      } else if (substr[idx] == this[i]) {
        sub += this[i];
        idx = idx == substr.length - 1 ? 0 : idx + 1;
      } else {
        sub = '';
        idx = 0;
      }
    }
    return [-1, -1];
  }
  String formatSeconds() {
    int seconds = int.parse(this);
    if (seconds == 0) {
      return '';
    }
    int hours = seconds ~/ 3600;
    int minutes = (seconds ~/ 60) % 60;
    int remainingSeconds = seconds % 60;
    
    String hoursStr = hours.toString().padLeft(2, '0');
    String minutesStr = minutes.toString().padLeft(2, '0');
    String secondsStr = remainingSeconds.toString().padLeft(2, '0');
    
    return '$hoursStr:$minutesStr:$secondsStr';
  }
  String capitalize() {
    if (isEmpty) return '';
    return this[0].toUpperCase() + substring(1);
  }
}