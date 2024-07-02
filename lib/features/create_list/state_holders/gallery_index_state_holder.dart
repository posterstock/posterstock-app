import 'package:flutter_riverpod/flutter_riverpod.dart';

final galleryIndexStateHolderProvider =
    StateNotifierProvider<GalleryIndexStateHolder, int>(
  (ref) => GalleryIndexStateHolder(0),
);

class GalleryIndexStateHolder extends StateNotifier<int> {
  GalleryIndexStateHolder(super.state);

  void setPage(int image) {
    state = image;
  }
}
