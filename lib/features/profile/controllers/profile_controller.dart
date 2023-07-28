import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:poster_stock/common/state_holders/auth_token_state_holder.dart';
import 'package:poster_stock/features/profile/repository/i_profile_repository.dart';

import '../repository/profile_repository.dart';
import '../state_holders/profile_info_state_holder.dart';

final profileControllerProvider = Provider<ProfileController>(
  (ref) => ProfileController(
    profileInfoStateHolder: ref.watch(profileInfoStateHolderProvider.notifier),
    token: ref.watch(authTokenStateHolderProvider)!,
  ),
);

class ProfileController {
  final IProfileRepository repo = ProfileRepository();
  final ProfileInfoStateHolder profileInfoStateHolder;
  final String? token;

  ProfileController({
    required this.profileInfoStateHolder,
    required this.token,
  });

  Future<void> getUserPosts() async {}

  Future<void> getUserLists() async {}

  Future<void> getUserInfo(int id) async {
    profileInfoStateHolder.updateState(await repo.getProfileInfo(token!, id));
  }
}
