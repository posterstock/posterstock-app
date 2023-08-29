import 'package:flutter_riverpod/flutter_riverpod.dart';

final editProfileDescriptionErrorStateHolder =
StateNotifierProvider<EditProfileDescriptionErrorStateHolder, bool>(
      (ref) => EditProfileDescriptionErrorStateHolder(
    false,
  ),
);

class EditProfileDescriptionErrorStateHolder extends StateNotifier<bool> {
  EditProfileDescriptionErrorStateHolder(super.state);

  void updateError(bool value) {
    state = value;
  }
}
