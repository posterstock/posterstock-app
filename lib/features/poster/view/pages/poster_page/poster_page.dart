import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:poster_stock/features/auth/view/widgets/custom_app_bar.dart';
import 'package:poster_stock/features/home/models/post_movie_model.dart';
import 'package:poster_stock/themes/build_context_extension.dart';

class PosterPage extends StatefulWidget {
  const PosterPage({
    Key? key,
    required this.post,
  }) : super(key: key);
  final PostMovieModel post;

  @override
  State<PosterPage> createState() => _PosterPageState();
}

class _PosterPageState extends State<PosterPage> with TickerProviderStateMixin {
  AnimationController? posterAnimationController;
  late AnimationController iconsAnimationController;
  bool animating = false;
  final scrollController = ScrollController();
  double statusBarHeight = 0;

  @override
  void initState() {
    iconsAnimationController = AnimationController(
      vsync: this,
      lowerBound: 0,
      upperBound: 42,
    );
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (posterAnimationController == null) {
      statusBarHeight = MediaQuery.of(context).padding.top;
      posterAnimationController = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 300),
        lowerBound: 45 / MediaQuery.of(context).size.height,
      );
      posterAnimationController!.animateTo(
        posterAnimationController!.upperBound,
        duration: Duration.zero,
      );
    }
    return Scaffold(
      body: AnimatedBuilder(
        animation: posterAnimationController!,
        builder: (context, child) {
          return AnnotatedRegion<SystemUiOverlayStyle>(
            value: SystemUiOverlayStyle(
              statusBarBrightness: posterAnimationController!.value > 0.5
                  ? Brightness.dark
                  : Brightness.light,
              statusBarIconBrightness: posterAnimationController!.value < 0.5
                  ? Brightness.dark
                  : Brightness.light,
              statusBarColor: Colors.transparent,
            ),
            child: child!,
          );
        },
        child: Stack(
          children: [
            AnimatedBuilder(
              animation: posterAnimationController!,
              builder: (context, child) {
                return Padding(
                  padding: EdgeInsets.only(
                    top: (MediaQuery.of(context).padding.top + 8) *
                        (1 - posterAnimationController!.value),
                  ),
                  child: Transform.scale(
                    alignment: Alignment.topCenter,
                    scale: posterAnimationController!.value,
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(
                            (1 - posterAnimationController!.value) * 50.0),
                        child: child),
                  ),
                );
              },
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.7,
                width: double.infinity,
                child: Image.network(
                  widget.post.imagePath,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            NotificationListener<ScrollNotification>(
              onNotification: (notification) {
                if (notification is UserScrollNotification) {
                  if (posterAnimationController!.value !=
                          posterAnimationController!.lowerBound &&
                      notification.direction == ScrollDirection.reverse) {
                    animating = true;
                    posterAnimationController!
                        .animateTo(posterAnimationController!.lowerBound)
                        .then((value) {
                      animating = false;
                    });
                  } else if (posterAnimationController!.value !=
                          posterAnimationController!.upperBound &&
                      notification.direction == ScrollDirection.forward &&
                      scrollController.position.pixels <= 0) {
                    animating = true;
                    posterAnimationController!
                        .animateTo(posterAnimationController!.upperBound)
                        .then((value) {
                      animating = false;
                    });
                  }
                }
                if (notification is ScrollUpdateNotification) {
                  if (animating) scrollController.jumpTo(0);
                  iconsAnimationController.animateTo(
                    notification.metrics.pixels,
                    duration: Duration.zero,
                  );
                }
                return true;
              },
              child: SafeArea(
                child: Column(
                  children: [
                    AnimatedBuilder(
                      animation: posterAnimationController!,
                      builder: (context, child) {
                        return SizedBox(
                          height: 52 * (1 - posterAnimationController!.value) +
                              22 * posterAnimationController!.value,
                        );
                      },
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: ListView.builder(
                          itemCount: widget.post.comments.length + 3,
                          physics: const AlwaysScrollableScrollPhysics(
                            parent: BouncingScrollPhysics(),
                          ),
                          controller: scrollController,
                          itemBuilder: (context, index) {
                            print(statusBarHeight);
                            if (index == 0) {
                              return AnimatedBuilder(
                                animation: posterAnimationController!,
                                builder: (context, child) {
                                  return Container(
                                    color: Colors.transparent,
                                    height: posterAnimationController!.value *
                                                    MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.7 -
                                                statusBarHeight <
                                            0
                                        ? 0
                                        : posterAnimationController!.value *
                                                MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.7 -
                                            statusBarHeight,
                                  );
                                },
                              );
                            }
                            if (index == 1)
                              return PosterInfo(
                                post: widget.post,
                              );
                            return SizedBox();
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              right: 0,
              left: 0,
              child: SafeArea(
                child: Container(
                  height: 42,
                  color: Colors.transparent,
                  child: Row(
                    children: [
                      AnimatedBuilder(
                        animation: posterAnimationController!,
                        builder: (context, child) {
                          return CustomBackButton(
                            color: Color.lerp(
                                context.colors.textsPrimary,
                                context.colors.textsBackground,
                                posterAnimationController!.value),
                          );
                        },
                      ),
                      const Spacer(),
                      AnimatedBuilder(
                        animation: posterAnimationController!,
                        builder: (context, child) {
                          return SvgPicture.asset(
                            'assets/icons/ic_dots.svg',
                            width: 24,
                            colorFilter: ColorFilter.mode(
                              Color.lerp(
                                  context.colors.textsPrimary,
                                  context.colors.textsBackground,
                                  posterAnimationController!.value)!,
                              BlendMode.srcIn,
                            ),
                          );
                        },
                      ),
                      const SizedBox(
                        width: 16,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              left: 0,
              child: Container(
                height: 56 + MediaQuery.of(context).padding.bottom,
                color: context.colors.backgroundsPrimary,
                child: Column(
                  children: [
                    Divider(
                      height: 0.5,
                      thickness: 0.5,
                      color: context.colors.fieldsDefault,
                    ),
                    TextField(
                      cursorColor: context.colors.textsAction,
                      cursorWidth: 1,
                      minLines: null,
                      maxLines: null,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: context.colors.backgroundsPrimary,
                        border: InputBorder.none,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              child: SafeArea(
                child: Column(
                  children: [
                    AnimatedBuilder(
                      animation: posterAnimationController!,
                      builder: (context, child) {
                        return SizedBox(
                          height: 52 * (1 - posterAnimationController!.value) +
                              22 * posterAnimationController!.value,
                        );
                      },
                    ),
                    AnimatedBuilder(
                      animation: posterAnimationController!,
                      builder: (context, child) {
                        return SizedBox(
                          height: posterAnimationController!.value *
                                          MediaQuery.of(context).size.height *
                                          0.7 -
                                      statusBarHeight <
                                  0
                              ? 0
                              : posterAnimationController!.value *
                                      MediaQuery.of(context).size.height *
                                      0.7 -
                                  statusBarHeight,
                        );
                      },
                    ),
                    AnimatedBuilder(
                      animation: iconsAnimationController,
                      builder: (context, child) {
                        return Transform.translate(
                          offset: Offset(-iconsAnimationController.value, -iconsAnimationController.value),
                          child: child,
                        );
                      },
                      child: Row(
                        children: [
                          const Spacer(),
                          SvgPicture.asset(
                            'assets/icons/ic_bookmarks.svg',
                            width: 24,
                            colorFilter: ColorFilter.mode(
                              context.colors.iconsDefault!,
                              BlendMode.srcIn,
                            ),
                          ),
                          const SizedBox(width: 16),
                          SvgPicture.asset(
                            'assets/icons/ic_collection.svg',
                            width: 24,
                            colorFilter: ColorFilter.mode(
                              context.colors.iconsDefault!,
                              BlendMode.srcIn,
                            ),
                          ),
                          const SizedBox(width: 16),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PosterInfo extends StatelessWidget {
  const PosterInfo({
    super.key,
    required this.post,
  });

  final PostMovieModel post;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 259,
              child: Text(
                post.name,
                style: context.textStyles.title3,
              ),
            ),
            const Spacer(),
          ],
        ),
        const SizedBox(
          height: 6,
        ),
        Text(
          post.year.toString(),
          style: context.textStyles.subheadline!.copyWith(
            color: context.colors.textsSecondary,
          ),
        ),
        const SizedBox(
          height: 16,
        ),
        Text(
          (post.description ?? ''),
          style: context.textStyles.callout!.copyWith(
            color: context.colors.textsPrimary,
          ),
        ),
      ],
    );
  }
}
