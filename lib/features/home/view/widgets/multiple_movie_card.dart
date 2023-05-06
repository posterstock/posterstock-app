import 'package:flutter/material.dart';
import 'package:poster_stock/features/home/models/multiple_post_model.dart';
import 'package:poster_stock/features/home/view/widgets/reaction_button.dart';
import 'package:poster_stock/themes/build_context_extension.dart';

class MultipleMovieCard extends StatelessWidget {
  const MultipleMovieCard({
    Key? key,
    required this.post,
  }) : super(key: key);

  final MultiplePostModel post;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12.0),
            child: Row(
              children: List.generate(
                post.posters.length,
                (index) => Expanded(
                  child: Container(
                    height: 163,
                    color: context.colors.backgroundsSecondary,
                    child: Image.network(
                      post.posters[index],
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          const SizedBox(),
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 2.0),
            child: Text(
              post.name,
              style: context.textStyles.calloutBold,
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          Text(
            (post.description ?? '').length > 140
                ? post.description!.substring(0, 140)
                : (post.description ?? ''),
            style: context.textStyles.callout!.copyWith(
              color: context.colors.textsPrimary,
            ),
          ),
          const SizedBox(
            height: 12,
          ),
          Row(
            children: [
              const Spacer(),
              ReactionButton(
                iconPath: 'assets/icons/ic_heart.svg',
                iconColor: context.colors.iconsDisabled!,
                amount: post.likes.length,
              ),
              const SizedBox(
                width: 12,
              ),
              ReactionButton(
                iconPath: 'assets/icons/ic_comment2.svg',
                iconColor: context.colors.iconsDisabled!,
                amount: post.comments.length,
              ),
            ],
          ),
          const SizedBox(
            height: 16,
          ),
        ],
      ),
    );
  }
}
