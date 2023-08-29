import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final pickCoverGalleryStateHolderProvider =
    StateNotifierProvider<PickCoverGalleryStateHolder, List<String?>>(
  (ref) => PickCoverGalleryStateHolder([]),
);

class PickCoverGalleryStateHolder extends StateNotifier<List<String?>> {
  PickCoverGalleryStateHolder(super.state);

  void addElement(String? image) {
    state = [...state, image];
  }

  void addElements(List<String?> images, int start) {
    if (start == state.length) {
      state = [...state, ...images];
    } else if (start > state.length){
      int index = state.length;
      while (index != start) {
        state.add(null);
        index++;
      }
      state = [...state, ...images];
    } else {
      for (int i = start; i < images.length; i++) {
        if (state.length > i) {
          state[i] = images[i];
        } else {
          state.add(images[i]);
        }
      }
    }
  }

}
