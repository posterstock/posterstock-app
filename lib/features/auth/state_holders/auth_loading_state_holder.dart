import 'package:flutter_riverpod/flutter_riverpod.dart';

final authLoadingStateHolderProvider =
    StateNotifierProvider<AuthLoadingStateHolder, LoadingStates>(
  (ref) => AuthLoadingStateHolder(
    LoadingStates(
      loadingApple: false,
      loadingGoogle: false,
      loadingEmail: false,
    ),
  ),
);

class AuthLoadingStateHolder extends StateNotifier<LoadingStates> {
  AuthLoadingStateHolder(LoadingStates loadingState) : super(loadingState);

  void loadGoogle() {
    state = LoadingStates(
      loadingApple: false,
      loadingGoogle: true,
      loadingEmail: false,
    );
  }

  void loadApple() {
    state = LoadingStates(
      loadingApple: true,
      loadingGoogle: false,
      loadingEmail: false,
    );
  }

  void loadEmail() {
    state = LoadingStates(
      loadingApple: false,
      loadingGoogle: false,
      loadingEmail: true,
    );
  }

  void stopLoading() {
    state = LoadingStates(
      loadingApple: false,
      loadingGoogle: false,
      loadingEmail: false,
    );
  }
}

class LoadingStates {
  bool loadingApple;
  bool loadingGoogle;
  bool loadingEmail;

  LoadingStates({
    required this.loadingApple,
    required this.loadingGoogle,
    required this.loadingEmail,
  });
}
