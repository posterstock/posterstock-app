import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:poster_stock/common/constants/languages.dart';
import 'package:poster_stock/features/settings/state_holders/chosen_language_state_holder.dart';

final appLanguageControllerProvider = Provider<AppLanguageController>(
  (ref) => AppLanguageController(
    chosenLanguageState: ref.watch(chosenLanguageStateHolder.notifier),
  ),
);

class AppLanguageController {
  final ChosenLanguageStateHolder chosenLanguageState;

  AppLanguageController({
    required this.chosenLanguageState,
  });

  Future<void> updateLanguage(Languages language) async {
    await chosenLanguageState.setLocale(language);
  }
}
