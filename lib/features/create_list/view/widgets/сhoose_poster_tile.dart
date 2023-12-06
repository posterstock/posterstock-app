import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:poster_stock/features/create_list/state_holders/create_list_chosen_poster_state_holder.dart';
import 'package:poster_stock/features/home/view/widgets/shimmer_loader.dart';
import 'package:poster_stock/themes/build_context_extension.dart';

class ChoosePosterTile extends ConsumerWidget {
  const ChoosePosterTile({
    Key? key,
    required this.index,
    required this.imagePath,
    required this.name,
    required this.year,
    required this.id,
  }) : super(key: key);
  final int index;
  final String? imagePath;
  final String? name;
  final String? year;
  final int? id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final shimmer = ShimmerLoader(
      child: Container(
        color: Colors.white,
      ),
    );
    bool chosen = false;
    for (var i in ref
        .watch(createListChosenPosterStateHolderProvider)) {
      if (i.$1 == id) chosen = true;
    }
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            if (id != null && imagePath != null) {
              ref
                  .read(createListChosenPosterStateHolderProvider.notifier)
                  .switchElement((id!, imagePath!));
            }
          },
          child: Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Container(
                  color: context.colors.backgroundsSecondary,
                  height: 160,
                  width: double.infinity,
                  child: CachedNetworkImage(
                    imageUrl: imagePath ?? '',
                    fit: BoxFit.cover,
                    errorWidget: (context, obj, trace) {
                      return shimmer;
                    },
                    placeholder: (context, value) {
                      return shimmer;
                    },
                    key: Key(imagePath ?? ''),
                  ),
                ),
              ),
              Positioned(
                top: 4,
                right: 4,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4.0),
                  child: Transform.scale(
                    scale: 1.2,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: 22,
                      height: 22,
                      color: chosen
                          ? context.colors.backgroundsPrimary
                          : context.colors.textsBackground!.withOpacity(0.4),
                      child: chosen
                          ? SvgPicture.asset('assets/icons/ic_check.svg')
                          : null,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Text(
          name ?? '',
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: context.textStyles.caption2!.copyWith(
            color: context.colors.textsPrimary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          year ?? '',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: context.textStyles.caption1!.copyWith(
            color: context.colors.textsDisabled,
          ),
        ),
      ],
    );
  }
}
