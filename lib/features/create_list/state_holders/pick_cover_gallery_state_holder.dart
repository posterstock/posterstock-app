import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:photo_manager/photo_manager.dart';

final pickCoverGalleryStateHolderProvider =
    StateNotifierProvider<PickCoverGalleryStateHolder, List<AssetEntity?>>(
  (ref) => PickCoverGalleryStateHolder([]),
);

class PickCoverGalleryStateHolder extends StateNotifier<List<AssetEntity?>> {
  PickCoverGalleryStateHolder(super.state);

  void addElement(AssetEntity? image) {
    state = [...state, image];
  }

  void addElements(List<AssetEntity?> images) {
    state = [...state, ...images];
  }

}
