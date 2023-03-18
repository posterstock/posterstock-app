import 'dart:ui' as ui;

import 'package:flutter/widgets.dart';

class ProgressBorder extends BoxBorder {
  const ProgressBorder({
    this.top = BorderSide.none,
    this.right = BorderSide.none,
    this.bottom = BorderSide.none,
    this.left = BorderSide.none,
    this.progressStart,
    this.progressEnd,
  });

  const ProgressBorder.fromBorderSide(
    BorderSide side, [
    this.progressStart,
    this.progressEnd,
  ])  : top = side,
        right = side,
        bottom = side,
        left = side;

  factory ProgressBorder.all({
    Color color = const Color(0xFF000000),
    double width = 1.0,
    double? progressStart,
    double? progressEnd,
  }) {
    final BorderSide side = BorderSide(
      color: color,
      width: width,
      style: BorderStyle.solid,
    );
    return ProgressBorder.fromBorderSide(
      side,
      progressStart,
      progressEnd,
    );
  }

  @override
  final BorderSide top;

  final BorderSide right;

  @override
  final BorderSide bottom;

  final BorderSide left;

  final double? progressStart;

  final double? progressEnd;

  @override
  EdgeInsetsGeometry get dimensions => EdgeInsets.fromLTRB(
        left.width,
        top.width,
        right.width,
        bottom.width,
      );

  @override
  bool get isUniform => true;

  @override
  void paint(Canvas canvas, Rect rect,
      {TextDirection? textDirection,
      BoxShape shape = BoxShape.rectangle,
      BorderRadius? borderRadius}) {
    _paintUniformBorderWithRadius(
      canvas,
      rect,
      top,
      borderRadius ?? BorderRadius.circular(16.0),
      progressStart ?? 0,
      progressEnd ?? 1,
    );
  }

  @override
  ShapeBorder scale(double t) {
    return ProgressBorder(
      top: top.scale(t),
      right: right.scale(t),
      bottom: bottom.scale(t),
      left: left.scale(t),
      progressStart: progressStart,
      progressEnd: progressEnd,
    );
  }

  static void _paintUniformBorderWithRadius(
    Canvas canvas,
    Rect rect,
    BorderSide side,
    BorderRadius borderRadius,
    double progressStart,
    double progressEnd,
  ) {
    assert(side.style != BorderStyle.none);
    final Paint paint = Paint()..color = side.color;
    final RRect outer = borderRadius.toRRect(rect);
    final double halfWidth = side.width / 2;
    if (halfWidth <= 0.0) {
      paint
        ..style = PaintingStyle.stroke
        ..strokeWidth = 0.0;
      canvas.drawRRect(outer, paint);
    } else {
      paint
        ..style = PaintingStyle.stroke
        ..strokeWidth = side.width;
      _paint(
          canvas,
          Path()
            ..addRRect(
              RRect.fromLTRBR(
                rect.left + 0.5,
                rect.top + 0.5,
                rect.right - 0.5,
                rect.bottom - 0.5,
                borderRadius.topRight,
              ),
            )
            ..close(),
          paint,
          progressStart,
          progressEnd);
    }
  }

  static void _paint(
    Canvas canvas,
    Path path,
    Paint paint,
    double progressStart,
    double progressEnd,
  ) {
    final metrics = path.computeMetrics(forceClosed: true).toList();
    _paintMetrics(canvas, metrics, paint, progressStart, progressEnd);
  }

  static void _paintMetrics(
    Canvas canvas,
    List<ui.PathMetric> metrics,
    Paint paint,
    double progressStart,
    double progressEnd,
  ) {
    final total = metrics.fold<double>(0, (v, e) => v + e.length);

    double targetStart = total * progressStart;
    double targetEnd = total * progressEnd;
    paint.strokeJoin = ui.StrokeJoin.miter;
    paint.strokeCap = ui.StrokeCap.round;

    final iterator = metrics.toList();
    for (final m in iterator) {
      canvas.drawPath(m.extractPath(targetStart, targetEnd), paint);
      if (targetEnd > total) {
        canvas.drawPath(m.extractPath(0, targetEnd - total), paint);
      }
    }
  }
}
