import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:poster_stock/common/menu/menu_dialog.dart';
import 'package:poster_stock/common/menu/menu_state.dart';
import 'package:poster_stock/common/state_holders/router_state_holder.dart';
import 'package:poster_stock/common/widgets/app_snack_bar.dart';
import 'package:poster_stock/common/widgets/custom_scaffold.dart';
import 'package:poster_stock/features/bookmarks/controller/bookmarks_controller.dart';
import 'package:poster_stock/features/bookmarks/state_holders/bookmark_list_state_holder.dart';
import 'package:poster_stock/features/home/view/widgets/post_base.dart';
import 'package:poster_stock/features/poster/controller/comments_controller.dart';
import 'package:poster_stock/features/profile/state_holders/profile_bookmarks_state_holder.dart';
import 'package:poster_stock/main.dart';
import 'package:poster_stock/themes/build_context_extension.dart';
import 'package:url_launcher/url_launcher_string.dart';

@RoutePage()
class BookmarksPage extends ConsumerStatefulWidget {
  final int id;
  final int mediaId;
  final String tmdbLink;

  const BookmarksPage({
    Key? key,
    required this.id,
    required this.mediaId,
    required this.tmdbLink,
  }) : super(key: key);

  @override
  ConsumerState<BookmarksPage> createState() => _BookmarksPageState();
}

class _BookmarksPageState extends ConsumerState<BookmarksPage> {
  @override
  void initState() {
    super.initState();
    Future(() {
      ref.read(bookmarksControllerProvider).clearBookmarks();
      ref.read(bookmarksControllerProvider).setId(widget.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    final bookmarks = ref.watch(bookmarksListStateHolderProvider);
    if (bookmarks == null) {
      Future(() {
        ref.read(bookmarksControllerProvider).getBookmarks(restart: true);
      });
    }
    final List<PostBase> posts = List.generate(
      bookmarks?.length ?? 0,
      (index) => PostBase(
        showSuggestion: false,
        poster: bookmarks![index],
      ),
    );
    return CustomScaffold(
      child: Column(
        children: [
          AppBar(
            backgroundColor: context.colors.backgroundsPrimary,
            elevation: 0,
            leadingWidth: 80,
            toolbarHeight: 42,
            titleSpacing: 0,
            centerTitle: false,
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
              'Watchlist: Community posters',
              style: context.textStyles.bodyBold,
            ),
            actions: [
              IconButton(
                onPressed: () => _showMenu(context),
                icon: SvgPicture.asset(
                  'assets/icons/ic_dots.svg',
                  width: 24,
                  height: 24,
                  colorFilter: ColorFilter.mode(
                    context.colors.iconsDefault!,
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            child: bookmarks?.isNotEmpty != true
                ? Center(
                    child: bookmarks == null
                        ? defaultTargetPlatform != TargetPlatform.android
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
                              )
                        : Text(
                            'No one has added this poster',
                            style: context.textStyles.subheadlineBold!.copyWith(
                              color: context.colors.textsDisabled,
                            ),
                            textAlign: TextAlign.center,
                          ),
                  )
                : NotificationListener<ScrollUpdateNotification>(
                    onNotification: (info) {
                      if (info.metrics.pixels >=
                          info.metrics.maxScrollExtent -
                              MediaQuery.of(context).size.height) {
                        ref.read(bookmarksControllerProvider).getBookmarks();
                      }
                      return true;
                    },
                    child: ListView.separated(
                      itemCount: bookmarks?.length ?? 0,
                      itemBuilder: (context, index) {
                        return posts[index];
                      },
                      separatorBuilder: (context, index) => Divider(
                        height: 0.5,
                        thickness: 0.5,
                        color: context.colors.fieldsDefault,
                      ),
                    ),
                  ),
          )
        ],
      ),
    );
  }

  void _showMenu(
    BuildContext context,
  ) async {
    await MenuDialog.showBottom(
      context,
      MenuState(null, [
        MenuItem(
          'assets/icons/ic_arrow_out.svg',
          context.txt.poster_menu_openTMDB,
          () {
            launchUrlString(widget.tmdbLink);
          },
        ),
        MenuItem(
          'assets/icons/ic_play_circle.svg',
          context.txt.watchlist_menu_whereToWatch,
          () {
            scaffoldMessengerKey.currentState?.showSnackBar(
              SnackBars.build(
                context,
                null,
                //TODO: localize
                "Not available yet",
              ),
            );
          },
        ),
        MenuItem(
          'assets/icons/ic_collection_semibold.svg',
          context.txt.watchlist_menu_addToWatched,
          () {
            //TODO: implement
          },
        ),
        MenuItem.danger(
          'assets/icons/ic_trash2.svg',
          context.txt.delete,
          () async {
            await ref
                .read(commentsControllerProvider)
                .setBookmarked(widget.mediaId, false);
            await ref
                .read(profileBookmarksStateHolderProvider.notifier)
                .remove(widget.mediaId);
            await ref.read(router)!.pop();
          },
        ),
      ]),
    );
  }
}
