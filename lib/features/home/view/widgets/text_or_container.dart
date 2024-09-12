import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
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
  });
  @override
  Widget build(BuildContext context) {
    final style = isPoster
        ? context.textStyles.calloutBold!.copyWith(
            color: darkBackground
                ? context.colors.textsBackground!
                : context.colors.textsPrimary)
        : context.textStyles.headline;
    Widget textOrContainerWidget = TextOrContainer(
      text: name,
      style: style,
      emptyWidth: emptyWidth,
      emptyHeight: emptyHeight,
      overflow: TextOverflow.ellipsis,
    );
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        isFlexible
            ? Flexible(child: textOrContainerWidget)
            : textOrContainerWidget,
        if (isArtist) ...[
          const Gap(5),
          Padding(
            padding: const EdgeInsets.only(top: 2),
            child: SvgPicture.asset('assets/icons/art.svg'),
          ),
        ]
      ],
    );
  }
}

class NameWithArtist extends StatelessWidget {
  final String name;
  final bool isArtist;

  const NameWithArtist({
    super.key,
    required this.name,
    required this.isArtist,
  });
  @override
  Widget build(BuildContext context) {
    final style = context.textStyles.calloutBold!
        .copyWith(color: context.colors.textsPrimary);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        TextOrContainer(
          text: name,
          style: style,
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
