import 'dart:math' as math;

import 'package:flutter/cupertino.dart';

class CustomBouncePhysic extends BouncingScrollPhysics {
  const CustomBouncePhysic({
    super.decelerationRate = ScrollDecelerationRate.normal,
    super.parent,
  });

  @override
  double frictionFactor(double overscrollFraction) {
    return 1.0 * math.pow(1 - overscrollFraction, 2);
  }

  @override
  BouncingScrollPhysics applyTo(ScrollPhysics? ancestor) {
    return CustomBouncePhysic(
        parent: buildParent(ancestor),
        decelerationRate: decelerationRate
    );
  }
}
