import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:poster_stock/features/profile/data/profile_service.dart';
import 'package:poster_stock/features/profile/models/user_details_model.dart';
import 'package:poster_stock/features/user/user_cache.dart';

final userNotifier = StateNotifierProvider.family
    .autoDispose<UserNotifier, UserDetailsModel?, dynamic>(
  (ref, id) => UserNotifier(id)..load(),
);

class UserNotifier extends StateNotifier<UserDetailsModel?> {
  final dynamic id;
  final network = ProfileService();
  final UserCache cache = UserCache();

  UserNotifier(this.id) : super(null);

  UserDetailsModel get user => state!;

  Future<void> load() async {
    print('start');
    int curId = 0;
    if (id is String) {
      final json = await network.getProfileInfo(id);
      curId = json['id'];
    } else if (id is int) {
      curId = id;
    }
    final cachedResult = await cache.getProfileInfo(curId);
    if (cachedResult != null) {
      state = cachedResult;
      final json = await network.getProfileInfo(id);
      state = UserDetailsModel.fromJson(json.cast<String, dynamic>());
      if (state != null) {
        cache.cacheUserInfo(id, state!);
      }
    }
  }

  Future<void> toggleFollow() async {
    final newFollowed = !state!.followed;
    await network.follow(state!.id, newFollowed);
    state = state!.copyWith(followed: newFollowed);
  }
}
