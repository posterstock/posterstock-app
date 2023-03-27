import 'dart:math';

import 'package:flutter/material.dart';
import 'package:poster_stock/features/home/view/widgets/reaction_button.dart';
import 'package:poster_stock/features/home/view/widgets/text_or_container.dart';
import 'package:poster_stock/themes/build_context_extension.dart';

import '../../models/post_movie_model.dart';
import '../helpers/custom_bounce_physic.dart';
import '../helpers/custom_elastic_curve.dart';
import 'current_post_shower.dart';

class MovieCard extends StatefulWidget {
  const MovieCard({
    Key? key,
    this.movie,
  }) : super(key: key);

  final List<PostMovieModel>? movie;

  @override
  State<MovieCard> createState() => _MovieCardState();
}

class _MovieCardState extends State<MovieCard>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  PageController? pageController;
  int currentPage = 0;
  double? textHeight;
  double? height;
  String description = '';

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

  @override
  void didChangeDependencies() {
    description =
    (widget.movie?[currentPage].description ?? '').length > 280
        ? (widget.movie?[currentPage].description ?? '').substring(0, 280)
        : (widget.movie?[currentPage].description ?? '');
    textHeight =
        _textSize(description, context.textStyles.subheadline!)
            .height;
    height = textHeight! + 51 > 193 ? textHeight! + 51 : 193;
    setState(() {});
    super.didChangeDependencies();
  }

  void animatePosterToSide() {
    controller.animateTo(
      0.0,
      duration: const Duration(milliseconds: 700),
      curve: const CustomElasticCurve(),
    );
  }

  @override
  Widget build(BuildContext context) {
    description =
        (widget.movie?[currentPage].description ?? '').length > 280
            ? (widget.movie?[currentPage].description ?? '').substring(0, 280)
            : (widget.movie?[currentPage].description ?? '');
    textHeight ??=
        _textSize(description, context.textStyles.subheadline!).height;
    height ??= textHeight! + 51 > 193 ? textHeight! + 51 : 193;
    return SizedBox(
      height: height != 193 ? height! + 74 : height! + 45,
      child: AnimatedBuilder(
        animation: controller,
        builder: (context, child) {
          return Stack(
            children: [
              PageView.builder(
                onPageChanged: (int page) {
                  currentPage = page;
                  description =
                  (widget.movie?[currentPage].description ?? '').length > 280
                      ? (widget.movie?[currentPage].description ?? '').substring(0, 280)
                      : (widget.movie?[currentPage].description ?? '');
                  textHeight =
                      _textSize(description, context.textStyles.subheadline!)
                          .height;
                  height = textHeight! + 51 > 193 ? textHeight! + 51 : 193;
                  setState(() {});
                },
                physics: const CustomBouncePhysic(
                    decelerationRate: ScrollDecelerationRate.normal),
                controller: PageController(
                  initialPage: 0,
                  viewportFraction: 1 +
                      ((16 - controller.value) *
                          9 /
                          MediaQuery.of(context).size.width),
                ),
                itemCount: widget.movie?.length ?? 1,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.only(
                        left: controller.value < 0 ? 0 : controller.value),
                    child: child,
                  );
                },
              ),
              if (widget.movie != null && widget.movie!.length > 1)
                Positioned(
                  top: 0,
                  right: 16,
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(vertical: 5.0, horizontal: 12.0),
                    decoration: BoxDecoration(
                      color: context.colors.backgroundsSecondary,
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    child: Text('${currentPage + 1}/${widget.movie?.length}'),
                  ),
                ),
              if (widget.movie != null && widget.movie!.length > 1)
                Positioned(
                  bottom: 18,
                  left: 68,
                  child: CurrentPostShower(
                    length: widget.movie!.length,
                    current: currentPage,
                  ),
                )
            ],
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
                  child: widget.movie?[currentPage].imagePath != null
                      ? Image.network(
                          widget.movie![currentPage].imagePath,
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
                  text: widget.movie != null
                      ? widget.movie![currentPage].name
                      : null,
                  style: context.textStyles.subheadlineBold!,
                  emptyWidth: 146,
                  emptyHeight: 17,
                ),
                SizedBox(
                  height: widget.movie != null ? 5 : 8,
                ),
                TextOrContainer(
                  text: widget.movie != null
                      ? widget.movie![currentPage].year.toString()
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
                    height: textHeight! <= 100 ? 119 : textHeight! + 14,
                    width: MediaQuery.of(context).size.width - 84,
                    child: Text(
                      description,
                      style: context.textStyles.subheadline!,
                    ),
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
                  ),
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
      textDirection: TextDirection.ltr,
    )..layout(
        minWidth: MediaQuery.of(context).size.width - 84,
        maxWidth: MediaQuery.of(context).size.width - 84,
      );
    return textPainter.size;
  }
}
