import 'dart:math' as math;

import 'package:flutter/material.dart';

class HorizontalBlockedScrollPhysics extends ScrollPhysics {
  final bool blockLeftMovement;

  final bool blockRightMovement;

  const HorizontalBlockedScrollPhysics({
    ScrollPhysics parent = const CustomBouncePhysic(),
    this.blockLeftMovement = false,
    this.blockRightMovement = false,
  }) : super(parent: parent);

  @override
  HorizontalBlockedScrollPhysics applyTo(ScrollPhysics? ancestor) {
    return HorizontalBlockedScrollPhysics(
      parent: buildParent(ancestor)!,
      blockLeftMovement: blockLeftMovement,
      blockRightMovement: blockRightMovement,
    );
  }

  @override
  double applyBoundaryConditions(ScrollMetrics position, double value) {
    assert(() {
      if (value == position.pixels) {
        throw FlutterError(
            '$runtimeType.applyBoundaryConditions() was called redundantly.\n'
            'The proposed new position, $value, is exactly equal to the current position of the '
            'given ${position.runtimeType}, ${position.pixels}.\n'
            'The applyBoundaryConditions method should only be called when the value is '
            'going to actually change the pixels, otherwise it is redundant.\n'
            'The physics object in question was:\n'
            '  $this\n'
            'The position object in question was:\n'
            '  $position\n');
      }
      return true;
    }());

    if (position.maxScrollExtent <= position.pixels &&
        position.pixels < value) {
      // overscroll
      return value - position.pixels;
    }

    if (value < position.minScrollExtent &&
        position.minScrollExtent < position.pixels) {
      // hit top edge
      return value - position.minScrollExtent;
    }

    if (position.pixels < position.maxScrollExtent &&
        position.maxScrollExtent < value) {
      // hit bottom edge
      return value - position.maxScrollExtent;
    }

    // If true, movement goes to the left. If it's a swipe, it goes to the left.
    var isMovingLeft = value > position.pixels;
    var screenIndex = (value / position.viewportDimension).floor();
    var pointInScreen = value - (screenIndex * position.viewportDimension);
    // If true, the middle point of the screen is in the left side of the screen.
    // This will be useful in order to not block some movements when in returning position.
    var isPointInScreenLeftRange =
        pointInScreen < (position.viewportDimension / 2);
    var delta = value - position.pixels;

    // We're moving left and we want to block.
    if (isMovingLeft && blockLeftMovement && isPointInScreenLeftRange) {
      if (pointInScreen.abs() < delta.abs()) {
        // fix for strong movements
        return pointInScreen;
      }
      return delta;
    }

    // We're moving right and we want to block.
    if (!isMovingLeft && blockRightMovement && !isPointInScreenLeftRange) {
      return delta;
    }

    return super.applyBoundaryConditions(position, value);
  }
}

/// This [ScrollPhysics] blocks the left movement in the horizontal axis allowing only movements to the right.
///
/// {@tool sample}
///
/// This sample shows a [LeftBlockedScrollPhysics] blocking left movement
///
/// ```dart
/// LeftBlockedScrollPhysics();
/// ```
/// {@end-tool}
class LeftBlockedScrollPhysics extends HorizontalBlockedScrollPhysics {
  const LeftBlockedScrollPhysics({
    ScrollPhysics parent = const CustomBouncePhysic(),
  }) : super(parent: parent, blockLeftMovement: true);

  @override
  LeftBlockedScrollPhysics applyTo(ScrollPhysics? ancestor) {
    return LeftBlockedScrollPhysics(
      parent: buildParent(ancestor)!,
    );
  }
}

// This [ScrollPhysics] blocks the right movement in the horizontal axis allowing only movements to the left.
///
/// {@tool sample}
///
/// This sample shows a [RightBlockedScrollPhysics] blocking right movement
///
/// ```dart
/// RightBlockedScrollPhysics();
/// ```
/// {@end-tool}
class RightBlockedScrollPhysics extends HorizontalBlockedScrollPhysics {
  const RightBlockedScrollPhysics({
    ScrollPhysics parent = const CustomBouncePhysic(),
  }) : super(parent: parent, blockRightMovement: true);

  @override
  RightBlockedScrollPhysics applyTo(ScrollPhysics? ancestor) {
    return RightBlockedScrollPhysics(
      parent: buildParent(ancestor)!,
    );
  }
}

class CustomBouncePhysic extends BouncingScrollPhysics {
  const CustomBouncePhysic({
    super.decelerationRate = ScrollDecelerationRate.normal,
    super.parent,
    this.disableSwipeRight = false,
  });

  final bool disableSwipeRight;

  @override
  double frictionFactor(double overscrollFraction) {
    return 2.0 * math.pow(1 - overscrollFraction, 2);
  }

  @override
  BouncingScrollPhysics applyTo(ScrollPhysics? ancestor) {
    return CustomBouncePhysic(
      parent: buildParent(ancestor),
      decelerationRate: decelerationRate,
    );
  }
}
