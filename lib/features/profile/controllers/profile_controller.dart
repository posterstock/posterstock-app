import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:poster_stock/features/profile/repository/i_profile_repository.dart';

import '../repository/profile_repository.dart';
import '../state_holders/profile_info_state_holder.dart';

final profileControllerProvider = Provider<ProfileController>(
  (ref) => ProfileController(
    profileInfoStateHolder: ref.watch(profileInfoStateHolderProvider.notifier),
  ),
);

class ProfileController {
  final IProfileRepository repo = ProfileRepository();
  final ProfileInfoStateHolder profileInfoStateHolder;

  ProfileController({required this.profileInfoStateHolder});

  Future<void> getUserPosts() async {}

  Future<void> getUserLists() async {}

  Future<void> getUserInfo() async {
    profileInfoStateHolder.updateState(await repo.getProfileInfo('a', 1));
  }
}
