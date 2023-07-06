import 'package:flutter_riverpod/flutter_riverpod.dart';

final editProfileNameStateHolder =
StateNotifierProvider<EditProfileNameStateHolder, String?>(
      (ref) => EditProfileNameStateHolder(
    null,
  ),
);

class EditProfileNameStateHolder extends StateNotifier<String?> {
  EditProfileNameStateHolder(super.state);

  void updateError(String value) {
    state = value;
  }

  void clearError() {
    state = null;
  }
}
