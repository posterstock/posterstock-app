import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:poster_stock/features/home/models/post_movie_model.dart';
import 'package:poster_stock/themes/build_context_extension.dart';
import 'package:shimmer/shimmer.dart';

import '../helpers/custom_elastic_curve.dart';

class SingleMoviePost extends StatelessWidget {
  const SingleMoviePost({
    Key? key,
    this.post,
  }) : super(key: key);

  final PostMovieModel? post;

  @override
  Widget build(BuildContext context) {
    const List<Color> avatar = [
      Color(0xfff09a90),
      Color(0xfff3d376),
      Color(0xff92bdf4),
    ];
    return Material(
      color: context.colors.backgroundsPrimary,
      child: InkWell(
        onTap: () {},
        child: ShimmerLoader(
          loaded: post != null,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      width: 16,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: CircleAvatar(
                        radius: 20,
                        backgroundImage: post?.author.imagePath != null
                            ? NetworkImage(post!.author.imagePath!)
                            : null,
                        backgroundColor: avatar[Random().nextInt(3)],
                        child: post?.author.imagePath == null && post != null
                            ? Text(
                                getAvatarName(post!.author.name)
                                        .toUpperCase(),
                                style: context.textStyles.subheadlineBold!
                                    .copyWith(
                                  color: context.colors.textsBackground,
                                ),
                              )
                            : const SizedBox(),
                      ),
                    ),
                    const SizedBox(
                      width: 12,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (post == null)
                                const SizedBox(
                                  height: 3,
                                ),
                              TextOrContainer(
                                text: post?.author.name,
                                style: context.textStyles.calloutBold,
                                emptyWidth: 146,
                                emptyHeight: 17,
                              ),
                              SizedBox(
                                height: post != null ? 4 : 8,
                              ),
                              TextOrContainer(
                                text: post?.author.username == null ? null : '@${post!.author.username}',
                                style: context.textStyles.caption1!.copyWith(
                                  color: context.colors.textsSecondary,
                                ),
                                emptyWidth: 120,
                                emptyHeight: 12,
                              ),
                            ],
                          ),
                          SizedBox(
                            width: (post?.author.followed ?? true) ? 12 : 24,
                          ),
                          if (post?.author.followed ?? true)
                            Padding(
                              padding: const EdgeInsets.only(top: 3.0),
                              child: Text(
                                post?.time ?? '',
                                style: context.textStyles.footNote!.copyWith(
                                  color: context.colors.textsDisabled,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    if (!(post?.author.followed ?? true) && post != null)
                      const AppTextButton(
                        text: 'Follow',
                      ),
                    if (post != null)
                      GestureDetector(
                        onTap: () {},
                        child: Container(
                          color: Colors.transparent,
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: SvgPicture.asset(
                            'assets/icons/ic_dots.svg',
                            width: 24,
                            colorFilter: ColorFilter.mode(
                              context.colors.iconsLayer!,
                              BlendMode.srcIn,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              MovieCard(
                movie: post,
              ),
              const SizedBox(
                height: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }

  String getAvatarName(String name) {
    String result = name[0];
    for (int i = 0; i < name.length; i++) {
      if (name[i] == ' ' && i != name.length - 1) {
        result += name[i + 1];
        break;
      }
    }
    return result;
  }
}

class MovieCard extends StatefulWidget {
  const MovieCard({
    Key? key,
    this.movie,
  }) : super(key: key);

  final PostMovieModel? movie;

  @override
  State<MovieCard> createState() => _MovieCardState();
}

class _MovieCardState extends State<MovieCard>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    controller = AnimationController(
      vsync: this,
      lowerBound: -16.0,
      upperBound: 16.0,
      duration: const Duration(milliseconds: 300),
    );
    controller.animateTo(16.0, duration: Duration.zero);
    if (widget.movie != null) {
      Future.delayed(const Duration(milliseconds: 300), () {
        animatePosterToSide();
      });
    }
    super.initState();
  }

  void animatePosterToSide() {
    controller.animateTo(
      0.0,
      duration: const Duration(milliseconds: 500),
      curve: const CustomElasticCurve(),
    );
  }

  @override
  Widget build(BuildContext context) {
    double textHeight = _textSize(
            widget.movie?.description ?? ' ', context.textStyles.subheadline!)
        .height;
    double height = textHeight + 51 > 193 ? textHeight + 51 : 193;
    return SizedBox(
      height: height != 193 ? height + 58 : height + 30,
      //TODO
      child: AnimatedBuilder(
        animation: controller,
        builder: (context, child) {
          return PageView.builder(
            physics: const BouncingScrollPhysics(),
            controller: PageController(
              initialPage: 0,
              viewportFraction: 1 +
                  ((16 - controller.value) *
                      9 /
                      MediaQuery.of(context).size.width),
            ),
            itemCount: 1,
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.only(
                    left: controller.value < 0 ? 0 : controller.value),
                child: child,
              );
            },
          );
        },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () {
                if (controller.value != 16.0) {
                  controller.animateTo(
                    16.0,
                    duration: const Duration(milliseconds: 300),
                  );
                } else {
                  animatePosterToSide();
                }
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: Container(
                  width: 128,
                  height: 193,
                  color: context.colors.backgroundsSecondary,
                  child: widget.movie?.imagePath != null
                      ? Image.network(
                          widget.movie!.imagePath,
                          fit: BoxFit.cover,
                        )
                      : const SizedBox(),
                ),
              ),
            ),
            const SizedBox(
              width: 12,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextOrContainer(
                  text: widget.movie != null ? widget.movie!.name : null,
                  style: context.textStyles.subheadlineBold!,
                  emptyWidth: 146,
                  emptyHeight: 17,
                ),
                SizedBox(
                  height: widget.movie != null ? 5 : 8,
                ),
                TextOrContainer(
                  text: widget.movie != null
                      ? widget.movie!.year.toString()
                      : null,
                  style: context.textStyles.caption1!.copyWith(
                    color: context.colors.textsSecondary,
                  ),
                  emptyWidth: 120,
                  emptyHeight: 12,
                ),
                SizedBox(
                  height: widget.movie != null ? 5 : 8,
                ),
                if (widget.movie != null)
                  SizedBox(
                    height: textHeight < 110 ? 110 : textHeight + 20,
                    width: MediaQuery.of(context).size.width - 84,
                    child: Text(
                      widget.movie?.description ?? '',
                      style: context.textStyles.subheadline!,
                    ),
                  ),
                const SizedBox(
                  height: 14,
                ),
                if (widget.movie != null)
                  SizedBox(
                    width: MediaQuery.of(context).size.width - 84,
                    child: Row(
                      children: [
                        const Spacer(),
                        ReactionButton(
                          iconPath: 'assets/icons/ic_heart.svg',
                          iconColor: context.colors.iconsDisabled!,
                          amount: Random().nextInt(2) % 2 == 0
                              ? null
                              : Random().nextInt(5) * 100,
                        ),
                        const SizedBox(
                          width: 12,
                        ),
                        ReactionButton(
                          iconPath: 'assets/icons/ic_comment2.svg',
                          iconColor: context.colors.iconsDisabled!,
                          amount: Random().nextInt(2) % 2 == 0
                              ? null
                              : Random().nextInt(5) * 100,
                        ),
                      ],
                    ),
                  )
              ],
            ),
          ],
        ),
      ),
    );
  }

  Size _textSize(String text, TextStyle style) {
    final TextPainter textPainter = TextPainter(
        text: TextSpan(text: text, style: style),
        textDirection: TextDirection.ltr)
      ..layout(
          minWidth: MediaQuery.of(context).size.width - 84,
          maxWidth: MediaQuery.of(context).size.width - 84);
    return textPainter.size;
  }
}

class ReactionButton extends StatelessWidget {
  const ReactionButton({
    super.key,
    required this.iconPath,
    required this.iconColor,
    this.amount,
  });

