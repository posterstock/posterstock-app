import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:poster_stock/features/create_list/state_holders/chosen_cover_state_holder.dart';
import 'package:poster_stock/features/create_list/state_holders/pick_cover_gallery_state_holder.dart';

final pickCoverControllerProvider = Provider<PickCoverController>(
  (ref) => PickCoverController(
    allImagesStateHolder:
        ref.watch(pickCoverGalleryStateHolderProvider.notifier),
    chosenCoverStateHolder: ref.watch(chosenCoverStateHolderProvider.notifier),
  ),
);

class PickCoverController {
  final PickCoverGalleryStateHolder allImagesStateHolder;
  final ChosenCoverStateHolder chosenCoverStateHolder;

  PickCoverController({
    required this.allImagesStateHolder,
    required this.chosenCoverStateHolder,
  });

  Future<void> setImage(Uint8List image) async {
    chosenCoverStateHolder.setImage(image);
  }

  Future<void> removeImage() async {
    chosenCoverStateHolder.setImage(null);
  }
}
