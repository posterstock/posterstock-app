import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:poster_stock/common/constants/languages.dart';

final chosenLanguageStateHolder =
    StateNotifierProvider<ChosenLanguageStateHolder, Languages?>(
  (ref) => ChosenLanguageStateHolder(null),
);

class ChosenLanguageStateHolder extends StateNotifier<Languages?> {
  ChosenLanguageStateHolder(super.state);

  Future<void> setLocale(Languages language) async {
    state = language;
  }
}
