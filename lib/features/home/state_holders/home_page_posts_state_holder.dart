import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:poster_stock/features/home/models/post_base_model.dart';

final homePagePostsStateHolderProvider =
    StateNotifierProvider<HomePagePostsStateHolder, List<PostBaseModel>?>(
  (ref) => HomePagePostsStateHolder(null),
);

class HomePagePostsStateHolder extends StateNotifier<List<PostBaseModel>?> {
  HomePagePostsStateHolder(super.state);

  void updateState(List<PostBaseModel> posts) {
    if (state == null) {
      state = posts;
    } else {
      state = [...posts, ...state!];
    }
  }
}
