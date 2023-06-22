import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:poster_stock/features/home/models/post_movie_model.dart';
import 'package:poster_stock/navigation/app_router.gr.dart';
import 'package:poster_stock/themes/build_context_extension.dart';
/*
class ChoosePosterTile extends StatelessWidget {
  const ChoosePosterTile({Key? key,
    this.post,
    this.customOnItemTap, required this.index,})
      : super(key: key);
  final int index;
  final PostMovieModel? post;
  final void Function(PostMovieModel, int)? customOnItemTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            if (post != null && customOnItemTap == null) {
              AutoRouter.of(context).push(
                PosterRoute(
                  post: PostMovieModel(
                    year: post!.year,
                    imagePath: post!.imagePath,
                    name: post!.name,
                    author: post!.author,
                    time: post!.time,
                    description: post!.description,
                  ),
                ),
              );
            } else if (post != null) {
              customOnItemTap!(post!, index);
            }
          },
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: Container(
              color: context.colors.backgroundsSecondary,
              height: 160,
              child: Image.network(
                imagePath,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          name,
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: context.textStyles.caption2!.copyWith(
            color: context.colors.textsPrimary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          year,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: context.textStyles.caption1!.copyWith(
            color: context.colors.textsDisabled,
          ),
        ),
      ],
    );
  }
}*/
