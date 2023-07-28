import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:poster_stock/features/home/models/post_base_model.dart';
import 'package:poster_stock/features/home/state_holders/home_page_likes_state_holder.dart';

final homePagePostsStateHolderProvider =
    StateNotifierProvider<HomePagePostsStateHolder, List<List<PostBaseModel>>?>(
  (ref) => HomePagePostsStateHolder(
    null,
    homePageLikesStateHolder:
        ref.watch(homePageLikesStateHolderProvider.notifier),
  ),
);

class HomePagePostsStateHolder
    extends StateNotifier<List<List<PostBaseModel>>?> {
  HomePagePostsStateHolder(super.state,
      {required this.homePageLikesStateHolder});

  final HomePageLikesStateHolder homePageLikesStateHolder;

  Future<void> updateState(List<List<PostBaseModel>>? posts) async {
    if (state == null) {
      state = posts;
    } else {
      if (state != null && posts != null) {
        for (var statePost in posts) {
          state!.removeWhere((element) => element[0].id == statePost[0].id);
        }
      }
      print("EEE$posts");
      state = [...?posts, ...state!];
      await homePageLikesStateHolder.setState(state?.map((e) => (e[0].liked, e[0].likes)).toList());
    }
  }

  Future<void> setLike(int index) async {
    state?[index][0] = (state?[index][0].copyWith(
        liked: state?[index][0].liked == false ? true : false,
        likes: state?[index][0].liked == false
            ? (state?[index][0].likes ?? 0) + 1
            : (state?[index][0].likes ?? 0) - 1))!;
    await homePageLikesStateHolder.setState(state?.map((e) => (e[0].liked, e[0].likes)).toList());
  }

  Future<void> updateStateEnd(List<List<PostBaseModel>>? posts) async {
    if (state == null) {
      state = posts;
    } else {
      state = [...state!, ...?posts];
    }
    await homePageLikesStateHolder.setState(state?.map((e) => (e[0].liked, e[0].likes)).toList());
  }
}
