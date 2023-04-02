import 'dart:math' as math;

import 'package:flutter/cupertino.dart';

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
  double applyPhysicsToUserOffset(ScrollMetrics position, double offset) {
    if (offset < 0 && disableSwipeRight) return 0;
    return super.applyPhysicsToUserOffset(position, offset);
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
