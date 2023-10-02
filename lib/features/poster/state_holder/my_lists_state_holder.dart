import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:poster_stock/features/home/models/list_base_model.dart';
import 'package:poster_stock/features/home/models/multiple_post_model.dart';

final myListsStateHolderProvider =
StateNotifierProvider<MyListsStateHolder, List<ListBaseModel>?>(
      (ref) => MyListsStateHolder(null),
);

class MyListsStateHolder extends StateNotifier<List<ListBaseModel>?> {
  MyListsStateHolder(super.state);

  Future<void> updateLists(List<ListBaseModel>? lists) async {
    state = [...?lists];
  }

  Future<void> clear() async {
    state = null;
  }
}
