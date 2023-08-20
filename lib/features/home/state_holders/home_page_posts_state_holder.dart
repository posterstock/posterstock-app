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

  Future<void> updateState(List<PostBaseModel>? posts) async {
    if (posts == null) {
      return;
    }
    List<List<PostBaseModel>>? newState = [];
    for (int i = 0; i < posts.length; i++) {
      newState.add([posts[i]]);
      for (int j = i + 1; j < posts.length; j++) {
        if (posts[i].author.username == posts[j].author.username) {
          for (var post in newState[i]) {
            if (post.timeDate.difference(posts[j].timeDate).inHours.abs() <
                25) {
              newState[i].add(posts[j]);
              posts.removeAt(j);
              j--;
              break;
            }
          }
        }
      }
    }
    for (int i = 0; i < newState.length; i++) {
      newState[i].sort((first, second) {
        return first.timeDate.isAfter(second.timeDate) ? -1 : 1;
      });
    }
    if (state == null) {
      state = newState;
    } else {
      if (state != null) {
        for (var statePost in newState) {
          for (var st in statePost) {
            for (int i = 0; i < (state?.length ?? 0); i++) {
              for (int j = 0; j < (state?[i].length ?? 0); j++) {
                if (state![i][j].id == st.id) {
                  state![i].removeAt(j);
                  j--;
                }
              }
              if (state![i].isEmpty) {
                state!.removeAt(i);
                i--;
              }
            }
          }
        }
      }
      state = [...newState, ...?state];
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
            i--;
          } else {
            state![i][j] = state![i][j].copyWith(
              author: state![i][j].author.copyWith(
                    followed: true,
                  ),
            );
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

  Future<void> updateStateEnd(List<PostBaseModel>? posts) async {
    if (posts == null) {
      return;
    }
    List<List<PostBaseModel>>? newState = [];
    for (int i = 0; i < posts.length; i++) {
      newState.add([posts[i]]);
      for (int j = i + 1; j < posts.length; j++) {
        if (posts[i].author.username == posts[j].author.username) {
          for (var post in newState[i]) {
            if (post.timeDate.difference(posts[j].timeDate).inHours.abs() <
                25) {
              print(
                  'suc${post.name} ${posts[j].name} ${post.timeDate} ${posts[j].timeDate} ${post.time} ${posts[j].time} ${post.timeDate.difference(posts[j].timeDate).inHours.abs()}');
              newState[i].add(posts[j]);
              posts.removeAt(j);
              j--;
              break;
            } else {
              print(
                  '${post.name} ${posts[j].name} ${post.timeDate} ${posts[j].timeDate} ${post.time} ${posts[j].time} ${post.timeDate.difference(posts[j].timeDate).inHours.abs()}');
            }
          }
        }
      }
    }
    for (int i = 0; i < newState.length; i++) {
      newState[i].sort((first, second) {
        return first.timeDate.isAfter(second.timeDate) ? -1 : 1;
      });
    }
    if (state == null) {
      state = newState;
    } else {
      if (state != null) {
        for (var statePost in newState) {
          for (var st in statePost) {
            for (int i = 0; i < (state?.length ?? 0); i++) {
              for (int j = 0; j < (state?[i].length ?? 0); j++) {
                if (state![i][j].id == st.id) {
                  state![i].removeAt(j);
                  j--;
                }
              }
              if (state![i].isEmpty) {
                state!.removeAt(i);
                i--;
              }
            }
          }
        }
      }
      state = [...?state, ...newState];
    }
  }
}
