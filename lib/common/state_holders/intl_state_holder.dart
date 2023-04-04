import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final localizations = StateNotifierProvider<IntlStateHolder, AppLocalizations?>(
  (ref) => IntlStateHolder(null),
);

class IntlStateHolder extends StateNotifier<AppLocalizations?> {
  IntlStateHolder(super._state);

  Future<void> setLocalizations(AppLocalizations? local) async {
    await Future.delayed(Duration.zero);
    state = local;
  }
}
