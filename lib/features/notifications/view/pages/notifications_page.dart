import 'dart:math';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
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

class NotificationsPage extends ConsumerWidget {
  const NotificationsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifications = ref.watch(notificationsStateHolderProvider);
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
              .getNotificationsData()
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
                if (notifications == null)
                  SliverToBoxAdapter(
                    child: Container(
                      color: context.colors.backgroundsPrimary,
                      height: MediaQuery.of(context).size.height - 200,
                      child: const Center(
                        child: EmptyNotificationsWidget(),
                      ),
                    ),
                  ),
                if (notifications != null)
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        if (notifications!.isEmpty) {
                          return Container(
                            height: 78,
                            color: context.colors.backgroundsPrimary,
                          );
                        }
                        return NotificationTile(
                          notification: notifications[index],
                          onTap: () {
                            print(1);
                          },
                        );
                      },
                      childCount: notifications == null
                          ? 0
                          : (notifications.isEmpty ? 1 : notifications.length),
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

class NotificationTile extends StatelessWidget {
  const NotificationTile({
    Key? key,
    required this.notification,
    required this.onTap,
  }) : super(key: key);

  final NotificationModel notification;
  final void Function() onTap;

  static const List<Color> avatar = [
    Color(0xfff09a90),
    Color(0xfff3d376),
    Color(0xff92bdf4),
  ];

  @override
  Widget build(BuildContext context) {
    return Material(
      color: context.colors.backgroundsPrimary,
      child: CustomInkWell(
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () {
                  AutoRouter.of(context).push(
                    ProfileRoute(
                      user: UserModel(
                        id: 1,
                        name: notification.user.name,
                        username: notification.user.username,
                        followed: notification.user.followed,
                        imagePath: notification.user.imagePath,
                        description: notification.user.description,
                      ),
                    ),
                  );
                },
                child: CircleAvatar(
                  radius: 20,
                  backgroundImage: notification.user.imagePath != null
                      ? NetworkImage(notification.user.imagePath!)
                      : null,
                  backgroundColor: avatar[Random().nextInt(3)],
                  child: notification.user.imagePath == null
                      ? Text(
                          getAvatarName(notification.user.name).toUpperCase(),
                          style: context.textStyles.calloutBold!.copyWith(
                            color: context.colors.textsBackground,
                          ),
                        )
                      : const SizedBox(),
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
                        text: '${notification.user.name} ',
                        style: context.textStyles.subheadlineBold,
                        children: <TextSpan>[
                          TextSpan(
                            text: notification.info,
                            style: context.textStyles.subheadline,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
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
