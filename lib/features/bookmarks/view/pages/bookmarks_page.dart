import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:poster_stock/common/state_holders/router_state_holder.dart';
import 'package:poster_stock/common/widgets/custom_scaffold.dart';
import 'package:poster_stock/features/home/models/post_movie_model.dart';
import 'package:poster_stock/features/home/models/user_model.dart';
import 'package:poster_stock/features/home/view/widgets/post_base.dart';
import 'package:poster_stock/themes/build_context_extension.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

final posters = List.generate(
  300,
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
      description: index % 2 == 0
          ? "industry"
          : "Lorem IpsumLorem IpsumLorem IpsumLorem Ipsum Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum."),
);

@RoutePage()
class BookmarksPage extends ConsumerWidget {
  BookmarksPage({
    Key? key,
    this.startIndex = 0,
  }) : super(key: key);
  final int startIndex;
  final ItemScrollController scrollController = ItemScrollController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final List<PostMovieModel> bookmarks = posters;
    Future(() {
      scrollController.jumpTo(index: startIndex);
    });
    final List<PostBase> posts = List.generate(
      bookmarks.length,
      (index) => PostBase(
        showSuggestion: false,
        index: index,
      ),
    );
    return CustomScaffold(
      child: Column(
        children: [
          AppBar(
            backgroundColor: context.colors.backgroundsPrimary,
            elevation: 0,
            leadingWidth: 130,
            toolbarHeight: 42,
            titleSpacing: 0,
            centerTitle: true,
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
            title: Text(
              'Your bookmarks',
              style: context.textStyles.bodyBold,
            ),
          ),
          /*Expanded(
            child: ListView.separated(
              controller: scrollController,
              itemCount: bookmarks.length,
              itemBuilder: (context, index) {
                return posts[index];
              },
              separatorBuilder: (context, index) => Divider(
                height: 0.5,
                thickness: 0.5,
                color: context.colors.fieldsDefault,
              ),
            ),
          ),*/
          Expanded(
            child: ScrollablePositionedList.separated(
              itemScrollController: scrollController,
              itemCount: bookmarks.length,
              itemBuilder: (context, index) {
                return posts[index];
              },
              separatorBuilder: (context, index) => Divider(
                height: 0.5,
                thickness: 0.5,
                color: context.colors.fieldsDefault,
              ),
            ),
          )
        ],
      ),
    );
  }
}
