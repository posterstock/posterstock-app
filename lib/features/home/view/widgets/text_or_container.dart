import 'package:flutter/material.dart';

class TextOrContainer extends StatelessWidget {
  const TextOrContainer(
      {Key? key, this.text, this.style, this.emptyWidth, this.emptyHeight})
      : super(key: key);

  final String? text;
  final TextStyle? style;
  final double? emptyWidth;
  final double? emptyHeight;

  @override
  Widget build(BuildContext context) {
    if (text != null) {
      return Text(
        text!,
        style: style,
      );
    }
    return Container(
      width: emptyWidth ?? 146,
      height: emptyHeight ?? 21,
      decoration: BoxDecoration(
        color: Colors.grey,
        borderRadius: BorderRadius.circular(50.0),
      ),
    );
  }
}
