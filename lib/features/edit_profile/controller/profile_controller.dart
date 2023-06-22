import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:poster_stock/features/edit_profile/state_holder/avatar_state_holder.dart';

final profileControllerProvider = Provider<ProfileController>(
  (ref) => ProfileController(
    avatarStateHolder: ref.watch(avatarStateHolderProvider.notifier),
  ),
);

class ProfileController {
  final AvatarStateHolder avatarStateHolder;

  ProfileController({
    required this.avatarStateHolder,
  });

  void setPhoto(Uint8List photo) {
    avatarStateHolder.setPhoto(photo);
  }

  void removePhoto() {
    avatarStateHolder.removePhoto();
  }
}
