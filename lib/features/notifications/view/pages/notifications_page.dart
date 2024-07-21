import 'dart:math';

import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:poster_stock/common/helpers/custom_ink_well.dart';
import 'package:poster_stock/common/widgets/custom_scaffold.dart';
import 'package:poster_stock/features/auth/view/widgets/custom_app_bar.dart';
import 'package:poster_stock/features/notifications/controllers/notifications_controller.dart';
import 'package:poster_stock/features/notifications/models/notification_model.dart';
import 'package:poster_stock/features/notifications/state_holders/notifications_state_holder.dart';
import 'package:poster_stock/features/notifications/view/empty_notifications_widget.dart';
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
              top: 68,
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
                  leading: const CustomBackButton(),
                  backgroundColor: context.colors.backgroundsPrimary,
                  centerTitle: true,
                  title: Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Text(
                      AppLocalizations.of(context)!.notification_notifications,
                      style: context.textStyles.bodyBold,
                    ),
                  ),
                  floating: true,
                  snap: true,
                  elevation: 0,
                  collapsedHeight: 42 + 16,
                  toolbarHeight: 42 + 16,
                  expandedHeight: 42 + 16,
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
                        if (notifications.length <= index) {
                          return const SizedBox();
                        }
                        return Column(
                          children: [
                            if (index != 0)
                              Padding(
                                padding: const EdgeInsets.only(left: 80.0),
                                child: Divider(
                                  height: 1,
                                  thickness: 1,
                                  color: context.colors.fieldsDefault,
                                ),
                              ),
                            NotificationTile(
                              notification: notifications[index],
                            ),
                          ],
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
          ref.watch(router)!.pushNamed(
                notification.deepLink,
              );
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  AutoRouter.of(context)
                      .pushNamed(notification.profileDeepLink);
                },
                child: CircleAvatar(
                    radius: 24,
                    backgroundImage: notification.profileImage == null
                        ? null
                        : CachedNetworkImageProvider(
                            notification.profileImage!),
                    backgroundColor: avatar[Random().nextInt(3)],
                    child: notification.profileImage == null
                        ? Text(
                            getAvatarName(notification.name).toUpperCase(),
                            style: context.textStyles.calloutBold!.copyWith(
                              color: context.colors.textsBackground,
                            ),
                          )
                        : const SizedBox()),
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
                        text: notification.name,
                        style: context.textStyles.subheadlineBold,
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            AutoRouter.of(context)
                                .pushNamed(notification.profileDeepLink);
                          },
                        children: [
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
                      NotificationModel.getTimeString(notification.time),
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
