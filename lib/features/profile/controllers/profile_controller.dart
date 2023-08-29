import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:poster_stock/features/home/models/user_model.dart';
import 'package:poster_stock/features/home/state_holders/home_page_posts_state_holder.dart';
import 'package:poster_stock/features/profile/repository/i_profile_repository.dart';
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
  ),
);

class ProfileControllerApi {
  final IProfileRepository repo = ProfileRepository();
  final ProfileInfoStateHolder profileInfoStateHolder;
  final ProfilePostsStateHolder profilePostsStateHolder;
  final ProfileListsStateHolder profileListsStateHolder;
  final HomePagePostsStateHolder homePagePostsStateHolder;
  dynamic gettingUser = 'profile';
  bool cancelled = false;
  late final CancelableCompleter completer;

  ProfileControllerApi({
    required this.profileInfoStateHolder,
    required this.profilePostsStateHolder,
    required this.profileListsStateHolder,
    required this.homePagePostsStateHolder,
  }) {
    completer = CancelableCompleter(onCancel: () {});
  }

  Future<void> clearUser() async {
    gettingUser = 'profile';
    await profileInfoStateHolder.clearState();
    await profilePostsStateHolder.clearState();
    await profileListsStateHolder.clearState();
    print("cleared");
  }

  Future<void> follow(int id, bool follow) async {
    profileInfoStateHolder.setFollow(!follow);
    homePagePostsStateHolder.setFollow(id, !follow);
    await repo.follow(id, !follow);
  }

  Future<void> getUserInfo(dynamic usernameOrId) async {
    if (gettingUser == usernameOrId) return;
    try {
      completer.completeOperation(
        CancelableOperation.fromFuture(
          Future(() async {
            try {
              gettingUser = usernameOrId;
              final user = await repo.getProfileInfo(usernameOrId);
              var posts = await repo.getProfilePosts(user.id);
              var lists = await repo.getProfileLists(user.id);
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
              profileInfoStateHolder.updateState(user);
              profilePostsStateHolder.setState(posts);
              profileListsStateHolder.setState(lists);
              if (gettingUser != usernameOrId)  {
                clearUser();
              }
              //print(profilePostsStateHolder.state);
              gettingUser = 'profile';
            } catch (e) {
              gettingUser = 'profile';
            }
          }),
        ),
      );
    } catch (e) {

    }
  }
}
