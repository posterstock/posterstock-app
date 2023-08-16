import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:poster_stock/features/home/models/post_base_model.dart';
import 'package:poster_stock/features/home/state_holders/home_page_likes_state_holder.dart';

final homePagePostsStateHolderProvider =
    StateNotifierProvider<HomePagePostsStateHolder, List<List<PostBaseModel>>?>(
  (ref) => HomePagePostsStateHolder(
    null,
  ),
);

class HomePagePostsStateHolder
    extends StateNotifier<List<List<PostBaseModel>>?> {
  HomePagePostsStateHolder(
    super.state,
  );

  Future<void> updateState(List<List<PostBaseModel>>? posts) async {
    for (int i = 0; i < (posts?.length ?? 0); i++) {
      for (int j = 0; j < (posts?.length ?? 0); j++) {
        if (i == j) continue;
        if (posts![i][0].author.id == posts[j][0].author.id &&
            posts[i][0].timeDate.difference(posts[j][0].timeDate).inDays < 1) {
          posts[i].add(posts[j][0]);
          posts.removeAt(j);
          j = 0;
          i = 0;
        }
      }
    }
    for (int i = 0; i < (posts?.length ?? 0); i++) {
      posts?[i].sort((first, second) {
        return first.timeDate.isAfter(second.timeDate) ? 1 : -1;
      });
    }
    if (state == null) {
      state = posts;
    } else {
      if (state != null && posts != null) {
        for (var statePost in posts) {
          for (var st in statePost) {
            state!
                .map((e) => e.removeWhere((element) {
                      return element.id == st.id;
                    }))
                .toList();
          }
        }
      }
      if (posts == null || posts.isEmpty) return;
      state = [...posts, ...state!];
    }
  }

  Future<void> setLike(int index, int index2) async {
    state?[index][index2] = (state?[index][index2].copyWith(
        liked: state?[index][index2].liked == false ? true : false,
        likes: state?[index][index2].liked == false
            ? (state?[index][index2].likes ?? 0) + 1
            : (state?[index][index2].likes ?? 0) - 1))!;
    state = [...?state];
  }

  Future<void> setLikeId(int id, bool value) async {
    for (int i = 0; i < (state?.length ?? 0); i++) {
      for (int j = 0; j < (state?[i].length ?? 0); j++) {
        if (state![i][j].id == id) {
          print("ABOBA");
          print(value);
          var likes = state![i][j].likes;
          state![i][j] = state![i][j]
              .copyWith(liked: value, likes: value ? likes + 1 : likes - 1);
          state = [...?state];
          return;
        }
      }
    }
  }

  Future<void> setFollow(int id, bool follow) async {
    for (int i = 0; i < (state?.length ?? 0); i++) {
      for (int j = 0; j < (state?[i].length ?? 0); j++) {
        if (state![i][j].author.id == id) {
          if (!follow) {
            state?.removeAt(i);
          }
        }
      }
    }
    state = [...?state];
  }

  Future<void> addComment(int id) async {
    if (state == null) return;
    for (int i = 0; i < state!.length; i++) {
      for (int j = 0; j < state![i].length; j++) {
        if (state![i][j].id == id) {
          state![i][j] =
              state![i][j].copyWith(comments: state![i][j].comments + 1);
        }
      }
    }
    state = [...?state];
  }

  Future<void> updateStateEnd(List<List<PostBaseModel>>? posts) async {
    for (int i = 0; i < (posts?.length ?? 0); i++) {
      for (int j = 0; j < (posts?.length ?? 0); j++) {
        if (i == j) continue;
        if (posts![i][0].author.id == posts[j][0].author.id &&
            posts[i][0].timeDate.difference(posts[j][0].timeDate).inDays < 1) {
          posts[i].add(posts[j][0]);
          posts.removeAt(j);
          j = 0;
          i = 0;
        }
      }
    }
    for (int i = 0; i < (posts?.length ?? 0); i++) {
      posts?[i].sort((first, second) {
        return first.timeDate.isAfter(second.timeDate) ? 1 : -1;
      });
    }
    if (state == null) {
      state = posts;
    } else {
      if (posts == null) return;
      state = [...state!, ...posts];
    }
  }
}
