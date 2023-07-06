import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:poster_stock/common/widgets/custom_scaffold.dart';
import 'package:poster_stock/features/profile/models/user_details_model.dart';
import 'package:poster_stock/features/search/view/widgets/search_user_tile.dart';
import 'package:poster_stock/themes/build_context_extension.dart';

class UsersListPage extends StatelessWidget {
  const UsersListPage({
    super.key,
    this.following = false,
    required this.user,
  });

  final bool following;
  final List<UserDetailsModel> user;

  @override
  Widget build(BuildContext context) {
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
              following ? 'Following' : 'Followers',
              style: context.textStyles.bodyBold,
            ),
            floating: true,
            snap: true,
            elevation: 0,
            collapsedHeight: 42,
            toolbarHeight: 42,
            expandedHeight: 42,
          ),
          SliverPadding(
            padding: const EdgeInsets.only(top: 8.0),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  return Column(
                    children: [
                      SearchUserTile(
                        user: user[index],
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
                childCount: user.length,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
