import 'dart:math';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:poster_stock/common/widgets/custom_scaffold.dart';
import 'package:poster_stock/features/create_list/view/pick_cover_dialog.dart';
import 'package:poster_stock/features/edit_profile/controller/profile_controller.dart';
import 'package:poster_stock/features/edit_profile/state_holder/avatar_state_holder.dart';
import 'package:poster_stock/features/edit_profile/view/controller/edit_profile_controller.dart';
import 'package:poster_stock/features/edit_profile/view/state_holders/edit_profile_name_error.dart';
import 'package:poster_stock/features/edit_profile/view/state_holders/edit_profile_username_state_holder.dart';
import 'package:poster_stock/features/profile/state_holders/profile_info_state_holder.dart';
import 'package:poster_stock/themes/build_context_extension.dart';

class EditProfilePage extends ConsumerWidget {
  EditProfilePage({Key? key}) : super(key: key);

  static const List<Color> avatar = [
    Color(0xfff09a90),
    Color(0xfff3d376),
    Color(0xff92bdf4),
  ];

  final avatarColor = avatar[Random().nextInt(3)];
  final controller = ScrollController();
  TextEditingController? nameController;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final photo = ref.watch(avatarStateHolderProvider);
    final usernameError = ref.watch(editProfileUsernameStateHolder);
    final nameError = ref.watch(editProfileNameStateHolder);
    final initialName = ref.watch(profileInfoStateHolderProvider)?.name;
    nameController ??= TextEditingController(text: initialName ?? '');
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: CustomScaffold(
        resize: true,
        backgroundColor: context.colors.backgroundsSecondary,
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: SingleChildScrollView(
            controller: controller,
            physics: const AlwaysScrollableScrollPhysics(
              parent: BouncingScrollPhysics(),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                AppBar(
                  backgroundColor: context.colors.backgroundsSecondary,
                  elevation: 0,
                  leadingWidth: 130,
                  leading: Align(
                    alignment: Alignment.centerLeft,
                    child: GestureDetector(
                      onTap: () {
                        AutoRouter.of(context).pop();
                      },
                      child: Container(
                        color: Colors.transparent,
                        padding: const EdgeInsets.only(left: 7.0, right: 40.0),
                        child: SvgPicture.asset(
                          'assets/icons/back_icon.svg',
                          width: 18,
                          colorFilter: ColorFilter.mode(
                            context.colors.iconsDefault!,
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                    ),
                  ),
                  titleSpacing: 0,
                  centerTitle: true,
                  title: Text(
                    'Edit Profile',
                    style: context.textStyles.bodyBold,
                  ),
                  actions: [
                    CupertinoButton(
                      onPressed: () {
                        AutoRouter.of(context).pop();
                      },
                      child: const Text('Save'),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                GestureDetector(
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      backgroundColor: Colors.transparent,
                      isScrollControlled: true,
                      useSafeArea: true,
                      builder: (context) => GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Container(
                          height: double.infinity,
                          color: Colors.transparent,
                          child: const ProfilePhotoDialog(),
                        ),
                      ),
                    );
                  },
                  child: CircleAvatar(
                    radius: 50,
                    backgroundColor: avatarColor,
                    backgroundImage: photo == null
                        ? null
                        : Image.memory(
                            photo,
                            fit: BoxFit.cover,
                            cacheWidth: 150,
                          ).image,
                    child: Center(
                      child: SvgPicture.asset(
                        'assets/icons/ic_camera.svg',
                        width: 24.0,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                CupertinoButton(
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      backgroundColor: Colors.transparent,
                      isScrollControlled: true,
                      useSafeArea: true,
                      builder: (context) => GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Container(
                          height: double.infinity,
                          color: Colors.transparent,
                          child: const ProfilePhotoDialog(),
                        ),
                      ),
                    );
                  },
                  child: const Text('Change profile photo'),
                ),
                const SizedBox(height: 24),
                Divider(
                  height: 1,
                  thickness: 1,
                  color: context.colors.fieldsDefault,
                ),
                SizedBox(
                  height: 47,
                  child: Row(
                    children: [
                      Container(
                        color: context.colors.backgroundsPrimary,
                        width: 124,
                        height: 47,
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 16.0),
                            child: Text(
                              'Name',
                              style: context.textStyles.calloutBold,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: TextField(
                          controller: nameController,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: context.colors.backgroundsPrimary,
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 20.0,
                              vertical: 12.0,
                            ),
                          ),
                          style: context.textStyles.callout!.copyWith(
                            color: nameError == null
                                ? context.colors.textsPrimary
                                : context.colors.textsError,
                          ),
                          onChanged: (value) {
                            if (value.length > 32) {
                              ref
                                  .read(editProfileControllerProvider)
                                  .setTooLongErrorName();
                              return;
                            }
                            ref.read(editProfileControllerProvider).removeNameError();
                          },
                          onTap: () {
                            controller.animateTo(
                              0,
                              duration: Duration(milliseconds: 300),
                              curve: Curves.linear,
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                Divider(
                  height: 1,
                  thickness: 1,
                  color: context.colors.fieldsDefault,
                ),
                SizedBox(
                  height: 47,
                  child: Row(
                    children: [
                      Container(
                        color: context.colors.backgroundsPrimary,
                        width: 124,
                        height: 47,
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 16.0),
                            child: Text(
                              'Username',
                              style: context.textStyles.calloutBold,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: UsernameFieldProfile(controller: controller),
                      ),
                    ],
                  ),
                ),
                Divider(
                  height: 1,
                  thickness: 1,
                  color: context.colors.fieldsDefault,
                ),
                const SizedBox(
                  height: 4,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 16.0),
                    child: Text(
                      usernameError ?? '',
                      style: context.textStyles.caption1!.copyWith(
                        color: context.colors.textsError,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 26),
                Divider(
                  height: 1,
                  thickness: 1,
                  color: context.colors.fieldsDefault,
                ),
                ProfileDescriptionField(controller: controller),
                Divider(
                  height: 1,
                  thickness: 1,
                  color: context.colors.fieldsDefault,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class UsernameFieldProfile extends ConsumerStatefulWidget {
  const UsernameFieldProfile({
    super.key,
    required this.controller,
  });

  final ScrollController controller;

  @override
  ConsumerState<UsernameFieldProfile> createState() =>
      _UsernameFieldProfileState();
}

class _UsernameFieldProfileState extends ConsumerState<UsernameFieldProfile> {
  TextEditingController? controller;
  final FocusNode focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    focusNode.addListener(() {
      setState(() {});
    });
    final usernameError = ref.watch(editProfileUsernameStateHolder);
    final initialUsername = ref.watch(profileInfoStateHolderProvider)?.username;
    controller ??= TextEditingController(text: initialUsername ?? '');
    return TextField(
      controller: controller,
      focusNode: focusNode,
      decoration: InputDecoration(
        filled: true,
        fillColor: context.colors.backgroundsPrimary,
        border: InputBorder.none,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20.0,
          vertical: 12.0,
        ),
        prefix: Text(
          '@',
          style: context.textStyles.callout!.copyWith(
            color: !(focusNode.hasFocus || controller!.text.isNotEmpty)
                ? Colors.transparent
                : (usernameError == null
                    ? context.colors.textsDisabled
                    : context.colors.textsError),
          ),
        ),
      ),
      style: context.textStyles.callout!.copyWith(
        color: usernameError == null
            ? context.colors.textsPrimary
            : context.colors.textsError,
      ),
      onTap: () {
        widget.controller.animateTo(
          120,
          duration: Duration(milliseconds: 300),
          curve: Curves.linear,
        );
      },
      onChanged: (value) {
        if (value.isEmpty) {
          ref.read(editProfileControllerProvider).removeUsernameError();
          return;
        }
        if (value.length < 5) {
          ref.read(editProfileControllerProvider).setTooShortErrorUsername();
          return;
        }
        if (value.length > 32) {
          ref.read(editProfileControllerProvider).setTooLongErrorUsername();
          return;
        }
        final validCharacters = RegExp(r'[a-zA-Z0-9_.]+$');
        for (int i = 0; i < value.length; i++) {
          if (!validCharacters.hasMatch(value[i])) {
            ref
                .read(editProfileControllerProvider)
                .setWrongSymbolsErrorUsername();
            return;
          }
        }
        ref.read(editProfileControllerProvider).removeUsernameError();
      },
    );
  }
}

class ProfileDescriptionField extends StatefulWidget {
  const ProfileDescriptionField({
    super.key,
    required this.controller,
  });

  final ScrollController controller;

  @override
  State<ProfileDescriptionField> createState() =>
      _ProfileDescriptionFieldState();
}

class _ProfileDescriptionFieldState extends State<ProfileDescriptionField> {
  final textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.fromLTRB(16, 13, 16, 13),
          color: context.colors.backgroundsPrimary,
          child: Row(
            children: [
              Text(
                'Description',
                style: context.textStyles.calloutBold,
              ),
              const Spacer(),
              Text(
                '${textController.text.length}/140',
                style: context.textStyles.footNote!.copyWith(
                  color: textController.text.length <= 140
                      ? context.colors.textsDisabled
                      : context.colors.textsError,
                ),
              ),
            ],
          ),
        ),
        TextField(
          controller: textController,
          maxLines: null,
          minLines: 5,
          decoration: InputDecoration(
            hintText: 'Write a short description about yourself',
            hintStyle: context.textStyles.callout!.copyWith(
              color: context.colors.textsDisabled,
            ),
            filled: true,
            fillColor: context.colors.backgroundsPrimary,
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 12.0,
            ),
          ),
          style: context.textStyles.callout!.copyWith(
            color: context.colors.textsPrimary,
          ),
          onChanged: (value) {
            setState(() {});
          },
          onTap: () {
            widget.controller.animateTo(
              150,
              duration: Duration(milliseconds: 300),
              curve: Curves.linear,
            );
          },
        ),
      ],
    );
  }
}

class ProfilePhotoDialog extends ConsumerWidget {
  const ProfilePhotoDialog({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: SizedBox(
        height: 300,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(16.0),
                child: SizedBox(
                  height: 192,
                  child: Material(
                    color: context.colors.backgroundsPrimary,
                    child: Column(
                      children: [
                        SizedBox(
                          height: 36,
                          child: Center(
                            child: Text(
                              'Profile photo',
                              style: context.textStyles.footNote!.copyWith(
                                color: context.colors.textsSecondary,
                              ),
                            ),
                          ),
                        ),
                        Divider(
                          height: 0.5,
                          thickness: 0.5,
                          color: context.colors.fieldsDefault,
                        ),
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              Navigator.pop(context);
                              showModalBottomSheet(
                                context: context,
                                backgroundColor: Colors.transparent,
                                isScrollControlled: true,
                                useSafeArea: true,
                                builder: (context) => PickCoverDialog(
                                  onItemTap: (BuildContext context,
                                      WidgetRef ref, Uint8List image) {
                                    ref
                                        .read(profileControllerProvider)
                                        .setPhoto(image);
                                    Navigator.pop(context);
                                  },
                                ),
                              );
                            },
                            child: Center(
                              child: Text(
                                'Choose from gallery',
                                style: context.textStyles.bodyRegular!.copyWith(
                                  color: context.colors.textsPrimary,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Divider(
                          height: 0.5,
                          thickness: 0.5,
                          color: context.colors.fieldsDefault,
                        ),
                        Expanded(
                          child: InkWell(
                            onTap: () async {
                              final xfile = await ImagePicker()
                                  .pickImage(source: ImageSource.camera);
                              final image = await xfile?.readAsBytes();
                              if (image != null) {
                                ref
                                    .read(profileControllerProvider)
                                    .setPhoto(image);
                              }
                            },
                            child: Center(
                              child: Text(
                                'Take photo',
                                style: context.textStyles.bodyRegular!.copyWith(
                                  color: context.colors.textsPrimary,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Divider(
                          height: 0.5,
                          thickness: 0.5,
                          color: context.colors.fieldsDefault,
                        ),
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              ref.read(profileControllerProvider).removePhoto();
                              Navigator.pop(context);
                            },
                            child: Center(
                              child: Text(
                                'Remove photo',
                                style: context.textStyles.bodyRegular!.copyWith(
                                  color: context.colors.textsError,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(16.0),
                child: SizedBox(
                  height: 52,
                  child: Material(
                    color: context.colors.backgroundsPrimary,
                    child: InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Center(
                        child: Text(
                          'Cancel',
                          style: context.textStyles.bodyRegular,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
