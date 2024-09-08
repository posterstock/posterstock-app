import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:poster_stock/features/home/view/widgets/text_or_container.dart';
import 'package:poster_stock/features/profile/models/user_details_model.dart';
import 'package:poster_stock/features/user/user_page.dart';
import 'package:poster_stock/navigation/app_router.gr.dart';
import 'package:poster_stock/themes/build_context_extension.dart';

class SearchUserTile extends ConsumerWidget {
  const SearchUserTile({
    Key? key,
    required this.user,
  }) : super(key: key);
  final UserDetailsModel user;
  static const List<Color> avatar = [
    Color(0xfff09a90),
    Color(0xfff3d376),
    Color(0xff92bdf4),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return InkWell(
      onTap: () => context.pushRoute(
        UserRoute(args: UserArgs(user.id, user.username)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: SizedBox(
          height: 72,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 24,
                backgroundImage: user.imagePath != null
                    ? CachedNetworkImageProvider(user.imagePath!)
                    : null,
                backgroundColor: user.color,
                child: user.imagePath == null
                    ? Text(
                        getAvatarName(user.name, user.username).toUpperCase(),
                        style: context.textStyles.calloutBold!.copyWith(
                          color: context.colors.textsBackground,
                        ),
                      )
                    : const SizedBox(),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Spacer(
                      flex: 3,
                    ),
                    NameWithArtist(
                      name: user.name,
                      isArtist: user.isArtist,
                    ),
                    const Spacer(),
                    Text(
                      '@${user.username}',
                      style: context.textStyles.caption1!.copyWith(
                        color: context.colors.textsSecondary,
                      ),
                    ),
                    const Spacer(
                      flex: 4,
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      SvgPicture.asset(
                        'assets/icons/ic_collection.svg',
                        width: 16,
                        colorFilter: ColorFilter.mode(
                          context.colors.iconsDefault!,
                          BlendMode.srcIn,
                        ),
                      ),
                      const SizedBox(width: 5),
                      SizedBox(
                        width: 51,
                        child: Text(
                          user.posters.toString(),
                          style: context.textStyles.caption1!
                              .copyWith(color: context.colors.textsPrimary),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      SvgPicture.asset(
                        'assets/icons/ic_lists.svg',
                        width: 16,
                        colorFilter: ColorFilter.mode(
                          context.colors.iconsDefault!,
                          BlendMode.srcIn,
                        ),
                      ),
                      const SizedBox(width: 5),
                      SizedBox(
                        width: 51,
                        child: Text(
                          user.lists.toString(),
                          style: context.textStyles.caption1!
                              .copyWith(color: context.colors.textsPrimary),
                        ),
                      ),
                    ],
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  String getAvatarName(String name, String username) {
    if (name.isEmpty) return username[0];
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
