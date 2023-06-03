import 'package:flutter_riverpod/flutter_riverpod.dart';

final searchValueStateHolderProvider =
StateNotifierProvider<SearchValueStateHolder, String>(
      (ref) => SearchValueStateHolder(''),
);

class SearchValueStateHolder extends StateNotifier<String> {
  SearchValueStateHolder(super.state);

  void updateState(String newValue) {
    state = newValue;
  }
}
