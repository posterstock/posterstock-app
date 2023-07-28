import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:poster_stock/common/state_holders/intl_state_holder.dart';
import 'package:poster_stock/features/auth/repository/auth_repository.dart';
import 'package:poster_stock/features/auth/state_holders/auth_error_state_holder.dart';
import 'package:poster_stock/features/auth/state_holders/auth_loading_state_holder.dart';
import 'package:poster_stock/features/auth/state_holders/device_id_state_holder.dart';
import 'package:poster_stock/features/auth/state_holders/email_state_holder.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:poster_stock/features/auth/state_holders/session_id_state_holder.dart';

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

  Future<void> setEmail(String email) async {
    emailState.updateState(email);
    final response = await repository.sendEmail(email);
    deviceIdState.updateState(response.$1);
    sessionIdState.updateState(response.$2);
  }
}
