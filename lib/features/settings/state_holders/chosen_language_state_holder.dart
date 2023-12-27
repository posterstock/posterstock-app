import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:poster_stock/common/constants/languages.dart';
import 'package:shared_preferences/shared_preferences.dart';

final chosenLanguageStateHolder =
    StateNotifierProvider<ChosenLanguageStateHolder, Languages?>(
  (ref) => ChosenLanguageStateHolder(Languages.english())..init(),
);

class ChosenLanguageStateHolder extends StateNotifier<Languages?> {
  ChosenLanguageStateHolder(super.state);
  final _key = 'locale';
  late final SharedPreferences prefs;

  //TODO: initialize in "main()" method
  Future<void> init() async {
// ref.read(chosenLanguageStateHolder.notifier).setLocale(initLocale);
/*
    Languages initLocale;
    switch (storedLocale) {
      case 'English':
        initLocale = Languages.english();
        break;
      case 'Русский':
        initLocale = Languages.russian();
        break;
      default:
        initLocale = Languages.byLocale(WidgetsBinding.instance.window.locale);
    }
*/
    prefs = await SharedPreferences.getInstance();
    final locale = prefs.getString(_key);
    if (locale != null) {
      switch (locale) {
        case 'English':
          state = Languages.english();
          break;
        case 'Русский':
          state = Languages.russian();
          break;
      }
    }
  }

  Future<void> setLocale(Languages language) async {
    state = language;
    prefs.setString(_key, language.languageName);
  }
}
