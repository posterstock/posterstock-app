import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:poster_stock/features/auth/view/widgets/custom_app_bar.dart';
import 'package:poster_stock/features/home/models/multiple_post_model.dart';
import 'package:poster_stock/features/home/view/widgets/post_base.dart';
import 'package:poster_stock/features/home/view/widgets/reaction_button.dart';
import 'package:poster_stock/themes/build_context_extension.dart';

import '../../../common/services/text_info_service.dart';
import '../../poster/view/pages/poster_page/poster_page.dart';
import '../../profile/view/pages/profile_page.dart';

class ListPage extends StatefulWidget {
  const ListPage({Key? key, required this.post}) : super(key: key);

  final MultiplePostModel post;

  @override
  State<ListPage> createState() => _ListPageState();
}

class _ListPageState extends State<ListPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController animationController;
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      lowerBound: 36,
      upperBound: 1000,
      duration: Duration.zero,
    );
    animationController.animateTo(250);
  }

  double velocity = 0;

  void jumpToEnd({bool? up}) {
    if (scrollController.offset == 0 || scrollController.offset == 250) return;
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        int durationValue = (200 *
                (1 - (animationController.value - 250 / 2).abs() / (250 / 2)))
            .round();
        if (durationValue < 50) durationValue = 50;
        if (up == false ||
            animationController.value > 250 * 0.5 && up != true) {
          scrollController.animateTo(
            0,
            duration: Duration(milliseconds: durationValue),
            curve: Curves.linear,
          );
        } else {
          scrollController.animateTo(
            250,
            duration: Duration(milliseconds: durationValue),
            curve: Curves.linear,
          );
        }
      },
    );
    if (up == false || animationController.value > 250 * 0.5 && up != true) {
      animationController.animateTo(
        250,
        duration: const Duration(milliseconds: 300),
      );
    } else {
      animationController.animateTo(
        0,
        duration: const Duration(milliseconds: 300),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerUp: (details) {
        if (scrollController.offset > 250) return;
        if (scrollController.offset < 0) return;
        if (velocity > 15) {
          jumpToEnd(up: false);
        } else if (velocity < -15) {
          jumpToEnd(up: true);
        } else {
          jumpToEnd();
        }
      },
      child: Scaffold(
        body: Stack(
          children: [
            NotificationListener<ScrollNotification>(
              onNotification: (notification) {
                if (notification is ScrollUpdateNotification) {
                  velocity = notification.dragDetails?.delta.dy ?? 0;
                  if (notification.metrics.pixels < 0) {
                    animationController
                        .animateTo(250 - notification.metrics.pixels);
                  } else {
                    animationController
                        .animateTo(250 - notification.metrics.pixels);
                  }
                }
                if (notification is ScrollEndNotification) {
                  if (notification.metrics.pixels > 250) return false;
                  if (notification.metrics.pixels < 0) return false;
                  jumpToEnd();
                }
                return true;
              },
              child: CustomScrollView(
                physics: AlwaysScrollableScrollPhysics(
                    parent: BouncingScrollPhysics()),
                controller: scrollController,
                slivers: [
                  SliverAppBar(
                    backgroundColor: context.colors.backgroundsPrimary,
                    elevation: 0,
                    leadingWidth: 130,
                    toolbarHeight: 42,
                    expandedHeight: 292,
                    collapsedHeight: 42,
                    pinned: true,
                    leading: const CustomBackButton(),
                    actions: [
                      GestureDetector(
                        onTap: () {
                          showModalBottomSheet(
                            context: context,
                            backgroundColor: Colors.transparent,
                            isScrollControlled: true,
                            builder: (context) => GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Container(
                                color: Colors.transparent,
                                child: const ListActionsDialog(),
                              ),
                            ),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(right: 16),
                          child: SvgPicture.asset(
                            'assets/icons/ic_dots.svg',
                            colorFilter: ColorFilter.mode(
                              context.colors.iconsDefault!,
                              BlendMode.srcIn,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  SliverPadding(
                    padding: EdgeInsets.symmetric(vertical: 16.0),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          if (index == 0) {
                            return CollectionInfoWidget(
                              post: widget.post,
                            );
                          }
                          if (index == widget.post.comments.length + 1) {
                            return SizedBox(
                              height: getEmptySpaceHeightForCollection(
                                          context) <
                                      56 + MediaQuery.of(context).padding.bottom
                                  ? 56 + MediaQuery.of(context).padding.bottom
                                  : getEmptySpaceHeightForCollection(context),
                            );
                          }
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 6.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0,
                                  ),
                                  child: UserInfoTile(
                                    showFollowButton: false,
                                    user: widget.post.comments[index - 1].user,
                                    time: widget.post.comments[index - 1].time,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Row(
                                  children: [
                                    const SizedBox(
                                      width: 68,
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            widget.post.comments[index - 1]
                                                .comment,
                                            style:
                                                context.textStyles.subheadline,
                                          ),
                                          const SizedBox(height: 12),
                                          if (index - 1 !=
                                              widget.post.comments.length - 1)
                                            Divider(
                                              height: 0.5,
                                              thickness: 0.5,
                                              color:
                                                  context.colors.fieldsDefault,
                                            ),
                                        ],
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          );
                        },
                        childCount: 2 + widget.post.comments.length,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SafeArea(
              child: IgnorePointer(
                ignoring: true,
                child: AnimatedBuilder(
                  animation: animationController,
                  builder: (context, child) {
                    return Transform.translate(
                      offset: Offset(0,
                          (animationController.value - 36) / (250 - 36) * 42),
                      child: Transform.scale(
                        alignment: Alignment.topCenter,
                        scale: animationController.value / 250 > 1
                            ? ((250 + (animationController.value - 250) * 0.8) /
                                250)
                            : animationController.value / 250,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular((1 -
                                  (animationController.value - 36) /
                                      (250 - 36)) *
                              20),
                          child: child,
                        ),
                      ),
                    );
                  },
                  child: Row(
                    children: List.generate(
                      widget.post.posters.length,
                      (index) => Expanded(
                        child: Image.network(
                          widget.post.posters[index],
                          height: 250,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: CommentTextField(),
            )
          ],
        ),
      ),
    );
  }

  double getEmptySpaceHeightForCollection(BuildContext context) {
    double result = widget.post.comments.length * 80 + 180;
    result += TextInfoService.textSize(
      widget.post.name,
      context.textStyles.title3!,
      MediaQuery.of(context).size.width - 32,
    ).height;
    result += TextInfoService.textSize(
      (widget.post.description ?? '').length > 280
          ? widget.post.description!.substring(0, 280)
          : (widget.post.description ?? ''),
      context.textStyles.subheadline!,
      MediaQuery.of(context).size.width - 32,
    ).height;
    result += (widget.post.posters.length % 3 == 0
            ? widget.post.posters.length / 3
            : widget.post.posters.length ~/ 3 + 1) *
        212;
    result += 32;
    for (var comment in widget.post.comments) {
      result += TextInfoService.textSize(
        comment.comment,
        context.textStyles.subheadline!,
        MediaQuery.of(context).size.width - 84,
      ).height;
    }
    return MediaQuery.of(context).size.height - result < 0
        ? 0
        : MediaQuery.of(context).size.height - result;
  }
}

class CollectionInfoWidget extends StatelessWidget {
  const CollectionInfoWidget({Key? key, required this.post}) : super(key: key);

  final MultiplePostModel post;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          UserInfoTile(
            user: post.author,
            showSettings: false,
            time: post.time,
          ),
          const SizedBox(height: 16),
          Text(
            post.name,
            style: context.textStyles.title3,
          ),
          const SizedBox(height: 20),
          Text(
            (post.description ?? '').length > 140
                ? post.description!.substring(0, 140)
                : (post.description ?? ''),
            style: context.textStyles.subheadline,
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              const Spacer(),
              ReactionButton(
                iconPath: 'assets/icons/ic_heart.svg',
                iconColor: context.colors.iconsDisabled!,
                amount: post.likes.length,
              ),
              const SizedBox(width: 12),
              ReactionButton(
                iconPath: 'assets/icons/ic_comment2.svg',
                iconColor: context.colors.iconsDisabled!,
                amount: post.comments.length,
              ),
            ],
          ),
          const SizedBox(height: 16),
          Divider(
            height: 0.5,
            thickness: 0.5,
            color: context.colors.fieldsDefault,
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: (post.posters.length % 3 == 0
                    ? post.posters.length / 3
                    : post.posters.length ~/ 3 + 1) *
                212,
            child: GridView.builder(
              padding: EdgeInsets.zero,
              physics: const NeverScrollableScrollPhysics(
                parent: BouncingScrollPhysics(),
              ),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 12.5,
                mainAxisSpacing: 15,
                mainAxisExtent:
                    ((MediaQuery.of(context).size.width - 57) / 3) / 106 * 200,
              ),
              itemCount: post.posters.length,
              itemBuilder: (context, index) {
                return PostsCollectionTile(
                  imagePath: post.posters[index],
                  name: post.posterNames[index],
                  index: index,
                  year: '1999',
                  customOnLongTap: () {},
                );
              },
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

class ListActionsDialog extends ConsumerWidget {
  const ListActionsDialog({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: SizedBox(
        height: 310,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(16.0),
                child: SizedBox(
                  height: 190,
                  child: Material(
                    color: context.colors.backgroundsPrimary,
                    child: Column(
                      children: [
                        SizedBox(
                          height: 36,
                          child: Center(
                            child: Text(
                              'List',
                              style: context.textStyles.footNote!.copyWith(
                                color: context.colors.textsSecondary,
                              ),
                            ),
                          ),
                        ),
                        Divider(
                          height: 0.5,
                          thickness: 0.5,
                          color: context.colors.fieldsDefault,
                        ),
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              print(1);
                            },
                            child: Center(
                              child: Text(
                                'Follow',
                                style: context.textStyles.bodyRegular!.copyWith(
                                  color: context.colors.textsPrimary,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Divider(
                          height: 0.5,
                          thickness: 0.5,
                          color: context.colors.fieldsDefault,
                        ),
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              print(1);
                            },
                            child: Center(
                              child: Text(
                                'Share',
                                style: context.textStyles.bodyRegular!.copyWith(
                                  color: context.colors.textsPrimary,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Divider(
                          height: 0.5,
                          thickness: 0.5,
                          color: context.colors.fieldsDefault,
                        ),
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              print(1);
                            },
                            child: Center(
                              child: Text(
                                'Report',
                                style: context.textStyles.bodyRegular!.copyWith(
                                  color: context.colors.textsError,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(16.0),
                child: SizedBox(
                  height: 52,
                  child: Material(
                    color: context.colors.backgroundsPrimary,
                    child: InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Center(
                        child: Text(
                          'Cancel',
                          style: context.textStyles.bodyRegular,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
