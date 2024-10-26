import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:poster_stock/common/state_holders/router_state_holder.dart';
import 'package:poster_stock/features/home/controller/home_page_posts_controller.dart';
import 'package:poster_stock/features/home/state_holders/home_page_posts_state_holder.dart';
import 'package:poster_stock/features/home/view/widgets/post_base.dart';
import 'package:poster_stock/features/notifications/state_holders/notifications_count_state_holder.dart';
import 'package:poster_stock/features/notifications/state_holders/notifications_state_holder.dart';
import 'package:poster_stock/navigation/app_router.gr.dart';
import 'package:poster_stock/themes/build_context_extension.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../state_holders/home_page_scroll_controller_state_holder.dart';

@RoutePage()
class HomePage extends ConsumerWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notsCount = ref.watch(notificationsCountStateHolderProvider);
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
            if (n.metrics.pixels >=
                controller.position.maxScrollExtent -
                    MediaQuery.of(context).size.height) {
              ref.read(homePagePostsControllerProvider).getPosts();
            }
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
                  .getPosts(getNewPosts: true)
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
                actions: [
                  GestureDetector(
                    onTap: () async {
                      ref.watch(router)!.push(const NotificationsRoute());
                      (await SharedPreferences.getInstance())
                          .setInt('notification_count', 0);
                      ref
                          .read(notificationsCountStateHolderProvider.notifier)
                          .updateState(0);
                      Future(() {
                        ref
                            .watch(notificationsStateHolderProvider.notifier)
                            .clear();
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(right: 16.0, top: 6.0),
                      child: Stack(
                        children: [
                          SizedBox(
                            width: 30,
                            height: 30,
                            child: Center(
                              child: SvgPicture.asset(
                                'assets/icons/ic_notification-2.svg',
                                colorFilter: ColorFilter.mode(
                                  context.colors.iconsDefault!,
                                  BlendMode.srcIn,
                                ),
                                width: 28.0,
                              ),
                            ),
                          ),
                          Positioned(
                            top: 0,
                            right: 0,
                            child: notsCount == 0
                                ? const SizedBox()
                                : Container(
                                    width: 15,
                                    height: 15,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: context.colors.buttonsError,
                                    ),
                                    child: Center(
                                      child: Text(
                                        notsCount.toString(),
                                        style: context.textStyles.caption2!
                                            .copyWith(
                                          color: context.colors.textsBackground,
                                        ),
                                      ),
                                    ),
                                  ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
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
                          if (posts?[index].isEmpty ?? false) {
                            return const SizedBox();
                          }

                          return PostBase(
                            key: Key(posts?[index][0].id.toString() ??
                                index.toString()),
                            index: index,
                          );
                        },
                      ),
                      if (posts?[index].isEmpty == false)
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
