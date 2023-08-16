import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:poster_stock/common/state_holders/auth_id_state_holder.dart';
import 'package:poster_stock/features/auth/repository/auth_repository.dart';
import 'package:poster_stock/features/auth/state_holders/code_error_state_holder.dart';
import 'package:poster_stock/features/auth/state_holders/device_id_state_holder.dart';
import 'package:poster_stock/features/auth/state_holders/email_code_state_holder.dart';
import 'package:poster_stock/features/auth/state_holders/email_state_holder.dart';
import 'package:poster_stock/features/auth/state_holders/session_id_state_holder.dart';
import 'package:poster_stock/features/auth/state_holders/sign_up_loading_state_holder.dart';
import 'package:poster_stock/features/auth/state_holders/sign_up_name_error_state_holdeer.dart';
import 'package:poster_stock/features/auth/state_holders/sign_up_username_error_state_holder.dart';
import 'package:supertokens_flutter/supertokens.dart';

import '../../../common/state_holders/intl_state_holder.dart';
import '../state_holders/name_state_holder.dart';
import '../state_holders/username_state_holder.dart';

final signUpControllerProvider = Provider<SignUpController>(
  (ref) => SignUpController(
    usernameErrorState:
        ref.watch(signUpUsernameErrorStateHolderProvider.notifier),
    signUpLoadingStateHolder: ref.watch(signupLoadingStateHolderProvider.notifier),
    nameErrorState: ref.watch(signUpNameErrorStateHolderProvider.notifier),
    nameState: ref.watch(nameStateHolderProvider.notifier),
    usernameState: ref.watch(usernameStateHolderProvider.notifier),
    codeState: ref.watch(emailCodeStateHolderProvider.notifier),
    authIdStateHolder: ref.watch(authIdStateHolderProvider.notifier),
    localizations: ref.watch(localizations),
    username: ref.watch(usernameStateHolderProvider),
    name: ref.watch(nameStateHolderProvider),
    code: ref.watch(emailCodeStateHolderProvider),
    email: ref.watch(emailStateHolderProvider) ?? '',
    sessionId: ref.watch(sessionIdStateHolderProvider),
    deviceId: ref.watch(deviceIdStateHolderProvider),
    codeErrorStateHolder: ref.watch(codeErrorStateHolderProvider.notifier),
  ),
);

class SignUpController {
  final SignUpUsernameErrorStateHolder usernameErrorState;
  final CodeErrorStateHolder codeErrorStateHolder;
  final SignUpLoadingStateHolder signUpLoadingStateHolder;
  final SignUpNameErrorStateHolder nameErrorState;
  final NameStateHolder nameState;
  final UsernameStateHolder usernameState;
  final EmailCodeStateHolder codeState;
  final AuthIdStateHolder authIdStateHolder;
  final AppLocalizations? localizations;
  final AuthRepository repository = AuthRepository();
  final String username;
  final String name;
  final String code;
  final String email;
  final String sessionId;
  final String deviceId;

  SignUpController({
    required this.usernameErrorState,
    required this.signUpLoadingStateHolder,
    required this.codeErrorStateHolder,
    required this.nameErrorState,
    required this.nameState,
    required this.usernameState,
    required this.codeState,
    required this.authIdStateHolder,
    required this.localizations,
    required this.username,
    required this.name,
    required this.code,
    required this.email,
    required this.sessionId,
    required this.deviceId,
  });

  void setWrongSymbolsErrorUsername() {
    usernameErrorState.updateState(localizations!.invalidSymbols);
  }

  void removeUsernameError() {
    usernameErrorState.clearState();
  }

  void setTooLongErrorName() {
    nameErrorState.updateState(localizations!.nameCantExceed32);
  }

  void setTooLongErrorUserName() {
    usernameErrorState.updateState(localizations!.usernameCantExceed32);
  }

  void setTooShortErrorUserName() {
    usernameErrorState.updateState(localizations!.usernameMinLength5);
  }

  void removeNameError() {
    nameErrorState.clearState();
  }

  void setCode(String value) {
    codeState.updateState(value);
  }

  void removeCode() {
    codeState.clearState();
  }

  Future<void> setName(String value) async {
    await nameState.updateState(value);
  }

  Future<void> setUsername(String value) async {
    await usernameState.updateState(value);
  }

  Future<bool> processSignIn() async {
    codeErrorStateHolder.setValue(null);
    signUpLoadingStateHolder.setValue(true);
    try {
      await repository.confirmCode(
        code: code,
        sessionId: sessionId,
        deviceId: deviceId,
        email: email
      );
      signUpLoadingStateHolder.setValue(false);
      return true;
    } catch (e) {
      codeErrorStateHolder.setValue("Wrong code");
      signUpLoadingStateHolder.setValue(false);
      return false;
    }
  }

  Future<bool> processAuth() async {
    try {
     await repository.confirmCode(
        code: code,
        sessionId: sessionId,
        deviceId: deviceId,
        name: name,
        login: username,
        email: email,
      );
      //final int id = await repository.getId(token!);
      //await authIdStateHolder.updateState(id);
      return true;
    } catch (e) {
      return false;
    }
  }
}
