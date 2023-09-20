import 'package:flutter_riverpod/flutter_riverpod.dart';

final listSearchValueStateHolderProvider =
StateNotifierProvider<ListSearchValueStateHolder, String>(
      (ref) => ListSearchValueStateHolder(''),
);

class ListSearchValueStateHolder extends StateNotifier<String> {
  ListSearchValueStateHolder(super.state);

  void updateState(String value) {
    state = value;
  }

  Future<void> clearState() async {
    state = '';
  }
}
