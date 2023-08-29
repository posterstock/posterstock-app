import 'package:flutter_riverpod/flutter_riverpod.dart';

final editProfileUsernameStateHolder =
StateNotifierProvider<EditProfileUsernameStateHolder, String?>(
      (ref) => EditProfileUsernameStateHolder(
    null,
  ),
);

class EditProfileUsernameStateHolder extends StateNotifier<String?> {
  EditProfileUsernameStateHolder(super.state);

  void updateValue(String value) {
    state = value;
  }

  void clearValue() {
    state = null;
  }
}
