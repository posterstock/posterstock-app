import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

/// выводит инофрмацию о TON если постер NFT
class TonInfo extends StatelessWidget {
  final int currentValue;
  final int maxValue;

  const TonInfo({
    Key? key,
    required this.currentValue,
    required this.maxValue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: 105,
          height: 26,
          padding: const EdgeInsets.only(right: 12),
          decoration: BoxDecoration(
            color: const Color(0xFFF9F9F9),
            borderRadius: BorderRadius.circular(16),
          ),
          alignment: Alignment.centerRight,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                "$currentValue",
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "/$maxValue",
                style: const TextStyle(
                  color: Color(0xFFBDBDBD),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        Positioned(
          top: 0,
          left: -1,
          child: SvgPicture.asset(
            'assets/icons/ton.svg',
            width: 26,
            height: 26,
          ),
        ),
      ],
    );
  }
}

void main() {
  runApp(
    const MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: TonInfo(currentValue: 12, maxValue: 100),
        ),
      ),
    ),
  );
}
