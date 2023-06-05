import 'package:flutter/material.dart';
import 'package:poster_stock/common/services/text_info_service.dart';
import 'package:poster_stock/features/home/view/widgets/reaction_button.dart';
import 'package:poster_stock/features/home/view/widgets/text_or_container.dart';
import 'package:poster_stock/themes/build_context_extension.dart';

import '../../models/post_movie_model.dart';
import '../helpers/custom_bounce_physic.dart';
import '../helpers/custom_elastic_curve.dart';
import '../helpers/page_holder.dart';
import 'current_post_shower.dart';

class MovieCard extends StatefulWidget {
  const MovieCard({
    Key? key,
    this.movie,
    required this.pageHolder,
  }) : super(key: key);

  final List<PostMovieModel>? movie;
  final PageHolder pageHolder;

  @override
  State<MovieCard> createState() => MovieCardState();
}

class MovieCardState extends State<MovieCard> with TickerProviderStateMixin {
  late AnimationController controller;
  late AnimationController likeCommentController;
  PageController? pageController;
  int currentPage = 0;
  double? textHeight;
  double? titleHeight;
  bool firstRun = true;
  bool disposed = false;
  late final ScrollPhysics physics;

  @override
  void dispose() {
    disposed = true;
    controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    physics = const HorizontalBlockedScrollPhysics();
    likeCommentController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 0),
      lowerBound: 0.0,
      upperBound: widget.movie?.length.toDouble() ?? 1.0,
    );
    controller = AnimationController(
      vsync: this,
      lowerBound: -16.0,
      upperBound: 16.0,
      duration: const Duration(milliseconds: 300),
    );
    controller.animateTo(16.0, duration: Duration.zero);
    if (widget.movie != null) {
      Future.delayed(const Duration(milliseconds: 300), () {
        if (!disposed) animatePosterToSide();
      });
    }
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
    getInitData();
    widget.pageHolder.page = (pageController?.page ?? 0).round();
    return Container(
      height: (textHeight ?? 0) + 58 + 31 + titleHeight!,
      child: AnimatedBuilder(
        animation: controller,
        builder: (context, child) {
          pageController = PageController(
            initialPage: 0,
            viewportFraction: 1 +
                ((16 - controller.value) *
                    9 /
                    MediaQuery.of(context).size.width),
          )..addListener(() {
              widget.pageHolder.page = (pageController?.page ?? 0).round();
              if (pageController?.page == null ||
                  pageController!.page! < 0.05) {
                return;
              }
              likeCommentController.animateTo((pageController?.page?.toInt() ??
                      0) +
                  (((pageController!.page ?? 0) * 100).toInt() % 100) / 100);
            });

          return Stack(
            children: [
              OverflowBox(
                maxWidth: MediaQuery.of(context).size.width +
                    72 * (controller.value < 0 ? 0 : controller.value) / 16,
                alignment: Alignment.centerLeft,
                child: PageView.builder(
                  physics: physics,
                  controller: pageController,
                  itemCount: widget.movie?.length ?? 1,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: EdgeInsets.only(
                        left: controller.value < 0 ? 0 : controller.value,
                      ),
                      child: _MovieCardPageViewContent(
                        likeCommentController: likeCommentController,
                        controller: controller,
                        onPosterTap: () {
                          if (controller.value != 16.0) {
                            controller.animateTo(
                              16.0,
                              duration: const Duration(milliseconds: 300),
                            );
                          } else {
                            animatePosterToSide();
                          }
                        },
                        textHeight: textHeight!,
                        titleHeight: titleHeight!,
                        description:
                            (widget.movie?[index].description ?? '').length >
                                    280
                                ? (widget.movie?[index].description ?? '')
                                    .substring(0, 280)
                                : (widget.movie?[index].description ?? ''),
                        movie: widget.movie?[index],
                      ),
                    );
                  },
                ),
              ),
              if (widget.movie != null && widget.movie!.length > 1)
                AnimatedBuilder(
                    animation: likeCommentController,
                    builder: (context, child) {
                      int page = likeCommentController.value.toInt();
                      if (likeCommentController.value -
                              likeCommentController.value.toInt() >
                          0.5) page++;
                      return Positioned(
                        top: 0,
                        right: 16,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 5.0, horizontal: 12.0),
                          decoration: BoxDecoration(
                            color: context.colors.backgroundsSecondary,
                            borderRadius: BorderRadius.circular(16.0),
                          ),
                          child: Text('${page + 1}/${widget.movie?.length}'),
                        ),
                      );
                    }),
              if (widget.movie != null && widget.movie!.length > 1)
                AnimatedBuilder(
                    animation: likeCommentController,
                    builder: (context, child) {
                      return Positioned(
                        bottom: 27,
                        left: 68,
                        child: CurrentPostShower(
                          length: widget.movie!.length,
                          current: (likeCommentController.value -
                                      likeCommentController.value.toInt()) >
                                  0.5
                              ? likeCommentController.value.toInt() + 1
                              : likeCommentController.value.toInt(),
                        ),
                      );
                    })
            ],
          );
        },
      ),
    );
  }

  void getInitData() {
    if (firstRun) {
      firstRun = false;
      var description = (widget.movie?[0].description ?? '').length > 280
          ? (widget.movie?[0].description ?? '').substring(0, 280)
          : (widget.movie?[0].description ?? '');
      textHeight = TextInfoService.textSize(
                      description,
                      context.textStyles.subheadline!,
                      MediaQuery.of(context).size.width - 84)
                  .height <
              100
          ? 100
          : TextInfoService.textSize(
                  description,
                  context.textStyles.subheadline!,
                  MediaQuery.of(context).size.width - 84)
              .height;
      if ((widget.movie?.length ?? 1) > 1) {
        for (PostMovieModel i in widget.movie!) {
          var size = TextInfoService.textSize(
              (i.description ?? '').length > 280
                  ? (i.description?.substring(0, 280) ?? '')
                  : (i.description ?? ''),
              context.textStyles.subheadline!,
              MediaQuery.of(context).size.width - 84);
          if (size.height > textHeight!) {
            textHeight = size.height;
          }
          if (textHeight! < 140) textHeight = 140;
        }
      }
    }
    titleHeight = TextInfoService.textSize(
      widget.movie?[0].name ?? '',
      context.textStyles.subheadlineBold!,
      MediaQuery.of(context).size.width - 134,
    ).height;
  }
}

