import 'package:flutter_riverpod/flutter_riverpod.dart';

final emailStateHolderProvider = StateNotifierProvider<EmailStateHolder, String?>(
      (ref) => EmailStateHolder(null),
);

class EmailStateHolder extends StateNotifier<String?> {
  EmailStateHolder(String? email) : super(email);

  void updateState(String email) {
    state = email;
  }

  void clearState() {
    state = null;
  }
}
