import 'package:flutter/material.dart';

class Languages {
  final String languageName;
  final Locale locale;

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
