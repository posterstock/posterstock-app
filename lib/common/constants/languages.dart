import 'package:flutter/material.dart';

class Languages {
  final String languageName;
  final Locale locale;

  Languages({required this.languageName, required this.locale});

  factory Languages.english() {
    return Languages(languageName: "English", locale:  Locale('en', 'US'),);
  }

  factory Languages.russian() {
    return Languages(languageName: "Русский", locale: Locale('ru', 'RU'),);
  }
}
