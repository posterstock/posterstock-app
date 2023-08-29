import 'package:flutter_riverpod/flutter_riverpod.dart';

final editProfileNameStateHolder =
StateNotifierProvider<EditProfileNameStateHolder, String?>(
      (ref) => EditProfileNameStateHolder(
    null,
  ),
);

class EditProfileNameStateHolder extends StateNotifier<String?> {
  EditProfileNameStateHolder(super.state);

  void updateValue(String value) {
    state = value;
  }

  void clearValue() {
    state = null;
  }
}
