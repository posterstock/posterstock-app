import 'dart:io';
import 'dart:math';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:poster_stock/common/helpers/custom_ink_well.dart';
import 'package:poster_stock/common/widgets/custom_scaffold.dart';
import 'package:poster_stock/features/home/models/user_model.dart';
import 'package:poster_stock/features/notifications/controllers/notifications_controller.dart';
import 'package:poster_stock/features/notifications/models/notification_model.dart';
import 'package:poster_stock/features/notifications/state_holders/notifications_state_holder.dart';
import 'package:poster_stock/features/notifications/view/empty_notifications_widget.dart';
import 'package:poster_stock/features/profile/models/user_details_model.dart';
import 'package:poster_stock/features/profile/view/empty_collection_widget.dart';
import 'package:poster_stock/navigation/app_router.gr.dart';
import 'package:poster_stock/themes/build_context_extension.dart';

import '../../../../common/state_holders/router_state_holder.dart';

@RoutePage()
class NotificationsPage extends ConsumerWidget {
  const NotificationsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifications = ref.watch(notificationsStateHolderProvider);
    if (notifications == null) {
      ref.read(notificationsControllerProvider).getNotificationsData();
    }
    final controller = ScrollController();
    bool keepOffset = false;
    return NotificationListener<ScrollUpdateNotification>(
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
              .read(notificationsControllerProvider)
              .getNotificationsData(
                getNewPosts: true,
              )
              .then((value) {
            keepOffset = false;
            Future.delayed(const Duration(seconds: 3), () {
              keepOffset = false;
            });
          });
        }
        if (keepOffset) {
          controller.jumpTo(
            -50,
          );
        }
        if (n.metrics.pixels >=
            n.metrics.maxScrollExtent - MediaQuery.of(context).size.height) {
          ref.read(notificationsControllerProvider).getNotificationsData();
        }
        return false;
      },
      child: CustomScaffold(
        child: Stack(
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
            CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(
                parent: BouncingScrollPhysics(),
              ),
              controller: controller,
              slivers: [
                SliverAppBar(
                  leading: const SizedBox(),
                  backgroundColor: context.colors.backgroundsPrimary,
                  centerTitle: true,
                  title: Text(
                    AppLocalizations.of(context)!.notifications,
                    style: context.textStyles.bodyBold,
                  ),
                  floating: true,
                  snap: true,
                  elevation: 0,
                  collapsedHeight: 42,
                  toolbarHeight: 42,
                  expandedHeight: 42,
                ),
                if (notifications?.isEmpty == true)
                  SliverToBoxAdapter(
                    child: Container(
                      color: context.colors.backgroundsPrimary,
                      height: MediaQuery.of(context).size.height - 200,
                      child: const Center(
                        child: EmptyNotificationsWidget(),
                      ),
                    ),
                  ),
                if (notifications == null)
                  SliverToBoxAdapter(
                    child: Container(
                      color: context.colors.backgroundsPrimary,
                      height: MediaQuery.of(context).size.height - 200,
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
                  ),
                if (notifications != null)
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      childCount:
                          notifications.isEmpty ? 1 : notifications.length,
                      (context, index) {
                        if (notifications.isEmpty) {
                          return Container(
                            height: 78,
                            color: context.colors.backgroundsPrimary,
                          );
                        }
                        if (notifications.length <= index) return SizedBox();
                        return NotificationTile(
                          notification: notifications[index],
                        );
                      },
                    ),
                  )
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class NotificationTile extends ConsumerWidget {
  const NotificationTile({
    Key? key,
    required this.notification,
  }) : super(key: key);

  final NotificationModel notification;
  static const List<Color> avatar = [
    Color(0xfff09a90),
    Color(0xfff3d376),
    Color(0xff92bdf4),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Material(
      color: context.colors.backgroundsPrimary,
      child: CustomInkWell(
        onTap: () {
          print(notification.deepLink);
          ref.watch(router)!.pushNamed(
                notification.deepLink,
              );
        },
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              notification.image.isEmpty
                  ? CircleAvatar(
                      radius: 20,
                      backgroundImage: NetworkImage(notification.profileImage),
                      backgroundColor: avatar[Random().nextInt(3)],
                    )
                  : SizedBox(
                      width: 40,
                      height: 40,
                      child: Image.network(
                        notification.image,
                        fit: BoxFit.fitWidth,
                        loadingBuilder: (context, child, event) {
                          if (event?.expectedTotalBytes ==
                              event?.cumulativeBytesLoaded) return child;
                          return Container(
                            color: context.colors.backgroundsSecondary,
                          );
                        },
                        errorBuilder: (context, obj, err) {
                          return Container(
                            color: context.colors.backgroundsSecondary,
                          );
                        },
                      ),
                    ),
              const SizedBox(
                width: 16,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      text: TextSpan(
                        text: '${notification.info.split(' ')[0]} ',
                        style: context.textStyles.subheadlineBold!.copyWith(
                          fontWeight: Platform.isIOS ? FontWeight.w600 : null,
                        ),
                        children: [
                          TextSpan(
                            text: (notification.info.split(' ')..removeAt(0))
                                .join(' '),
                            style: context.textStyles.subheadline,
                          ),
                        ],
                      ),
                    ),
                    if (notification.time.isNotEmpty)
                      const SizedBox(
                        height: 8,
                      ),
                    if (notification.time.isNotEmpty)
                      Text(
                        notification.time,
                        style: context.textStyles.caption1!.copyWith(
                          color: context.colors.textsSecondary,
                        ),
                      )
                  ],
                ),
              )
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
