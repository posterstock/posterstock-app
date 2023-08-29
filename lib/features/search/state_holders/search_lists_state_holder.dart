import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:poster_stock/features/home/models/list_base_model.dart';

final searchListsStateHolderProvider =
StateNotifierProvider<SearchListsStateHolder, List<ListBaseModel>?>(
      (ref) => SearchListsStateHolder(null),
);

class SearchListsStateHolder extends StateNotifier<List<ListBaseModel>?> {
  SearchListsStateHolder(super.state);

  void updateState(List<ListBaseModel>? newValue) {
    state = [...?state, ...?newValue];
  }

  void setState(List<ListBaseModel>? newValue) {
    state = newValue;
  }
}