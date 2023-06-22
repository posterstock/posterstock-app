import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:poster_stock/features/home/models/multiple_post_model.dart';
import 'package:poster_stock/navigation/app_router.gr.dart';
import 'package:poster_stock/themes/build_context_extension.dart';

class ListGridWidget extends StatelessWidget {
  const ListGridWidget({
    Key? key,
    required this.post,
  }) : super(key: key);
  final MultiplePostModel post;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        AutoRouter.of(context).push(
          ListRoute(post: post),
        );
      },
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: Container(
              height: 92,
              color: context.colors.backgroundsSecondary,
              child: Row(
                children: List.generate(
                  post.posters.length,
                  (index) => Expanded(
                    child: Image.network(
                      post.posters[index],
                      fit: BoxFit.cover,
                      height: 92,
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          Text(
            post.name,
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
