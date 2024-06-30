import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:poster_stock/common/constants/durations.dart';
import 'package:poster_stock/common/widgets/shimmer_widget.dart';
import 'package:poster_stock/features/create_list/view/create_list_dialog.dart';
import 'package:poster_stock/features/home/models/list_base_model.dart';
import 'package:poster_stock/themes/build_context_extension.dart';

class ListGridWidget extends ConsumerWidget {
  final ListBaseModel? post;

  // final int index;
  final void Function(ListBaseModel?) callback;

  const ListGridWidget(
    this.callback, {
    required this.post,
    // this.index = -1,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () {
        if (post?.id == null) return;
        callback(post);
        // ref.watch(router)!.push(
        //       ListRoute(
        //         id: post!.id,
        //         // type: index,
        //       ),
        //     );
      },
      child: GroupListItemWidget(post),
    );
  }
}

class GroupListItemWidget extends StatelessWidget {
  final ListBaseModel? post;

  const GroupListItemWidget(this.post, {super.key});

  @override
  Widget build(BuildContext context) {
    final height =
        ((MediaQuery.of(context).size.width - 16.0 * 3) / 2) / 540 * 300;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: Container(
            height: height,
            width: double.infinity,
            color: context.colors.backgroundsSecondary,
            child: CachedNetworkImage(
              imageUrl: post?.image ?? '',
              fit: BoxFit.cover,
              placeholderFadeInDuration: CustomDurations.cachedDuration,
              fadeInDuration: CustomDurations.cachedDuration,
              fadeOutDuration: CustomDurations.cachedDuration,
              placeholder: (_, c) => const ShimmerWidget(),
              errorWidget: (_, o, s) => const ShimmerWidget(),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          post?.title ?? '',
          overflow: TextOverflow.ellipsis,
          style: context.textStyles.caption2!.copyWith(
            color: context.colors.textsPrimary,
          ),
          textAlign: TextAlign.center,
          maxLines: 1,
        ),
      ],
    );
  }
}

class CreateListGridWidget extends StatelessWidget {
  const CreateListGridWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final height =
        ((MediaQuery.of(context).size.width - 16.0 * 3) / 2) / 540 * 300;
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          context: context,
          backgroundColor: Colors.transparent,
          useRootNavigator: true,
          isScrollControlled: true,
          enableDrag: false,
          isDismissible: false,
          useSafeArea: false,
          builder: (context) => const CreateListDialog(),
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            height: height,
            width: double.infinity,
            decoration: BoxDecoration(
                border: Border.all(color: context.colors.fieldsHover!),
                borderRadius: BorderRadius.circular(8.0)),
            child: Center(
              child: SvgPicture.asset(
                'assets/icons/ic_collections_add.svg',
                width: 32.0,
                colorFilter: ColorFilter.mode(
                  context.colors.iconsDefault!,
                  BlendMode.srcIn,
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            context.txt.listCreate_create,
            overflow: TextOverflow.ellipsis,
            style: context.textStyles.caption2!.copyWith(
              color: context.colors.textsPrimary,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
          ),
        ],
      ),
    );
  }
}
