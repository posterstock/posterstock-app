import 'dart:math' as math;
import 'dart:math';

import 'package:flutter/animation.dart';

class CustomElasticCurve extends Curve {
  const CustomElasticCurve({
    this.a = 0.2,
    this.w = 8,
  });
  final double a;
  final double w;

  @override
  double transformInternal(double t) {
    return -(pow(e, -t / a) * cos(t * w)) + 1;
  }
}