  final String iconPath;
  final Color iconColor;
  final int? amount;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16.0),
      child: Material(
        color: context.colors.backgroundsSecondary!,
        child: InkWell(
          highlightColor: context.colors.textsDisabled!.withOpacity(0.2),
          onTap: () {},
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
            child: Row(
              children: [
                SvgPicture.asset(
                  iconPath,
                  width: 20,
                  colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
                ),
                if (amount != null && amount != 0)
                  const SizedBox(
                    width: 4,
                  ),
                if (amount != null && amount != 0)
                  Text(
                    amount.toString(),
                    style: context.textStyles.footNote!.copyWith(
                      color: context.colors.textsDisabled,
                    ),
                  ),
                if (amount != null && amount != 0)
                  const SizedBox(
                    width: 2,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

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

class ShimmerLoader extends StatelessWidget {
  const ShimmerLoader({
    Key? key,
    required this.child,
    this.loaded = false,
  }) : super(key: key);

  final bool loaded;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    if (loaded) return SizedBox(child: child);
    return Shimmer.fromColors(
      baseColor: context.colors.fieldsHover!,
      highlightColor: context.colors.backgroundsPrimary!,
      child: child,
    );
  }
}

class AppTextButton extends StatelessWidget {
  const AppTextButton({Key? key, required this.text}) : super(key: key);
  final String text;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(33),
      child: Material(
        color: context.colors.buttonsPrimary,
        child: InkWell(
          highlightColor: context.colors.textsPrimary!.withOpacity(0.2),
          onTap: () {},
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 5.5,
            ),
            child: Text(
              text,
              style: context.textStyles.calloutBold!.copyWith(
                color: context.colors.textsBackground,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
