import 'package:flutter_riverpod/flutter_riverpod.dart';

final editProfileLoadingStateHolder =
StateNotifierProvider<EditProfileLoadingStateHolder, bool>(
      (ref) => EditProfileLoadingStateHolder(
    false,
  ),
);

class EditProfileLoadingStateHolder extends StateNotifier<bool> {
  EditProfileLoadingStateHolder(super.state);

  void updateValue(bool value) {
    state = value;
  }

  void clearValue() {
    state = false;
  }
}