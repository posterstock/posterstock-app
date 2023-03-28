import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:poster_stock/features/home/models/multiple_post_model.dart';
import 'package:poster_stock/features/home/models/post_movie_model.dart';
import 'package:poster_stock/features/home/models/user_model.dart';
import 'package:poster_stock/features/home/view/widgets/shimmer_loader.dart';
import 'package:poster_stock/features/home/view/widgets/text_or_container.dart';
import 'package:poster_stock/themes/build_context_extension.dart';

import '../../../../common/widgets/app_text_button.dart';
import 'movie_card.dart';
import 'multiple_movie_card.dart';

class PostBase extends StatelessWidget {
  const PostBase({
    Key? key,
    this.post,
    this.multPost,
  })  : assert(post == null || multPost == null),
        super(key: key);

  final List<PostMovieModel>? post;
  final MultiplePostModel? multPost;

  @override
  Widget build(BuildContext context) {
    UserModel? user;
    if (post != null) {
      user = post![0].author;
    } else if (multPost != null) {
      user = multPost!.author;
    }
    const List<Color> avatar = [
      Color(0xfff09a90),
      Color(0xfff3d376),
      Color(0xff92bdf4),
    ];
    return Material(
      color: context.colors.backgroundsPrimary,
      child: InkWell(
        onTap: () {},
        child: ShimmerLoader(
          loaded: post != null || multPost != null,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if ((post != null || multPost != null) && !user!.followed!)
                      Padding(
                        padding: const EdgeInsets.only(left: 68.0),
                        child: Text(
                          'Suggestion post',
                          style: context.textStyles.caption1!.copyWith(
                            color: context.colors.textsDisabled,
                          ),
                        ),
                      ),
                    if ((post != null || multPost != null) && !user!.followed!)
                      const SizedBox(height: 12),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          width: 16,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 4.0),
                          child: CircleAvatar(
                            radius: 20,
                            backgroundImage: user?.imagePath != null
                                ? NetworkImage(user!.imagePath!)
                                : null,
                            backgroundColor: avatar[Random().nextInt(3)],
                            child: user?.imagePath == null &&
                                    (post != null || multPost != null)
                                ? Text(
                                    getAvatarName(user!.name)
                                        .toUpperCase(),
                                    style: context.textStyles.subheadlineBold!
                                        .copyWith(
                                      color: context.colors.textsBackground,
                                    ),
                                  )
                                : const SizedBox(),
                          ),
                        ),
                        const SizedBox(
                          width: 12,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 4.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (post == null && multPost == null)
                                    const SizedBox(
                                      height: 3,
                                    ),
                                  TextOrContainer(
                                    text: user?.name,
                                    style: context.textStyles.calloutBold,
                                    emptyWidth: 146,
                                    emptyHeight: 17,
                                  ),
                                  SizedBox(
                                    height: post != null || multPost != null ? 4 : 8,
                                  ),
                                  TextOrContainer(
                                    text: user?.username == null
                                        ? null
                                        : '@${user!.username}',
                                    style:
                                        context.textStyles.caption1!.copyWith(
                                      color: context.colors.textsSecondary,
                                    ),
                                    emptyWidth: 120,
                                    emptyHeight: 12,
                                  ),
                                ],
                              ),
                              SizedBox(
                                width: (user?.followed ?? true)
                                    ? 12
                                    : 24,
                              ),
                              if (user?.followed ?? true)
                                Padding(
                                  padding: const EdgeInsets.only(top: 3.0),
                                  child: Text(
                                    (post?[0].time ?? multPost?.time) ?? '',
                                    style:
                                        context.textStyles.footNote!.copyWith(
                                      color: context.colors.textsDisabled,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                        const Spacer(),
                        if (!(user?.followed ?? true) && (post != null || multPost != null))
                          const AppTextButton(
                            text: 'Follow',
                          ),
                        if (post != null || multPost != null)
                          GestureDetector(
                            onTap: () {},
                            child: Container(
                              color: Colors.transparent,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16.0),
                              child: SvgPicture.asset(
                                'assets/icons/ic_dots.svg',
                                width: 24,
                                colorFilter: ColorFilter.mode(
                                  context.colors.iconsLayer!,
                                  BlendMode.srcIn,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
              if (post == null && multPost == null || post != null)
                MovieCard(
                  movie: post,
                ),
              if (multPost != null)
                MultipleMovieCard(
                  post: multPost!,
                ),
            ],
          ),
        ),
      ),
    );
  }

  String getAvatarName(String name) {
    String result = name[0];
    for (int i = 0; i < name.length; i++) {
      if (name[i] == ' ' && i != name.length - 1) {
        result += name[i + 1];
        break;
      }
    }
    return result;
  }
}
