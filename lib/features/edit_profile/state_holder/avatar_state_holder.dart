import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final avatarStateHolderProvider =
    StateNotifierProvider<AvatarStateHolder, Uint8List?>(
  (ref) => AvatarStateHolder(null),
);

class AvatarStateHolder extends StateNotifier<Uint8List?> {
  AvatarStateHolder(super.state);
  void setPhoto(Uint8List photo) {
    state = photo;
  }

  void removePhoto() {
    state = null;
  }
}
