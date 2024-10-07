import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:poster_stock/features/home/models/post_movie_model.dart';
import 'package:poster_stock/themes/build_context_extension.dart';

/// выводит инофрмацию о TON если постер NFT
class TonInfo extends StatelessWidget {
  final PostMovieModel post;

  const TonInfo({
    Key? key,
    required this.post,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: 94,
          height: 28,
          decoration: BoxDecoration(
            color: context.colors.backgroundsSecondary,
            borderRadius: BorderRadius.circular(16),
          ),
          alignment: Alignment.centerRight,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Gap(35),
              Text(
                "${post.nft.number}",
                style: TextStyle(
                  color: context.colors.buttonsSecondary,
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                ),
              ),
              Text(
                " / ${post.nft.allCount}",
                style: TextStyle(
                  color: context.colors.textsSecondary,
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
        Positioned(
          top: 0,
          left: -1,
          child: SvgPicture.asset(
            'assets/icons/ton.svg',
            width: 28,
            height: 28,
          ),
        ),
      ],
    );
  }
}
