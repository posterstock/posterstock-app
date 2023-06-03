import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:poster_stock/features/settings/state_holders/change_email_code_state_holder.dart';
import 'package:poster_stock/features/settings/state_holders/change_email_state_holder.dart';

final changeEmailControllerProvider = Provider<ChangeEmailController>(
  (ref) => ChangeEmailController(
    changeEmailStateHolder: ref.watch(changeEmailStateHolderProvider.notifier),
    changeEmailCodeStateHolder: ref.watch(changeEmailCodeStateHolderProvider.notifier),
  ),
);

class ChangeEmailController {
  const ChangeEmailController({
    required this.changeEmailStateHolder,
    required this.changeEmailCodeStateHolder,
  });

  final ChangeEmailStateHolder changeEmailStateHolder;
  final ChangeEmailCodeStateHolder changeEmailCodeStateHolder;

  Future<void> updateEmail(String value) async {
    changeEmailStateHolder.setEmail(value);
  }

  Future<void> updateCode(String code) async {
    changeEmailCodeStateHolder.setCode(code);
  }
}
