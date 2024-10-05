import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';
import 'package:poster_stock/themes/build_context_extension.dart';

class TextOrContainer extends StatelessWidget {
  const TextOrContainer({
    Key? key,
    this.text,
    this.style,
    this.emptyWidth,
    this.emptyHeight,
    this.overflow,
    this.width,
  }) : super(key: key);

  final String? text;
  final TextStyle? style;
  final double? emptyWidth;
  final double? emptyHeight;
  final double? width;
  final TextOverflow? overflow;

  @override
  Widget build(BuildContext context) {
    if (text != null) {
      return SizedBox(
        width: width,
        child: Text(
          text!,
          style: style,
          overflow: overflow,
        ),
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

class NameWithArtistPoster extends StatelessWidget {
  final String name;
  final bool isArtist;
  final bool isPoster;
  final bool darkBackground;
  final double? emptyWidth;
  final double? emptyHeight;
  final TextOverflow? overflow;
  final bool isFlexible;
  final bool isArtistWb;

  const NameWithArtistPoster({
    super.key,
    required this.name,
    required this.isArtist,
    this.isPoster = false,
    this.darkBackground = false,
    this.emptyWidth,
    this.emptyHeight,
    this.overflow,
    this.isFlexible = true,
    this.isArtistWb = false,
  });
  @override
  Widget build(BuildContext context) {
    final style = context.textStyles.calloutBold!.copyWith(
        color: darkBackground
            ? context.colors.textsBackground!
            : context.colors.textsPrimary);
    Widget textOrContainerWidget = TextOrContainer(
      text: name,
      style: style,
      emptyWidth: emptyWidth,
      emptyHeight: emptyHeight,
      overflow: TextOverflow.ellipsis,
    );
    return Row(
      mainAxisSize: MainAxisSize.min, // Изменено здесь
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        isFlexible
            ? Flexible(
                fit: FlexFit.loose, // Изменено здесь
                child: textOrContainerWidget)
            : textOrContainerWidget,
        if (isArtist) ...[
          const Gap(5),
          Padding(
            padding: const EdgeInsets.only(top: 2),
            child: SvgPicture.asset(isArtistWb
                ? 'assets/icons/art_wb.svg'
                : 'assets/icons/art.svg'),
          ),
        ]
      ],
    );
  }
}

class NameWithArtist extends StatelessWidget {
  final String name;
  final bool isArtist;
  final TextStyle? style;

  const NameWithArtist({
    super.key,
    required this.name,
    required this.isArtist,
    this.style,
  });
  @override
  Widget build(BuildContext context) {
    final style = this.style ??
        context.textStyles.calloutBold!
            .copyWith(color: context.colors.textsPrimary);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        TextOrContainer(
          text: name,
          style: style,
          overflow: TextOverflow.ellipsis,
        ),
        const Gap(5),
        if (isArtist)
          Padding(
            padding: const EdgeInsets.only(top: 2),
            child: SvgPicture.asset('assets/icons/art.svg'),
          ),
      ],
    );
  }
}

GradientBoxBorder nftGradientBoxBorder() {
  double gradient = 180 - 10.88;
  return GradientBoxBorder(
    width: 1.5,
    gradient: LinearGradient(
      colors: const [
        Color(0xFF3390EC), // 0%
        Color(0xFF6E9BF4), // 23%
        Color(0xFF949EEE), // 37%
        Color(0xFFD3A2E4), // 58%
        Color(0xFFF8BAC0), // 87%
        Color(0xFFFAC3B5), // 92%
        Color(0xFFFFD69C), // 100%
      ],
      stops: const [
        0.0,
        0.23,
        0.37,
        0.58,
        0.87,
        0.92,
        1.0,
      ],
      begin: Alignment(
        cos(gradient * pi / 180), // x = cos(угол)
        sin(gradient * pi / 180), // y = sin(угол)
      ),
      end: Alignment(
        cos(gradient * pi / 180) * -1, // x = -cos(угол)
        sin(gradient * pi / 180) * -1, // y = -sin(угол)
      ),
    ),
  );
}
