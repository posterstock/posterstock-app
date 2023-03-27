import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:poster_stock/features/auth/state_holders/auth_error_state_holder.dart';
import 'package:poster_stock/features/auth/state_holders/auth_loading_state_holder.dart';
import 'package:poster_stock/features/auth/state_holders/email_state_holder.dart';

final authControllerProvider = Provider(
  (ref) => AuthController(
    loadingState: ref.watch(authLoadingStateHolderProvider.notifier),
    errorState: ref.watch(authErrorStateHolderProvider.notifier),
    emailState: ref.watch(emailStateHolderProvider.notifier),
  ),
);

class AuthController {
  final AuthErrorStateHolder errorState;
  final AuthLoadingStateHolder loadingState;
  final EmailStateHolder emailState;

  AuthController({
    required this.loadingState,
    required this.errorState,
    required this.emailState,
  });

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
    errorState.updateState('Wrong email');
  }

  void removeError() {
    errorState.clearState();
  }

  void setEmail(String email) {
    emailState.updateState(email);
  }
}
