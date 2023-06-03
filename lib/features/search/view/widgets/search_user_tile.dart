import 'dart:math';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:poster_stock/features/profile/models/user_details_model.dart';
import 'package:poster_stock/navigation/app_router.gr.dart';
import 'package:poster_stock/themes/build_context_extension.dart';

class SearchUserTile extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        AutoRouter.of(context).push(
          ProfileRoute(user: user),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: SizedBox(
          height: 72,
          child: Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundImage: user.imagePath != null
                    ? NetworkImage(user.imagePath!)
                    : null,
                backgroundColor: avatar[Random().nextInt(3)],
                child: user.imagePath == null
                    ? Text(
                  getAvatarName(user.name).toUpperCase(),
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
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      user.name,
                      style: context.textStyles.subheadline,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '@${user.username}',
                      style: context.textStyles.caption1!.copyWith(
                        color: context.colors.textsSecondary,
                      ),
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
