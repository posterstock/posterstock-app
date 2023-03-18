import 'package:flutter_riverpod/flutter_riverpod.dart';

final authLoadingStateHolderProvider =
    StateNotifierProvider<AuthLoadingStateHolder, LoadingStates>(
  (ref) => AuthLoadingStateHolder(
    LoadingStates(
      loadingApple: false,
      loadingGoogle: false,
    ),
  ),
);

class AuthLoadingStateHolder extends StateNotifier<LoadingStates> {
  AuthLoadingStateHolder(LoadingStates loadingState) : super(loadingState);

  void loadGoogle() {
    state = LoadingStates(
      loadingApple: false,
      loadingGoogle: true,
    );
  }

  void loadApple() {
    state = LoadingStates(
      loadingApple: true,
      loadingGoogle: false,
    );
  }

  void stopLoading() {
    state = LoadingStates(
      loadingApple: false,
      loadingGoogle: false,
    );
  }
}

class LoadingStates {
  bool loadingApple;
  bool loadingGoogle;

  LoadingStates({required this.loadingApple, required this.loadingGoogle});
}
