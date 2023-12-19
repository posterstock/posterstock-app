import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:poster_stock/common/data/exceptions.dart';
import 'package:poster_stock/common/data/token_keeper.dart';
import 'package:poster_stock/common/state_holders/intl_state_holder.dart';
import 'package:poster_stock/features/auth/repository/auth_repository.dart';
import 'package:poster_stock/features/auth/state_holders/auth_error_state_holder.dart';
import 'package:poster_stock/features/auth/state_holders/auth_loading_state_holder.dart';
import 'package:poster_stock/features/auth/state_holders/device_id_state_holder.dart';
import 'package:poster_stock/features/auth/state_holders/email_state_holder.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:poster_stock/features/auth/state_holders/session_id_state_holder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supertokens_flutter/supertokens.dart';

import 'package:poster_stock/main.dart' as main;

final authControllerProvider = Provider(
  (ref) => AuthController(
    loadingState: ref.watch(authLoadingStateHolderProvider.notifier),
    errorState: ref.watch(authErrorStateHolderProvider.notifier),
    emailState: ref.watch(emailStateHolderProvider.notifier),
    sessionIdState: ref.watch(sessionIdStateHolderProvider.notifier),
    deviceIdState: ref.watch(deviceIdStateHolderProvider.notifier),
    localizations: ref.watch(localizations),
  ),
);

class AuthController {
  final AuthErrorStateHolder errorState;
  final AuthLoadingStateHolder loadingState;
  final EmailStateHolder emailState;
  final SessionIdStateHolder sessionIdState;
  final DeviceIdStateHolder deviceIdState;
  final AppLocalizations? localizations;
  final AuthRepository repository = AuthRepository();

  AuthController({
    required this.loadingState,
    required this.errorState,
    required this.emailState,
    required this.sessionIdState,
    required this.deviceIdState,
    required this.localizations,
  });

  void loadEmail() {
    loadingState.loadEmail();
  }

  void loadGoogle() {
    loadingState.loadGoogle();
  }

  void loadApple() {
    loadingState.loadApple();
  }

  void stopLoading() {
    loadingState.stopLoading();
  }

  void setError() {
    errorState.updateState(localizations!.login_welcome_email_incorrect);
  }

  void removeError() {
    errorState.clearState();
  }

  Future<bool> _getRegistered(String email) async {
    return repository.getRegistered(email);
  }

  Future<bool?> setEmail(String email) async {
    emailState.updateState(email);
    bool registered = await _getRegistered(email);
    try {
      final response = await repository.signUpSendEmail(email);
      deviceIdState.updateState(response.$1);
      sessionIdState.updateState(response.$2);
      return registered;
    } on AlreadyHasAccountException catch (e) {
      errorState.updateState(e.message);
      return null;
    } catch (e) {
      errorState.updateState('An error occured');
      return null;
    }
  }

  Future<void> removeFCMToken() async {
    /*
    Если все таки нужно на бэке удалять токен, то всё расскоментировать и метод удаления FCM теокена в конец поставить!
     */
    await FirebaseMessaging.instance.deleteToken();
    // final userToken = await SuperTokens.getAccessToken();
    // if (userToken == null) return;
    // if (fcmToken == null) return;
    // await repository.removeFCMToken(fcmToken, userToken);
  }

  Future<void> registerNotification() async {
    final userToken = await SuperTokens.getAccessToken();
    if (userToken == null) throw Exception();
    try {
      //await removeFCMToken();
    } catch (e) {
      debugPrint(e.toString());
    }
    try {
      await repository.registerNotification(
          (await FirebaseMessaging.instance.getToken())!, userToken);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<bool> authApple({
    String? name,
    String? surname,
    String? email,
    String? code,
    String? state,
    String? clientId,
  }) async {
    await repository.authApple(
      name: name,
      surname: surname,
      email: email,
      code: code,
      clientId: clientId,
      state: state,
    );
    var instance = await SharedPreferences.getInstance();
    instance.setBool('apple', true);
    main.apple = true;
    TokenKeeper.token = await SuperTokens.getAccessToken();
    print(TokenKeeper.token);
    try {
      await registerNotification();
    } catch (e) {
      print(e);
    }
    return true;
  }

  Future<bool> authGoogle({
    String? accessToken,
    String? idToken,
    String? code,
    String? clientId,
    String? name,
    String? surname,
    String? email,
  }) async {
    await repository.authGoogle(
      accessToken: accessToken,
      idToken: idToken,
      code: code,
      clientId: clientId,
      name: name,
      surname: surname,
      email: email,
    );
    var instance = await SharedPreferences.getInstance();
    instance.setBool('google', true);
    main.google = true;
    TokenKeeper.token = await SuperTokens.getAccessToken();
    print(TokenKeeper.token);
    try {
      await registerNotification();
    } catch (e) {
      print(e);
    }
    return true;
  }
}
