import 'package:flutter_riverpod/flutter_riverpod.dart';

final editProfileUsernameStateHolder =
    StateNotifierProvider<EditProfileUsernameStateHolder, String?>(
  (ref) => EditProfileUsernameStateHolder(
    null,
  ),
);

class EditProfileUsernameStateHolder extends StateNotifier<String?> {
  EditProfileUsernameStateHolder(super.state);

  void updateError(String value) {
    state = value;
  }

  void clearError() {
    state = null;
  }
}
