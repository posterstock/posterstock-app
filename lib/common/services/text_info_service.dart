import 'package:flutter/material.dart';

class TextInfoService {
  static Size textSize(String text, TextStyle style, double width) {
    final TextPainter textPainter = TextPainter(
      text: TextSpan(text: text, style: style),
      textDirection: TextDirection.ltr,
    )..layout(
      minWidth: width,
      maxWidth: width,
    );
    return textPainter.size;
  }
}