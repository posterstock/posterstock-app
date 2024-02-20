import 'package:flutter/material.dart';

extension TextEditControllerExt on TextEditingController {
  void listen(void Function(String) listener) {
    addListener(() => listener(text));
  }
}
