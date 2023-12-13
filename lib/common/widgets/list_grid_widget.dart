import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:poster_stock/common/constants/durations.dart';
import 'package:poster_stock/common/state_holders/router_state_holder.dart';
import 'package:poster_stock/common/widgets/shimmer_widget.dart';
import 'package:poster_stock/features/home/models/list_base_model.dart';
import 'package:poster_stock/navigation/app_router.gr.dart';
import 'package:poster_stock/themes/build_context_extension.dart';

class ListGridWidget extends ConsumerWidget {
  final ListBaseModel? post;
  const ListGridWidget({
    required this.post,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () {
        if (post?.id == null) return;
        ref.watch(router)!.push(ListRoute(id: post!.id));
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
              placeholderFadeInDuration: Durations.cachedDuration,
              fadeInDuration: Durations.cachedDuration,
              fadeOutDuration: Durations.cachedDuration,
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
          maxLines: 1,
        ),
      ],
    );
  }
}
