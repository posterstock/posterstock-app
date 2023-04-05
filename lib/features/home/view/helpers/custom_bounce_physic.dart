import 'dart:math' as math;

import 'package:flutter/cupertino.dart';

class CustomBouncePhysic extends BouncingScrollPhysics {
  CustomBouncePhysic({
    super.decelerationRate = ScrollDecelerationRate.normal,
    super.parent,
    this.disableSwipeRight = false,
  });

  final bool disableSwipeRight;
  final BoolValueKeeper tryGoRight = BoolValueKeeper(false);

  @override
  double frictionFactor(double overscrollFraction) {
    return 2.0 * math.pow(1 - overscrollFraction, 2);
  }

  @override
  double applyPhysicsToUserOffset(ScrollMetrics position, double offset) {
    if (disableSwipeRight) {
      tryGoRight.value = offset.sign < 0;
    }
    return super.applyPhysicsToUserOffset(position, offset);
  }

  @override
  double applyBoundaryConditions(ScrollMetrics position, double value) {
    if (tryGoRight.value && position.pixels > 71 && position.pixels < 74) {
      return value - position.pixels;
    }
    return super.applyBoundaryConditions(position, value);
  }

  @override
  BouncingScrollPhysics applyTo(ScrollPhysics? ancestor) {
    return CustomBouncePhysic(
      parent: buildParent(ancestor),
      decelerationRate: decelerationRate,
      disableSwipeRight: disableSwipeRight,
    );
  }
}

class BoolValueKeeper {
  bool value;

  BoolValueKeeper(this.value);
}
