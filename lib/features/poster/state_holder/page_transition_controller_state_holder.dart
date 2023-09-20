import 'package:flutter/animation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final pageTransitionControllerStateHolder =
StateNotifierProvider<PosterStateHolder, AnimationController?>(
      (ref) => PosterStateHolder(null),
);

class PosterStateHolder extends StateNotifier<AnimationController?> {
  PosterStateHolder(super.state);

  Future<void> updateState(AnimationController? controller) async {
    state = controller;
  }

}