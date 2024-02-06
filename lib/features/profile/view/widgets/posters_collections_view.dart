import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:poster_stock/features/home/models/post_movie_model.dart';
import 'package:poster_stock/features/poster/view/widgets/poster_tile.dart';
import 'package:poster_stock/features/profile/view/widgets/simple_empty_collection.dart';
import 'package:poster_stock/themes/build_context_extension.dart';

class PostersCollectionView extends ConsumerWidget {
  final List<PostMovieModel?> movies;
  final String? name;
  final void Function(PostMovieModel, int)? callback;

  const PostersCollectionView(
    this.movies, {
    this.name,
    this.callback,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (movies.isEmpty) {
      return Column(
        children: [
          SizedBox(height: (MediaQuery.of(context).size.height - 480 - 56) / 2),
          SizedBox(
            width: name == null ? 170 : 250,
            child: SimpleEmptyCollectionWidget(
              name != null
                  ? "$name ${context.txt.profile_noWatched} "
                  : context.txt.profile_lists_add_hint,
            ),
          ),
        ],
      );
    }
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(
        parent: BouncingScrollPhysics(),
      ),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 12.5,
        mainAxisSpacing: 15,
        mainAxisExtent:
            ((MediaQuery.of(context).size.width - 15 * 2 - 16 * 2) / 3) /
                    2 *
                    3 +
                41,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      itemCount: movies.length,
      itemBuilder: (_, index) => GestureDetector(
        onTap: () => callback?.call(movies[index]!, index),
        child: PostGridItemWidget(movies[index]),
      ),
    );
  }
}
