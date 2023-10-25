import 'package:flutter/material.dart';

class Languages {
  final String languageName;
  final Locale locale;

  Languages({required this.languageName, required this.locale});

  factory Languages.english() {
    return Languages(languageName: "English", locale:  Locale('en', 'US'),);
  }
}
