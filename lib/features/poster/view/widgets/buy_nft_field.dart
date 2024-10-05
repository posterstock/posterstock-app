import 'package:flutter/material.dart';
import 'package:flutter_easylogger/flutter_logger.dart';
import 'package:gap/gap.dart';
import 'package:poster_stock/common/widgets/app_text_button.dart';
import 'package:poster_stock/features/home/models/post_movie_model.dart';
import 'package:poster_stock/themes/build_context_extension.dart';

class BuyNftField extends StatelessWidget {
  final PostMovieModel post;
  const BuyNftField({
    super.key,
    required this.post,
  });

  @override
  Widget build(BuildContext context) {
    Logger.i('post ${post.nft.toJson()}');
    return Column(
      children: [
        const CustomDivider(),
        const Gap(5),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      post.nft.price.toStringAsFixed(3),
                      style: context.textStyles.title2,
                    ),
                    const Gap(5),
                    Text(
                      post.nft.blocChain,
                      style: context.textStyles.subheadlineBold,
                    ),
                    const Gap(5),
                    Text(
                      '\$${post.nft.priceReal.toStringAsFixed(2)}',
                      style: context.textStyles.subheadline!
                          .copyWith(color: context.colors.textsDisabled),
                    ),
                  ],
                ),
                Text(
                  '+  ${post.nft.fee} ${post.nft.blocChain} network fee',
                  style: context.textStyles.subheadline!
                      .copyWith(color: context.colors.textsSecondary),
                ),
              ],
            ),
            AppTextButton(
              onTap: () {},
              text: context.txt.buy,
            ),
          ],
        ),
        // const CustomDivider(),
      ],
    );
  }
}

class CustomDivider extends StatelessWidget {
  const CustomDivider({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Gap(15),
        Divider(
          height: 0.5,
          thickness: 0.5,
          color: context.colors.fieldsDefault,
        ),
        const Gap(15),
      ],
    );
  }
}
