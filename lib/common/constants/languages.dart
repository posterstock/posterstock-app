import 'package:flutter/material.dart';

class Languages {
  final String languageName;
  final Locale locale;

  static Languages byLocale(Locale locale) {
    switch (locale.toLanguageTag()) {
      case 'ru-RU':
        return Languages.russian();
      case 'en-EN':
        return Languages.english();
      default:
        return Languages.english();
    }
  }

  Languages({required this.languageName, required this.locale});

  factory Languages.english() => Languages(
        languageName: "English",
        locale: const Locale('en', 'US'),
      );
  factory Languages.russian() => Languages(
        languageName: "Русский",
        locale: const Locale('ru', 'RU'),
      );
}
