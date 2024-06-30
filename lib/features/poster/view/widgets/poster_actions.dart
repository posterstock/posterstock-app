import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:poster_stock/features/poster/controller/post_controller.dart';
import 'package:poster_stock/features/poster/state_holder/poster_state_holder.dart';
import 'package:poster_stock/features/poster/view/widgets/add_to_list_dialog.dart';
import 'package:poster_stock/features/poster_dialog/controller/create_poster_controller.dart';
import 'package:poster_stock/features/poster_dialog/model/media_model.dart';
import 'package:poster_stock/features/poster_dialog/view/poster_dialog.dart';
import 'package:poster_stock/features/profile/controllers/profile_controller.dart';
import 'package:poster_stock/features/profile/state_holders/profile_info_state_holder.dart';
import 'package:poster_stock/themes/build_context_extension.dart';

class PosterActions extends ConsumerWidget {
  const PosterActions({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final post = ref.watch(posterStateHolderProvider);
    // final profile = ref.watch(myProfileInfoStateHolderProvider)!;
    if (post == null) {
      return const SizedBox.shrink();
    }
    if (post.hasInCollection == true) {
      return GestureDetector(
        onTap: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (_) => AddToListDialog(),
          );
        },
        child: SizedBox(
          width: 24,
          height: 24,
          child: SvgPicture.asset(
            'assets/icons/ic_collections_add.svg',
            colorFilter: ColorFilter.mode(
              context.colors.iconsDefault!,
              BlendMode.srcIn,
            ),
          ),
        ),
      );
    } else {
      return Row(
        children: [
          GestureDetector(
            onTap: () async {
              await ref.read(postControllerProvider).setBookmarked(
                    post.id,
                    !(post.hasBookmarked ?? true),
                  );
              final myself = ref.watch(profileInfoStateHolderProvider)?.mySelf;
              if (myself != false) {
                // ignore: use_build_context_synchronously
                ref
                    .read(profileControllerApiProvider)
                    // ignore: use_build_context_synchronously
                    .getUserInfo(null, context);
              }
            },
            child: SizedBox(
              width: 24,
              height: 24,
              child: Image.asset(
                post.hasBookmarked == true
                    ? 'assets/images/ic_bookmarks_filled.png'
                    : 'assets/images/ic_bookmarks.png',
                color: context.colors.iconsDefault!,
                colorBlendMode: BlendMode.srcIn,
              ),
            ),
          ),
          const SizedBox(width: 20),
          GestureDetector(
            onTap: () {
              ref.read(createPosterControllerProvider).chooseMovie(
                    MediaModel(
                      id: post.mediaId!,
                      title: post.name,
                      type: post.mediaType == 'movie'
                          ? MediaType.movie
                          : MediaType.tv,
                      startYear: int.parse(post.year.split(" - ")[0]),
                      endYear: post.year.split(" - ").length == 1 ||
                              post.year.split(" - ")[1].isEmpty
                          ? null
                          : int.parse(
                              post.year.split(" - ")[1],
                            ),
                    ),
                  );
              if (post.hasInCollection == false) {
                showModalBottomSheet(
                  context: context,
                  backgroundColor: Colors.transparent,
                  isScrollControlled: true,
                  useSafeArea: false,
                  builder: (context) => const PosterDialog(),
                );
              }
            },
            child: SizedBox(
              width: 24,
              height: 24,
              child: Image.asset(
                post.hasInCollection == true
                    ? 'assets/images/ic_collection_filled.png'
                    : 'assets/images/ic_collection.png',
                color: context.colors.iconsDefault!,
                colorBlendMode: BlendMode.srcIn,
              ),
            ),
          ),
        ],
      );
    }
  }

  Widget myPoster(BuildContext context, WidgetRef ref) {
    final post = ref.watch(posterStateHolderProvider);
    return post?.hasInCollection == true
        ? const SizedBox.shrink()
        : SizedBox(
            width: 24,
            height: 24,
            child: SvgPicture.asset('assets/icons/ic_collections_add.svg'),
          );
  }

  Widget userPoster(BuildContext context, WidgetRef ref) {
    final post = ref.watch(posterStateHolderProvider);
    return SizedBox(
      width: 24,
      height: 24,
      child: Image.asset(
        post?.hasInCollection == true
            ? 'assets/images/ic_collection_filled.png'
            : 'assets/images/ic_collection.png',
        color: context.colors.iconsDefault!,
        colorBlendMode: BlendMode.srcIn,
      ),
    );
  }
}
