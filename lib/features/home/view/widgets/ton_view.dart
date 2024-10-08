import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class NftIcon extends StatelessWidget {
  const NftIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 4,
      left: 4,
      child: SvgPicture.asset(
        'assets/icons/ton.svg',
        width: 16,
        height: 16,
      ),
    );
  }
}

class SaleIcon extends StatelessWidget {
  const SaleIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 6,
      right: 6,
      child: SvgPicture.asset(
        'assets/icons/sale.svg',
        width: 16,
        height: 16,
      ),
    );
  }
}
