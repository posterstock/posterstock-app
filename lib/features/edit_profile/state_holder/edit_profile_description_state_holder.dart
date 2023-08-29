import 'package:flutter_riverpod/flutter_riverpod.dart';

final editProfileDescriptionStateHolder =
StateNotifierProvider<EditProfileDescriptionStateHolder, String?>(
      (ref) => EditProfileDescriptionStateHolder(
    null,
  ),
);

class EditProfileDescriptionStateHolder extends StateNotifier<String?> {
  EditProfileDescriptionStateHolder(super.state);

  void updateValue(String value) {
    state = value;
  }

  void clearValue() {
    state = null;
  }
}