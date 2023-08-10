import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:poster_stock/common/widgets/custom_scaffold.dart';
import 'package:poster_stock/features/home/models/user_model.dart';
import 'package:poster_stock/features/profile/models/user_details_model.dart';
import 'package:poster_stock/features/profile/state_holders/profile_info_state_holder.dart';
import 'package:poster_stock/features/search/view/widgets/search_user_tile.dart';
import 'package:poster_stock/features/users_list/controllers/users_list_controller.dart';
import 'package:poster_stock/features/users_list/state_hodlers/users_list_state_holder.dart';
import 'package:poster_stock/themes/build_context_extension.dart';

class UsersListPage extends ConsumerStatefulWidget {
  const UsersListPage({
    super.key,
    this.following = false,
  });

  final bool following;

  @override
  ConsumerState<UsersListPage> createState() => _UsersListPageState();
}

class _UsersListPageState extends ConsumerState<UsersListPage> {

  @override
  void initState() {
    super.initState();
    Future(() {
      ref.read(usersListControllerProvider).clearUsers();
      final id = ref.watch(profileInfoStateHolderProvider)?.id;
      ref.read(usersListControllerProvider).getUsers(
        id: id!,
        followers: !widget.following,
      );
    });
  }
  @override
  Widget build(BuildContext context) {
    final users = ref.watch(userListStateHolderProvider);
    return CustomScaffold(
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
                  AutoRouter.of(context).pop();
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
              widget.following ? 'Following' : 'Followers',
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
                          user: users![index],
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
                  childCount: users!.length,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
