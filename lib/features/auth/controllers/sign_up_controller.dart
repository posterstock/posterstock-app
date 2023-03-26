import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:poster_stock/features/auth/state_holders/email_code_state_holder.dart';
import 'package:poster_stock/features/auth/state_holders/sign_up_username_error_state_holder.dart';

import '../state_holders/name_state_holder.dart';
import '../state_holders/username_state_holder.dart';

final signUpControllerProvider = Provider<SignUpController>(
  (ref) => SignUpController(
    usernameErrorState:
        ref.watch(signUpUsernameErrorStateHolderProvider.notifier),
    nameState: ref.watch(nameStateHolderProvider.notifier),
    usernameState: ref.watch(usernameStateHolderProvider.notifier),
    codeState: ref.watch(emailCodeStateHolderProvider.notifier),
  ),
);

class SignUpController {
  final SignUpUsernameErrorStateHolder usernameErrorState;
  final NameStateHolder nameState;
  final UsernameStateHolder usernameState;
  final EmailCodeStateHolder codeState;

  SignUpController({
    required this.usernameErrorState,
    required this.nameState,
    required this.usernameState,
    required this.codeState,
  });

  void setWrongSymbolsErrorUsername() {
    usernameErrorState.updateState('Symbols cannot be used');
  }

  void removeUsernameError() {
    usernameErrorState.clearState();
  }

  void setCode(String value) {
    codeState.updateState(value);
  }

  void removeCode() {
    codeState.clearState();
  }

  void setName(String value) {
    nameState.updateState(value);
  }

  void setUsername(String value) {
    usernameState.updateState(value);
  }
}
