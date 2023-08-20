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
                        ref.read(searchControllerProvider).updateSearch(value);
                      },
                      onRemoved: () {
                        ref.read(searchControllerProvider).updateSearch('');
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
                      ref.read(searchControllerProvider).updateSearch('');
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
    final posters = List.generate(
      0,
      (index) => PostMovieModel(
          timeDate: DateTime.now(),
          liked: false,
          id: 1,
          year: '2020',
          imagePath: index % 2 == 0
              ? 'https://m.media-amazon.com/images/I/61YwNp4JaPL._AC_UF1000,1000_QL80_.jpg'
              : 'https://m.media-amazon.com/images/I/51ifcV+yjPL._AC_.jpg',
          name: index % 2 == 0 ? 'Joker' : 'The Walking Dead',
          author: UserModel(
            id: 12,
            name: 'Name $index',
            username: 'username$index',
            followed: index % 2 == 0,
            imagePath: index % 2 == 0
                ? 'https://sun9-19.userapi.com/impg/JYz26AJyJy7WGCILcB53cuVK7IgG8kz7mW2h7g/YuMDQr8n2Lc.jpg?size=300x245&quality=96&sign=a881f981e785f06c51dff40d3262565f&type=album'
                : 'https://sun9-63.userapi.com/impg/eV4ZjNdv2962fzcxP3sivERc4kN64GhCFTRNZw/_5JxseMZ_0g.jpg?size=267x312&quality=95&sign=efb3d7b91e0b102fa9b62d7dc8724050&type=album',
          ),
          time: '12:00',
          description:
              "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum."),
    );
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
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
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
              ListView.separated(
                physics: const AlwaysScrollableScrollPhysics(
                  parent: BouncingScrollPhysics(),
                ),
                itemCount: posters.length,
                itemBuilder: (context, index) {
                  return PostBase(
                    index: index,
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
              GridView.builder(
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
            ],
          ),
        ),
      ],
    );
  }
}
