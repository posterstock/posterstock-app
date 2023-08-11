import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:poster_stock/common/state_holders/intl_state_holder.dart';
import 'package:poster_stock/features/auth/repository/auth_repository.dart';
import 'package:poster_stock/features/auth/state_holders/auth_error_state_holder.dart';
import 'package:poster_stock/features/auth/state_holders/auth_loading_state_holder.dart';
import 'package:poster_stock/features/auth/state_holders/device_id_state_holder.dart';
import 'package:poster_stock/features/auth/state_holders/email_state_holder.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:poster_stock/features/auth/state_holders/session_id_state_holder.dart';
import 'package:supertokens_flutter/supertokens.dart';

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
    errorState.updateState(localizations!.emailError);
  }

  void removeError() {
    errorState.clearState();
  }

  Future<bool> _getRegistered(String email) async {
    return repository.getRegistered(email);
  }

  Future<bool> setEmail(String email) async {
    emailState.updateState(email);
    bool registered = await _getRegistered(email);
    final response = await repository.signUpSendEmail(email);
    deviceIdState.updateState(response.$1);
    sessionIdState.updateState(response.$2);
    return registered;
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
    return true;
  }

  Future<bool> authGoogle({
    String? accessToken,
    String? idToken,
    String? code,
  }) async {
    await repository.authGoogle(
      accessToken: accessToken,
      idToken: idToken,
      code: code,
    );
    return true;
  }
}
