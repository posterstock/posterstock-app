import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:poster_stock/features/home/models/multiple_post_model.dart';

final listsStateHolderProvider =
    StateNotifierProvider<ListStateHolder, MultiplePostModel?>(
  (ref) => ListStateHolder(null),
);

class ListStateHolder extends StateNotifier<MultiplePostModel?> {
  ListStateHolder(super.state);

  Future<void> updateState(MultiplePostModel? post) async {
    state = post;
  }

  Future<void> clear() async {
    state = null;
  }
}
