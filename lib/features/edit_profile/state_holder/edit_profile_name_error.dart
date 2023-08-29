import 'package:flutter_riverpod/flutter_riverpod.dart';

final editProfileNameErrorStateHolder =
StateNotifierProvider<EditProfileNameErrorStateHolder, String?>(
      (ref) => EditProfileNameErrorStateHolder(
    null,
  ),
);

class EditProfileNameErrorStateHolder extends StateNotifier<String?> {
  EditProfileNameErrorStateHolder(super.state);

  void updateError(String value) {
    state = value;
  }

  void clearError() {
    state = null;
  }
}
