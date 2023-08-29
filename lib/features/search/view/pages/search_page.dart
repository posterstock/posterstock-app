import 'package:auto_route/annotations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:poster_stock/common/widgets/app_text_field.dart';
import 'package:poster_stock/common/widgets/custom_scaffold.dart';
import 'package:poster_stock/common/widgets/list_grid_widget.dart';
import 'package:poster_stock/features/home/models/multiple_post_model.dart';
import 'package:poster_stock/features/home/models/post_movie_model.dart';
import 'package:poster_stock/features/home/models/user_model.dart';
import 'package:poster_stock/features/home/view/widgets/post_base.dart';
import 'package:poster_stock/features/navigation_page/controller/menu_controller.dart';
import 'package:poster_stock/features/navigation_page/state_holder/previous_page_state_holder.dart';
import 'package:poster_stock/features/profile/models/user_details_model.dart';
import 'package:poster_stock/features/search/controller/search_controller.dart';
import 'package:poster_stock/features/search/state_holders/search_posts_state_holder.dart';
import 'package:poster_stock/features/search/state_holders/search_users_state_holder.dart';
import 'package:poster_stock/features/search/state_holders/search_value_state_holder.dart';
import 'package:poster_stock/features/search/view/widgets/search_user_tile.dart';
import 'package:poster_stock/themes/build_context_extension.dart';

@RoutePage()
class SearchPage extends ConsumerWidget {
  SearchPage({Key? key}) : super(key: key);

  final TextEditingController textController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final text = ref.watch(searchValueStateHolderProvider);
    if (textController.text != text) {
      textController.text = text;
    }
    return CustomScaffold(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 12.0,
            ),
            child: SizedBox(
              height: 36,
              child: Row(
                children: [
                  Expanded(
                    child: AppTextField(
                      controller: textController,
                      searchField: true,
                      hint: 'Search',
                      removableWhenNotEmpty: true,
                      crossPadding: const EdgeInsets.all(8.0),
                      crossButton: SvgPicture.asset(
                        'assets/icons/search_cross.svg',
                      ),
                      onChanged: (value) {
                        ref.read(searchControllerProvider).startSearchUsers(value);
                      },
                      onRemoved: () {
                        ref.read(searchControllerProvider).startSearchUsers('');
                      },
                    ),
                  ),
                  const SizedBox(
                    width: 12,
                  ),
                  CupertinoButton(
                    padding: EdgeInsets.zero,
                    child: Text(
                      'Cancel',
                      style: context.textStyles.bodyRegular!.copyWith(
                        color: context.colors.textsAction,
                      ),
                    ),
                    onPressed: () {
                      ref.read(searchControllerProvider).startSearchUsers('');
                      textController.text = '';
                      ref.read(menuControllerProvider).backToPage(context,ref);
                    },
                  ),
                ],
              ),
            ),
          ),
          const Expanded(
            child: SearchPageContent(),
          ),
        ],
      ),
    );
  }
}

class SearchPageContent extends ConsumerWidget {
  const SearchPageContent({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchValue = ref.watch(searchValueStateHolderProvider);
    if (searchValue.isEmpty) return Container();
    return const SearchTabView();
  }
}

class SearchTabView extends ConsumerStatefulWidget {
  const SearchTabView({Key? key}) : super(key: key);

  @override
  SearchTabViewState createState() => SearchTabViewState();
}

class SearchTabViewState extends ConsumerState<SearchTabView>
    with SingleTickerProviderStateMixin {
  late final TabController controller;

  @override
  void initState() {
    controller = TabController(vsync: this, length: 3);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final users = ref.watch(searchUsersStateHolderProvider);
    final posters = ref.watch(searchPostsStateHolderProvider);
    final lists = [];
    return Column(
      children: [
        TabBar(
          dividerColor: Colors.transparent,
          controller: controller,
          indicatorColor: context.colors.iconsActive,
          tabs: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 14.0),
              child: Text(
                "Users",
                style: context.textStyles.subheadline,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 14.0),
              child: Text(
                "Posters",
                style: context.textStyles.subheadline,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 14.0),
              child: Text(
                "Lists",
                style: context.textStyles.subheadline,
              ),
            ),
          ],
        ),
        Expanded(
          child: TabBarView(
            controller: controller,
            children: [
              NotificationListener<ScrollUpdateNotification>(
                onNotification: (not) {
                  if (not.metrics.axisDirection == AxisDirection.down && not.metrics.pixels >= not.metrics.maxScrollExtent - MediaQuery.of(context).size.height) {
                    ref.read(searchControllerProvider).updateSearchUsers();
                  }
                  return true;
                },
                child: ListView.separated(
                  physics: const AlwaysScrollableScrollPhysics(
                    parent: BouncingScrollPhysics(),
                  ),
                  itemCount: users?.length ?? 0,
                  itemBuilder: (context, index) {
                    return SearchUserTile(user: users![index]);
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding: const EdgeInsets.only(left: 80.0),
                      child: Divider(
                        height: 1,
                        thickness: 1,
                        color: context.colors.fieldsDefault,
                      ),
                    );
                  },
                ),
              ),
              NotificationListener<ScrollUpdateNotification>(
                onNotification: (not) {
                  if (not.metrics.axisDirection == AxisDirection.down && not.metrics.pixels >= not.metrics.maxScrollExtent - MediaQuery.of(context).size.height) {
                    ref.read(searchControllerProvider).updateSearchPosts();
                  }
                  return true;
                },
                child: ListView.separated(
                  physics: const AlwaysScrollableScrollPhysics(
                    parent: BouncingScrollPhysics(),
                  ),
                  itemCount: posters?.length ?? 0,
                  itemBuilder: (context, index) {
                    return PostBase(
                      key: Key(posters![index].id.toString()),
                      poster: posters[index],
                      showSuggestion: false,
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return Divider(
                      height: 0.5,
                      thickness: 0.5,
                      color: context.colors.fieldsDefault,
                    );
                  },
                ),
              ),
              NotificationListener<ScrollUpdateNotification>(
                onNotification: (not) {
                  if (not.metrics.axisDirection == AxisDirection.down && not.metrics.pixels >= not.metrics.maxScrollExtent - MediaQuery.of(context).size.height) {
                    ref.read(searchControllerProvider).updateSearchLists();
                  }
                  return true;
                },
                child: GridView.builder(
                  padding: const EdgeInsets.all(16.0),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 13.0,
                    mainAxisSpacing: 16.0,
                    mainAxisExtent: 113,
                  ),
                  itemCount: lists.length,
                  itemBuilder: (context, index) {
                    return ListGridWidget(post: lists[index]);
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
