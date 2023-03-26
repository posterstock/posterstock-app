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
    this.bgStrokeColor,
  });

  const ProgressBorder.fromBorderSide(
    BorderSide side, [
    this.progressStart,
    this.progressEnd,
    this.bgStrokeColor,
  ])  : top = side,
        right = side,
        bottom = side,
        left = side;

  factory ProgressBorder.all({
    Color color = const Color(0xFF000000),
    Color bgStrokeColor = const Color(0x00000000),
    double width = 1.5,
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
      bgStrokeColor,
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

  final Color? bgStrokeColor;

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
      bgStrokeColor: bgStrokeColor,
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
    double progressEnd, {
    Color? bgStrokeColor,
  }) {
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
        ..strokeWidth = side.width + 0.5;
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
        progressEnd,
        bgStrokeColor: bgStrokeColor,
      );
    }
  }

  static void _paint(
    Canvas canvas,
    Path path,
    Paint paint,
    double progressStart,
    double progressEnd, {
    int loadType = 0,
    Color? bgStrokeColor,
  }) {
    final metrics = path.computeMetrics(forceClosed: true).toList();
    _paintMetrics(
      canvas,
      metrics,
      paint,
      progressStart,
      progressEnd,
      loadType: loadType,
      bgStrokeColor: bgStrokeColor,
    );
  }

  static void _paintMetrics(
    Canvas canvas,
    List<ui.PathMetric> metrics,
    Paint paint,
    double progressStart,
    double progressEnd, {
    int loadType = 0,
    Color? bgStrokeColor,
  }) {
    List<ui.PathMetric> newMetr;

    newMetr = metrics;

    var total = newMetr.fold<double>(0, (v, e) => v + e.length);

    double targetStart = total * progressStart;
    double targetEnd = total * progressEnd;
    paint.strokeJoin = ui.StrokeJoin.miter;
    paint.strokeCap = ui.StrokeCap.round;

    final iterator = newMetr.toList();
    for (final m in iterator) {
      canvas.drawPath(
        m.extractPath(0, total),
        Paint()
          ..strokeWidth = paint.strokeWidth
          ..color = bgStrokeColor ?? const Color(0x00000000)
          ..style = PaintingStyle.stroke,
      );

      canvas.drawPath(m.extractPath(targetStart, targetEnd), paint);
      if (targetEnd > total) {
        canvas.drawPath(m.extractPath(0, targetEnd - total), paint);
      }
    }
  }
}
