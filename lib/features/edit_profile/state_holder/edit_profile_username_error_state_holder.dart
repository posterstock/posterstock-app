import 'package:flutter_riverpod/flutter_riverpod.dart';

final editProfileUsernameErrorStateHolder =
    StateNotifierProvider<EditProfileUsernameErrorStateHolder, String?>(
  (ref) => EditProfileUsernameErrorStateHolder(
    null,
  ),
);

class EditProfileUsernameErrorStateHolder extends StateNotifier<String?> {
  EditProfileUsernameErrorStateHolder(super.state);

  void updateError(String value) {
    state = value;
  }

  void clearError() {
    state = null;
  }
}
