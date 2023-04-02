import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final localizations = StateNotifierProvider<IntlStateHolder, AppLocalizations?>(
  (ref) => IntlStateHolder(null),
);

class IntlStateHolder extends StateNotifier<AppLocalizations?> {
  IntlStateHolder(super._state);

  void setLocalizations(AppLocalizations? local) {
    state = local;
  }
}
