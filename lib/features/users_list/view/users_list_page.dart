import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:poster_stock/common/state_holders/router_state_holder.dart';
import 'package:poster_stock/common/widgets/custom_scaffold.dart';
import 'package:poster_stock/features/search/view/widgets/search_user_tile.dart';
import 'package:poster_stock/features/users_list/controllers/users_list_controller.dart';
import 'package:poster_stock/features/users_list/state_hodlers/users_list_state_holder.dart';
import 'package:poster_stock/themes/build_context_extension.dart';

@RoutePage()
class UsersListPage extends ConsumerStatefulWidget {
  const UsersListPage({
    super.key,
    this.following = false,
    required this.id,
  });

  final bool following;
  final int id;

  @override
  ConsumerState<UsersListPage> createState() => _UsersListPageState();
}

class _UsersListPageState extends ConsumerState<UsersListPage> {
  @override
  void initState() {
    super.initState();
    Future(() {
      ref.read(usersListControllerProvider).clearUsers();
      ref.read(usersListControllerProvider).getUsers(
            id: widget.id,
            followers: !widget.following,
          );
    });
  }

  @override
  void dispose() {
    ref.read(usersListControllerProvider).clearUsers();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final users = ref.watch(userListStateHolderProvider);
    return CustomScaffold(
      child: NotificationListener<ScrollUpdateNotification>(
        onNotification: (info) {
          if (info.metrics.pixels >=
              info.metrics.maxScrollExtent -
                  MediaQuery.of(context).size.height) {
            ref.read(usersListControllerProvider).getUsers(
                  id: widget.id,
                  followers: !widget.following,
                );
          }
          return true;
        },
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(
            parent: BouncingScrollPhysics(),
          ),
          slivers: [
            SliverAppBar(
              leadingWidth: 130,
              leading: Align(
                alignment: Alignment.centerLeft,
                child: GestureDetector(
                  onTap: () {
                    ref.watch(router)!.pop();
                  },
                  child: Container(
                    color: Colors.transparent,
                    padding: const EdgeInsets.only(left: 7.0, right: 40.0),
                    child: SvgPicture.asset(
                      'assets/icons/back_icon.svg',
                      width: 18,
                      colorFilter: ColorFilter.mode(
                        context.colors.iconsDefault!,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                ),
              ),
              backgroundColor: context.colors.backgroundsPrimary,
              centerTitle: true,
              title: Text(
                widget.following
                    ? context.txt.profile_following
                    : context.txt.profile_followers,
                style: context.textStyles.bodyBold,
              ),
              floating: true,
              snap: true,
              elevation: 0,
              collapsedHeight: 42,
              toolbarHeight: 42,
              expandedHeight: 42,
            ),
            if (users == null)
              SliverFillRemaining(
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
            if (users != null)
              SliverPadding(
                padding: const EdgeInsets.only(top: 8.0),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      return Column(
                        children: [
                          SearchUserTile(
                            user: users[index],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 80.0),
                            child: Divider(
                              height: 1,
                              thickness: 1,
                              color: context.colors.fieldsDefault,
                            ),
                          ),
                        ],
                      );
                    },
                    childCount: users.length,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
