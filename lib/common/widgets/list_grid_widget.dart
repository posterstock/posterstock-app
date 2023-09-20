import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:poster_stock/common/constants/durations.dart';
import 'package:poster_stock/common/state_holders/router_state_holder.dart';
import 'package:poster_stock/features/home/models/list_base_model.dart';
import 'package:poster_stock/features/home/models/multiple_post_model.dart';
import 'package:poster_stock/features/home/view/widgets/shimmer_loader.dart';
import 'package:poster_stock/navigation/app_router.gr.dart';
import 'package:poster_stock/themes/build_context_extension.dart';

class ListGridWidget extends ConsumerWidget {
  const ListGridWidget({
    Key? key,
    required this.post,
  }) : super(key: key);
  final ListBaseModel? post;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final shimmer = ShimmerLoader(
      child: Container(
        color: context.colors.backgroundsSecondary,
      ),
    );
    return GestureDetector(
      onTap: () {
        if (post?.id != null) {
          ref.watch(router)!.push(
          ListRoute(id: post!.id),
        );
        }
      },
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: Container(
              height: ((MediaQuery.of(context).size.width - 16.0 * 3) / 2) /
                  540 *
                  300,
              width: double.infinity,
              color: context.colors.backgroundsSecondary,
              child: CachedNetworkImage(
                imageUrl: post?.image ?? '',
                fit: BoxFit.cover,
                placeholderFadeInDuration:
                Durations.cachedDuration,
                fadeInDuration: Durations.cachedDuration,
                fadeOutDuration: Durations.cachedDuration,
                placeholder: (context, child) {
                  return shimmer;
                },
                errorWidget: (context, obj, trace) {
                  return shimmer;
                },
              ), /*Row(
                children: List.generate(
                  post.posters.length,
                  (index) => Expanded(
                    child: Image.network(
                      post.posters[index].image,
                      fit: BoxFit.cover,
                      height: 92,
                    ),
                  ),
                ),
              ),*/
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          Text(
            post?.title ?? '',
            style: context.textStyles.caption2!.copyWith(
              color: context.colors.textsPrimary,
            ),
            maxLines: 1,
          ),
        ],
      ),
    );
  }
}
