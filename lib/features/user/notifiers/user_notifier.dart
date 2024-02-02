import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:poster_stock/features/profile/data/profile_service.dart';
import 'package:poster_stock/features/profile/models/user_details_model.dart';

final userNotifier = StateNotifierProvider.family
    .autoDispose<UserNotifier, UserDetailsModel?, int>(
  (ref, id) => UserNotifier(id).._load(),
);

class UserNotifier extends StateNotifier<UserDetailsModel?> {
  final int id;
  final network = ProfileService();

  UserNotifier(this.id) : super(null);

  UserDetailsModel get user => state!;

  void _load() async {
    final json = await network.getProfileInfo(id);
    state = UserDetailsModel.fromJson(json);
  }

  Future<void> toggleFollow() async {
    final newFollowed = !state!.followed;
    await network.follow(state!.id, newFollowed);
    state = state!.copyWith(followed: newFollowed);
  }
}
