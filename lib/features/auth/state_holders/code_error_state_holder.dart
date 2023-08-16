import 'package:flutter_riverpod/flutter_riverpod.dart';

final codeErrorStateHolderProvider =
    StateNotifierProvider<CodeErrorStateHolder, String?>(
  (ref) => CodeErrorStateHolder(null),
);

class CodeErrorStateHolder extends StateNotifier<String?> {
  CodeErrorStateHolder(super.state);

  void setValue(String? value) {
    state = value;
  }
}
