import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:poster_stock/features/home/models/post_movie_model.dart';
import 'package:poster_stock/features/home/models/user_model.dart';
import 'package:poster_stock/features/home/state_holders/home_page_posts_state_holder.dart';
import 'package:poster_stock/features/profile/repository/i_profile_repository.dart';
import 'package:poster_stock/features/profile/state_holders/my_profile_info_state_holder.dart';
import 'package:poster_stock/features/profile/state_holders/profile_bookmarks_state_holder.dart';
import 'package:poster_stock/features/profile/state_holders/profile_lists_state_holder.dart';
import 'package:poster_stock/features/profile/state_holders/profile_posts_state_holder.dart';

import '../repository/profile_repository.dart';
import '../state_holders/profile_info_state_holder.dart';

final profileControllerApiProvider = Provider<ProfileControllerApi>(
  (ref) => ProfileControllerApi(
    profileInfoStateHolder: ref.watch(profileInfoStateHolderProvider.notifier),
    profilePostsStateHolder:
        ref.watch(profilePostsStateHolderProvider.notifier),
    profileListsStateHolder:
        ref.watch(profileListsStateHolderProvider.notifier),
    homePagePostsStateHolder:
        ref.watch(homePagePostsStateHolderProvider.notifier),
    myProfileInfoStateHolder:
        ref.watch(myProfileInfoStateHolderProvider.notifier),
    profileBookmarksStateHolder:
        ref.watch(profileBookmarksStateHolderProvider.notifier),
  ),
);

class ProfileControllerApi {
  final IProfileRepository repo = ProfileRepository();
  final ProfileInfoStateHolder profileInfoStateHolder;
  final ProfilePostsStateHolder profilePostsStateHolder;
  final ProfileListsStateHolder profileListsStateHolder;
  final ProfileBookmarksStateHolder profileBookmarksStateHolder;
  final HomePagePostsStateHolder homePagePostsStateHolder;
  final MyProfileInfoStateHolder myProfileInfoStateHolder;
  dynamic gettingUser = 'profile';
  bool gttgUser = false;
  bool cancelled = false;
  bool gotAllBookmarks = false;
  bool gettingBookmarks = false;
  bool gotAllPosts = false;
  bool gettingPosts = false;
  late final CancelableCompleter completer;

  ProfileControllerApi({
    required this.profileInfoStateHolder,
    required this.profilePostsStateHolder,
    required this.profileListsStateHolder,
    required this.homePagePostsStateHolder,
    required this.myProfileInfoStateHolder,
    required this.profileBookmarksStateHolder,
  }) {
    completer = CancelableCompleter(onCancel: () {});
  }

  Future<void> clearUser() async {
    gettingUser = 'profile';
    gotAllBookmarks = false;
    await profileInfoStateHolder.clearState();
    await profilePostsStateHolder.clearState();
    await profileListsStateHolder.clearState();
  }

  Future<void> follow(int id, bool follow) async {
    profileInfoStateHolder.setFollow(!follow);
    homePagePostsStateHolder.setFollow(id, !follow);
    await repo.follow(id, !follow);
  }

  Future<void> updateBookmarks() async {
    if (gttgUser) return;
    if (gotAllBookmarks) return;
    if (gettingBookmarks) return;
        gettingBookmarks = true;
    var result = await repo.getMyBookmarks();
    final bookmarks = result.$1;
    gotAllBookmarks = result.$2;
    profileBookmarksStateHolder.updateState(bookmarks);
    gettingBookmarks = false;
  }

  Future<void> updatePosts(int id) async {
    if (gttgUser) return;
    if (gotAllPosts) return;
    if (gettingPosts) return;
    print("GGGGGG");
    gettingPosts = true;
    var result = await repo.getProfilePosts(id);
    final posts = result.$1;
    gotAllPosts = result.$2;
    print("UPDATING");
    print(posts);
    profilePostsStateHolder.updateState(posts);
    gettingPosts = false;
  }

  Future<void> getUserInfo(dynamic usernameOrId) async {
    print(usernameOrId);
    if (gettingUser == usernameOrId) return;
    gttgUser = true;
    try {
      completer.completeOperation(
        CancelableOperation.fromFuture(
          Future(() async {
            try {
              gotAllBookmarks = false;
              gettingUser = usernameOrId;
              final user = await repo.getProfileInfo(usernameOrId);
              var postsResponse = await repo.getProfilePosts(user.id, restart: true);
              var posts = postsResponse.$1;
              gotAllPosts = postsResponse.$2;
              var lists = await repo.getProfileLists(user.id);
              List<PostMovieModel>? bookmarks;
              if (usernameOrId == null) {
                var result = await repo.getMyBookmarks(restart: true);
                bookmarks = result.$1;
                gotAllBookmarks = result.$2;
              }
              if (gettingUser != usernameOrId) return;
              lists = lists
                ?.map(
                    (e) => e = e.copyWith(
                      user: UserModel(
                        id: user.id,
                        name: user.name,
                        username: user.username,
                        imagePath: user.imagePath,
                        followed: user.followed,
                      ),
                    ),
                  )
                  .toList();
              posts = posts
                  ?.map(
                    (e) => e = e.copyWith(
                      author: UserModel(
                        id: user.id,
                        name: user.name,
                        username: user.username,
                        imagePath: user.imagePath,
                        followed: user.followed,
                      ),
                    ),
                  )
                  .toList();
              if (usernameOrId == null) {
                myProfileInfoStateHolder.updateState(user);
              } else {
                profileBookmarksStateHolder.updateState(null);
                gotAllBookmarks = false;
              }
              profileInfoStateHolder.updateState(user);
              print("SETTING");
              profilePostsStateHolder.setState(posts);
              profileListsStateHolder.setState(lists);
              profileBookmarksStateHolder.setState(bookmarks);
              if (gettingUser != usernameOrId) {
                clearUser();
              }
              //print(profilePostsStateHolder.state);
              gettingUser = 'profile';
              gttgUser = false;
            } catch (e) {
              gettingUser = 'profile';
              gttgUser = false;
            }
          }),
        ),
      );
    } catch (e) {}
  }
}
