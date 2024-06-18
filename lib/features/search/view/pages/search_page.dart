import 'package:auto_route/annotations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:poster_stock/common/state_holders/router_state_holder.dart';
import 'package:poster_stock/common/widgets/app_text_field.dart';
import 'package:poster_stock/common/widgets/custom_scaffold.dart';
import 'package:poster_stock/common/widgets/list_grid_widget.dart';
import 'package:poster_stock/features/home/view/widgets/post_base.dart';
import 'package:poster_stock/features/search/controller/search_controller.dart';
import 'package:poster_stock/features/search/state_holders/search_lists_state_holder.dart';
import 'package:poster_stock/features/search/state_holders/search_posts_state_holder.dart';
import 'package:poster_stock/features/search/state_holders/search_users_state_holder.dart';
import 'package:poster_stock/features/search/state_holders/search_value_state_holder.dart';
import 'package:poster_stock/features/search/view/widgets/search_user_tile.dart';
import 'package:poster_stock/navigation/app_router.gr.dart';
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
                      autofocus: true,
                      controller: textController,
                      searchField: true,
                      hint: context.txt.search,
                      removableWhenNotEmpty: true,
                      crossPadding: const EdgeInsets.all(8.0),
                      crossButton: SvgPicture.asset(
                        'assets/icons/search_cross.svg',
                      ),
                      onChanged: (value) {
                        ref
                            .read(searchControllerProvider)
                            .startSearchUsers(value);
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
                      context.txt.cancel,
                      style: context.textStyles.bodyRegular!.copyWith(
                        color: context.colors.textsAction,
                      ),
                    ),
                    onPressed: () {
                      ref.read(searchControllerProvider).startSearchUsers('');
                      textController.text = '';
                      Navigator.of(context).pop();
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
    final lists = ref.watch(searchListsStateHolderProvider);
    return Column(
      children: [
        // TabBar(
        //   dividerColor: Colors.transparent,
        //   controller: controller,
        //   indicatorColor: context.colors.iconsActive,
        //   tabs: [
        //     Padding(
        //       padding: const EdgeInsets.symmetric(vertical: 14.0),
        //       child: Text(
        //         //TODO: localize
        //         "Users",
        //         style: context.textStyles.subheadline,
        //       ),
        //     ),
        //     Padding(
        //       padding: const EdgeInsets.symmetric(vertical: 14.0),
        //       child: Text(
        //         context.txt.posters,
        //         style: context.textStyles.subheadline,
        //       ),
        //     ),
        //     Padding(
        //       padding: const EdgeInsets.symmetric(vertical: 14.0),
        //       child: Text(
        //         context.txt.lists,
        //         style: context.textStyles.subheadline,
        //       ),
        //     ),
        //   ],
        // ),
        Expanded(
          child: TabBarView(
            controller: controller,
            children: [
              NotificationListener<ScrollUpdateNotification>(
                onNotification: (not) {
                  if (not.metrics.axisDirection == AxisDirection.down &&
                      not.metrics.pixels >=
                          not.metrics.maxScrollExtent -
                              MediaQuery.of(context).size.height) {
                    ref.read(searchControllerProvider).updateSearchUsers();
                  }
                  return true;
                },
                child: ListView.separated(
                  physics: const AlwaysScrollableScrollPhysics(
                    parent: BouncingScrollPhysics(),
                  ),
                  itemCount: users?.length == null || users!.isEmpty
                      ? 1
                      : users.length,
                  itemBuilder: (context, index) {
                    if (users?.length == null) {
                      return Padding(
                        padding: EdgeInsets.only(
                            top: (MediaQuery.of(context).size.height - 155) *
                                0.4),
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
                      );
                    }
                    if (users!.isEmpty) {
                      return Padding(
                        padding: EdgeInsets.only(
                            top: (MediaQuery.of(context).size.height - 155) *
                                0.4),
                        child: Text(
                          //TODO: localize
                          "No users found",
                          style: context.textStyles.subheadlineBold!.copyWith(
                            color: context.colors.textsDisabled,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      );
                    }
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
                  if (not.metrics.axisDirection == AxisDirection.down &&
                      not.metrics.pixels >=
                          not.metrics.maxScrollExtent -
                              MediaQuery.of(context).size.height) {
                    ref.read(searchControllerProvider).updateSearchPosts();
                  }
                  return true;
                },
                child: ListView.separated(
                  physics: const AlwaysScrollableScrollPhysics(
                    parent: BouncingScrollPhysics(),
                  ),
                  itemCount: posters?.length == null || posters!.isEmpty
                      ? 1
                      : posters.length,
                  itemBuilder: (context, index) {
                    if (posters?.length == null) {
                      return Padding(
                        padding: EdgeInsets.only(
                            top: (MediaQuery.of(context).size.height - 155) *
                                0.4),
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
                      );
                    }
                    if (posters!.isEmpty) {
                      return Padding(
                        padding: EdgeInsets.only(
                            top: (MediaQuery.of(context).size.height - 155) *
                                0.4),
                        child: Text(
                          context.txt.watchlist_empty,
                          style: context.textStyles.subheadlineBold!.copyWith(
                            color: context.colors.textsDisabled,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      );
                    }
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
                  if (not.metrics.axisDirection == AxisDirection.down &&
                      not.metrics.pixels >=
                          not.metrics.maxScrollExtent -
                              MediaQuery.of(context).size.height) {
                    ref.read(searchControllerProvider).updateSearchLists();
                  }
                  return true;
                },
                child: lists?.length == null || lists!.isEmpty
                    ? ListView.builder(
                        physics: const AlwaysScrollableScrollPhysics(
                          parent: BouncingScrollPhysics(),
                        ),
                        itemCount: 1,
                        itemBuilder: (context, index) {
                          if (lists?.length == null) {
                            return Padding(
                              padding: EdgeInsets.only(
                                  top: (MediaQuery.of(context).size.height -
                                          155) *
                                      0.4),
                              child: defaultTargetPlatform !=
                                      TargetPlatform.android
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
                            );
                          }
                          if (lists!.isEmpty) {
                            return Padding(
                              padding: EdgeInsets.only(
                                  top: (MediaQuery.of(context).size.height -
                                          155) *
                                      0.4),
                              child: Text(
                                //TODO: localize
                                "No search results found",
                                style: context.textStyles.subheadlineBold!
                                    .copyWith(
                                  color: context.colors.textsDisabled,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            );
                          }
                          return const SizedBox();
                        })
                    : GridView.builder(
                        padding: const EdgeInsets.all(16.0),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 13.0,
                          mainAxisSpacing: 16.0,
                          mainAxisExtent:
                              ((MediaQuery.of(context).size.width - 16.0 * 3) /
                                          2) /
                                      540 *
                                      300 +
                                  23,
                        ),
                        itemCount: lists.length,
                        itemBuilder: (context, index) {
                          return ListGridWidget(
                              (post) => ref.watch(router)!.push(ListRoute(
                                    id: post!.id,
                                  )),
                              post: lists[index]);
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
