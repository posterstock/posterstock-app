import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:poster_stock/common/constants/languages.dart';
import 'package:poster_stock/features/list/repository/list_repository.dart';
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
    prefs = await SharedPreferences.getInstance();
    String? locale = prefs.getString(_key);
    locale ??= Platform.localeName;

    switch (locale) {
      case 'English' || 'en_US':
        state = Languages.english();
        break;
      case 'Русский' || 'ru_RU':
        state = Languages.russian();
        break;
    }

    final ListRepository listRepository = ListRepository();
    String lang = state!.locale.toLanguageTag();
    listRepository.changeDefaultLang(lang);
  }

  Future<void> setLocale(Languages language) async {
    state = language;
    prefs.setString(_key, language.languageName);
  }
}