class _MovieCardPageViewContent extends StatelessWidget {
  const _MovieCardPageViewContent({
    Key? key,
    required this.likeCommentController,
    required this.controller,
    required this.onPosterTap,
    this.movie,
    required this.textHeight,
    required this.titleHeight,
    required this.description,
  }) : super(key: key);
  final AnimationController likeCommentController;
  final AnimationController controller;
  final void Function() onPosterTap;
  final PostMovieModel? movie;
  final double textHeight;
  final double titleHeight;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(10.0),
          child: Container(
            width: 128,
            height: 193,
            color: context.colors.backgroundsSecondary,
            child: movie?.imagePath != null
                ? Image.network(
                    movie!.imagePath,
                    fit: BoxFit.cover,
                  )
                : const SizedBox(),
          ),
        ),
        const SizedBox(
          width: 12,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: movie != null
                  ? MediaQuery.of(context).size.width - 134
                  : null,
              child: TextOrContainer(
                text: movie != null ? movie!.name : null,
                style: context.textStyles.subheadlineBold!,
                emptyWidth: 146,
                emptyHeight: 17,
              ),
            ),
            SizedBox(
              height: movie != null ? 5 : 8,
            ),
            TextOrContainer(
              text: movie != null ? movie!.year.toString() : null,
              style: context.textStyles.caption1!.copyWith(
                color: context.colors.textsSecondary,
              ),
              emptyWidth: 120,
              emptyHeight: 12,
            ),
            SizedBox(
              height: movie != null ? 10 : 8,
            ),
            if (movie != null)
              SizedBox(
                height: textHeight,
                width: MediaQuery.of(context).size.width - 84,
                child: Text(
                  description,
                  style: context.textStyles.subheadline!,
                ),
              ),
            const SizedBox(
              height: 14,
            ),
            if (movie != null)
              AnimatedBuilder(
                animation: likeCommentController,
                builder: (context, child) {
                  double opacity = (1 -
                      (likeCommentController.value -
                              likeCommentController.value.toInt()) *
                          4);
                  if ((likeCommentController.value -
                          likeCommentController.value.toInt()) >
                      0.8) {
                    opacity = ((likeCommentController.value -
                                likeCommentController.value.toInt()) -
                            0.8) *
                        5;
                  }
                  if (opacity < 0) opacity = 0;
                  if (opacity > 1) opacity = 1;
                  return Opacity(
                    opacity: opacity,
                    child: child,
                  );
                },
                child: SizedBox(
                  width: MediaQuery.of(context).size.width - 84,
                  child: Row(
                    children: [
                      const Spacer(),
                      ReactionButton(
                        iconPath: 'assets/icons/ic_heart.svg',
                        iconColor: context.colors.iconsDisabled!,
                        amount: movie?.likes.length,
                      ),
                      const SizedBox(
                        width: 12,
                      ),
                      ReactionButton(
                        iconPath: 'assets/icons/ic_comment2.svg',
                        iconColor: context.colors.iconsDisabled!,
                        amount: movie?.comments.length,
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }
}
