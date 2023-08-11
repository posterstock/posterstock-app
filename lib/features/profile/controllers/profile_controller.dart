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
  bool gettingUser = false;

  ProfileControllerApi({
    required this.profileInfoStateHolder,
    required this.profilePostsStateHolder,
    required this.profileListsStateHolder,
    required this.homePagePostsStateHolder,
  });

  Future<void> getUserPosts() async {}

  Future<void> getUserLists() async {}

  Future<void> clearUser() async {
    profileInfoStateHolder.clearState();
    profilePostsStateHolder.clearState();
  }

  Future<void> follow(int id, bool follow) async {
    profileInfoStateHolder.setFollow(!follow);
    homePagePostsStateHolder.setFollow(id, !follow);
    await repo.follow(id, !follow);
  }

  Future<void> getUserInfo(int? id) async {
    if (gettingUser) return;
    try {
      gettingUser = true;
      final user = await repo.getProfileInfo(id);
      profileInfoStateHolder.updateState(user);
      var posts = await repo.getProfilePosts(user.id);
      var lists = await repo.getProfileLists(user.id);
      lists = lists
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
      profilePostsStateHolder.updateState(posts);
      profileListsStateHolder.updateState(lists);
      //print(profilePostsStateHolder.state);
      gettingUser = false;
    } catch (e) {
      gettingUser = false;
    }
    gettingUser = false;
  }
}
