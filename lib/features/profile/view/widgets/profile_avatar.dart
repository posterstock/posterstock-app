import 'package:flutter/material.dart';
import 'package:poster_stock/features/home/view/widgets/shimmer_loader.dart';
import 'package:poster_stock/features/profile/models/user_details_model.dart';
import 'package:poster_stock/themes/build_context_extension.dart';

class ProfileAvatar extends StatelessWidget {
  final UserDetailsModel profile;
  final shimmer = ShimmerLoader(
    loaded: false,
    child: Container(color: Colors.grey),
  );

  ProfileAvatar(this.profile, {super.key});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 40,
      backgroundColor: profile.color,
      backgroundImage: profile.imagePath != null
          ? Image.network(
              profile.imagePath!,
              fit: BoxFit.cover,
              errorBuilder: (c, o, t) => shimmer,
              loadingBuilder: (_, child, event) {
                return event?.cumulativeBytesLoaded != event?.expectedTotalBytes
                    ? shimmer
                    : child;
              },
            ).image
          : null,
      child: profile.imagePath == null
          ? Text(
              getAvatarName(profile.name).toUpperCase().isEmpty
                  ? getAvatarName(profile.username).toUpperCase()
                  : getAvatarName(profile.name).toUpperCase(),
              style: context.textStyles.title3!.copyWith(
                color: context.colors.textsBackground,
              ),
            )
          : const SizedBox(),
    );
  }

  String getAvatarName(String name) {
    if (name.isEmpty) return name;
    String result = name[0];
    for (int i = 0; i < name.length; i++) {
      if (name[i] == ' ' && i != name.length - 1) {
        result += name[i + 1];
        break;
      }
    }
    return result;
  }

  String get profileName {
    String name = profile.name;
    if (name.isEmpty) return name;
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
