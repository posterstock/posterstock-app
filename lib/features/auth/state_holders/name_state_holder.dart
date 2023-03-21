import 'package:flutter_riverpod/flutter_riverpod.dart';

final nameStateHolderProvider = StateNotifierProvider<NameStateHolder, String>(
  (ref) => NameStateHolder(),
);

class NameStateHolder extends StateNotifier<String> {
  NameStateHolder() : super('');

  void updateState(String name) {
    state = name;
  }

  void clearState() {
    state = '';
  }
}
