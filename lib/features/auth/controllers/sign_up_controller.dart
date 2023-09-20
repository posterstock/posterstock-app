import 'package:firebase_messaging/firebase_messaging.dart';
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
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supertokens_flutter/supertokens.dart';

import '../../../common/state_holders/intl_state_holder.dart';
import '../state_holders/name_state_holder.dart';
import '../state_holders/username_state_holder.dart';
import 'package:poster_stock/main.dart' as main;

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
    String? token;
    try {
      await repository.confirmCode(
        code: code,
        sessionId: sessionId,
        deviceId: deviceId,
        email: email
      );
      try {
        token = await FirebaseMessaging.instance.getToken();
      } catch (e) {
        print(e);
      }
    } catch (e) {
      codeErrorStateHolder.setValue("Wrong code");
    }
    if (token != null) {
      try {
        await registerNotification(token);
      } catch (e) {
        print(e);
      }
    }
    signUpLoadingStateHolder.setValue(false);
    var instance = await SharedPreferences.getInstance();
    instance.setString('email', email);
    main.email = email;
    return token != null;
  }

  Future<bool> processAuth() async {
    signUpLoadingStateHolder.setValue(true);
    String? token;
    try {
     await repository.confirmCode(
        code: code,
        sessionId: sessionId,
        deviceId: deviceId,
        name: name,
        login: username,
        email: email,
      );
     try {
       token = await FirebaseMessaging.instance.getToken();
     } catch (e) {
       print(e);
     }
    } catch (e) {
      codeErrorStateHolder.setValue("Wrong code");
    }
    if (token != null) {
      try {
        await registerNotification(token);
      } catch (e) {
        print(e);
      }
    }
    signUpLoadingStateHolder.setValue(false);
    var instance = await SharedPreferences.getInstance();
    instance.setString('email', email);
    main.email = email;
    return token != null;
  }

  Future<void> removeFCMToken() async {
    var fcmToken = await FirebaseMessaging.instance.getToken();
    final userToken = await SuperTokens.getAccessToken();
    if (userToken == null) return;
    if (fcmToken == null) return;
    await repository.removeFCMToken(fcmToken, userToken);
  }

  Future<void> registerNotification(String token) async {
    final userToken = await SuperTokens.getAccessToken();
    if (userToken == null) throw Exception();
    await repository.registerNotification(token, userToken);
  }
}
