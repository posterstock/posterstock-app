import 'dart:math';

import 'package:flutter/animation.dart';

class CustomElasticCurve extends Curve {
  const CustomElasticCurve({
    this.a = 0.12,
    this.w = 15,
  });

  final double a;
  final double w;

  @override
  double transformInternal(double t) {
    if (t > 0.53) return 1;
    return -(pow(e, -t / a) * cos(t * w)) + 1;
  }
}
