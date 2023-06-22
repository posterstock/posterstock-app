import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final pickCoverGalleryStateHolderProvider =
    StateNotifierProvider<PickCoverGalleryStateHolder, List<Uint8List>>(
  (ref) => PickCoverGalleryStateHolder([]),
);

class PickCoverGalleryStateHolder extends StateNotifier<List<Uint8List>> {
  PickCoverGalleryStateHolder(super.state);

  void addElement(Uint8List image) {
    state = [...state, image];
  }

}
