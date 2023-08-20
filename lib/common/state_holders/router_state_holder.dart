import 'package:auto_route/auto_route.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final router = StateNotifierProvider<RouterStateHolder, StackRouter?>(
      (ref) => RouterStateHolder(null),
);

class RouterStateHolder extends StateNotifier<StackRouter?> {
  RouterStateHolder(super._state);

  Future<void> setRouter(StackRouter? router) async {
    state = router;
  }
}
