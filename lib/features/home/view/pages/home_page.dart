import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:poster_stock/features/home/controller/home_page_posts_controller.dart';
import 'package:poster_stock/features/home/models/multiple_post_model.dart';
import 'package:poster_stock/features/home/models/post_base_model.dart';
import 'package:poster_stock/features/home/models/post_movie_model.dart';
import 'package:poster_stock/features/home/state_holders/home_page_posts_state_holder.dart';
import 'package:poster_stock/features/home/view/widgets/post_base.dart';
import 'package:poster_stock/themes/build_context_extension.dart';

import '../../state_holders/home_page_scroll_controller_state_holder.dart';

class HomePage extends ConsumerWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(homePageScrollControllerStateHolderProvider);
    final posts = ref.watch(homePagePostsStateHolderProvider);
    Future postsFuture = Future(() async {});
    if (posts == null) {
      postsFuture = ref.read(homePagePostsControllerProvider).getPosts();
    }
    bool keepOffset = false;
    return Stack(
      children: [
        Positioned(
          top: 58,
          right: 0,
          left: 0,
          child: Center(
            child: defaultTargetPlatform != TargetPlatform.android
                ? const CupertinoActivityIndicator(
                    radius: 10,
                  )
                : SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      color: context.colors.iconsDisabled!,
                      strokeWidth: 2,
                    ),
                  ),
          ),
        ),
        NotificationListener<ScrollUpdateNotification>(
          onNotification: (n) {
            if (n.metrics.pixels <= -120 && n.metrics.axis == Axis.vertical) {
              controller.animateTo(
                -50,
                duration: const Duration(milliseconds: 300),
                curve: Curves.linear,
              );
              Future.delayed(const Duration(milliseconds: 300), () {
                keepOffset = true;
              });
              ref
                  .read(homePagePostsControllerProvider)
                  .getPosts()
                  .then((value) {
                keepOffset = false;
              });
            }
            if (keepOffset) {
              controller.jumpTo(
                -50,
              );
            }
            return false;
          },
          child: CustomScrollView(
            controller: controller,
            physics: const AlwaysScrollableScrollPhysics(
                parent: BouncingScrollPhysics()),
            slivers: [
              SliverAppBar(
                leading: const SizedBox(),
                backgroundColor: context.colors.backgroundsPrimary,
                centerTitle: true,
                title: SvgPicture.asset(
                  'assets/icons/logo.svg',
                  width: 30,
                ),
                floating: true,
                snap: true,
                elevation: 0,
                collapsedHeight: 42,
                toolbarHeight: 42,
                expandedHeight: 42,
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  childCount: posts?.length,
                  (context, index) => Column(
                    children: [
                      FutureBuilder(
                        future: postsFuture,
                        builder: (context, snapshot) {
                          if (posts != null && posts.length > index) {
                            if (posts[index][0] is MultiplePostModel) {
                              return PostBase(
                                multPost: posts[index][0] as MultiplePostModel,
                              );
                            } else {
                              return PostBase(
                                post: (posts[index])
                                    .map((e) => (e as PostMovieModel))
                                    .toList(),
                              );
                            }
                          }
                          return PostBase();
                        },
                      ),
                      Divider(
                        color: context.colors.fieldsDefault,
                        height: 1,
                        thickness: 1,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
