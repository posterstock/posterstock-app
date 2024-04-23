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
      case 'de-DE':
        return Languages.german();
      case 'fr-FR':
        return Languages.french();
      case 'tr-TR':
        return Languages.turkish();
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

  factory Languages.german() => Languages(
        languageName: "Deutsch",
        locale: const Locale('de', 'DE'),
      );

  factory Languages.french() => Languages(
        languageName: "Français",
        locale: const Locale('fr', 'FR'),
      );

  factory Languages.turkish() => Languages(
        languageName: "Türkçe",
        locale: const Locale('tr', 'TR'),
      );
}
