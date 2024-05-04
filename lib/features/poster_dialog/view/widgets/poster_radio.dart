import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:poster_stock/features/home/view/widgets/shimmer_loader.dart';
import 'package:poster_stock/features/poster_dialog/controller/create_poster_controller.dart';
import 'package:poster_stock/features/poster_dialog/model/media_model.dart';
import 'package:poster_stock/features/poster_dialog/state_holder/create_poster_chosen_poster_state_holder.dart';
import 'package:poster_stock/themes/build_context_extension.dart';

class PosterRadio extends ConsumerWidget {
  const PosterRadio({
    super.key,
    required this.chosenMovie,
    required this.images,
    required this.index,
  });

  final MediaModel? chosenMovie;
  final List<String> images;
  final int index;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chosenPoster = ref.watch(createPosterChosenPosterStateHolderProvider);
    final shimmer = ShimmerLoader(
      child: Container(
        color: context.colors.backgroundsSecondary,
      ),
    );
    return Stack(
      children: [
        GestureDetector(
          onTap: () {
            if (chosenMovie == null || images.isEmpty) {
              return;
            }
            if (images.length > index) {
              ref
                  .read(createPosterControllerProvider)
                  .choosePoster((index, images[index]));
            }
          },
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: Container(
              width: 106,
              height: 160,
              color: context.colors.backgroundsSecondary,
              child: chosenMovie == null
                  ? null
                  : Image.network(
                      images[index],
                      fit: BoxFit.cover,
                      cacheWidth: 200,
                      errorBuilder: (context, obj, trace) {
                        return shimmer;
                      },
                      loadingBuilder: (context, child, event) {
                        if (event?.cumulativeBytesLoaded !=
                            event?.expectedTotalBytes) return shimmer;
                        return child;
                      },
                    ),
            ),
          ),
        ),
        Positioned(
          right: 4,
          top: 4,
          child: GestureDetector(
            onTap: () {
              if (images.length > index) {
                ref
                    .read(createPosterControllerProvider)
                    .choosePoster((index, images[index]));
              }
            },
            child: AnimatedContainer(
                width: 22,
                height: 22,
                duration: const Duration(milliseconds: 150),
                decoration: BoxDecoration(
                  color: context.colors.backgroundsPrimary!.withOpacity(
                      (chosenPoster?.$1 != -1
                              ? chosenPoster?.$1 == index
                              : chosenPoster?.$2.split('/').last ==
                                  images[index].split('/').last)
                          ? 1
                          : 0.4),
                  shape: BoxShape.circle,
                ),
                child: (chosenPoster?.$1 != -1
                        ? chosenPoster?.$1 == index
                        : chosenPoster?.$2.split('/').last ==
                            images[index].split('/').last)
                    ? Center(
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 150),
                          width: 4,
                          height: 4,
                          decoration: BoxDecoration(
                            color: context.colors.iconsActive,
                            shape: BoxShape.circle,
                          ),
                        ),
                      )
                    : null),
          ),
        ),
      ],
    );
  }
}
