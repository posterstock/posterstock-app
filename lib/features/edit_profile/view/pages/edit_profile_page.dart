// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easylogger/flutter_logger.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:poster_stock/common/state_holders/router_state_holder.dart';
import 'package:poster_stock/common/widgets/app_snack_bar.dart';
import 'package:poster_stock/common/widgets/custom_scaffold.dart';
import 'package:poster_stock/features/create_list/controllers/pick_cover_controller.dart';
import 'package:poster_stock/features/edit_profile/controller/profile_controller.dart';
import 'package:poster_stock/features/edit_profile/state_holder/avatar_state_holder.dart';
import 'package:poster_stock/features/edit_profile/controller/edit_profile_controller.dart';
import 'package:poster_stock/features/edit_profile/state_holder/edit_profile_description_error_state_holder.dart';
import 'package:poster_stock/features/edit_profile/state_holder/edit_profile_description_state_holder.dart';
import 'package:poster_stock/features/edit_profile/state_holder/edit_profile_loading_state_holder.dart';
import 'package:poster_stock/features/edit_profile/state_holder/edit_profile_name_error.dart';
import 'package:poster_stock/features/edit_profile/state_holder/edit_profile_name_state_holder.dart';
import 'package:poster_stock/features/edit_profile/state_holder/edit_profile_username_error_state_holder.dart';
import 'package:poster_stock/features/edit_profile/state_holder/edit_profile_username_state_holder.dart';
import 'package:poster_stock/features/profile/controllers/profile_controller.dart';
import 'package:poster_stock/features/profile/state_holders/my_profile_info_state_holder.dart';
import 'package:poster_stock/main.dart';
import 'package:poster_stock/themes/build_context_extension.dart';

@RoutePage()
// ignore: must_be_immutable
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

  static Future waitWhile(bool Function() test,
      [Duration pollInterval = Duration.zero]) {
    var completer = Completer();
    check() {
      if (test()) {
        completer.complete();
      } else {
        Timer(pollInterval, check);
      }
    }

    check();
    return completer.future;
  }

  static void animateScrollTo(double value, ScrollController controller) async {
    await waitWhile(() => controller.hasClients);
    controller.animateTo(
      value,
      duration: const Duration(milliseconds: 200),
      curve: Curves.linear,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final photo = ref.watch(avatarStateHolderProvider);
    final usernameError = ref.watch(editProfileUsernameErrorStateHolder);
    final nameError = ref.watch(editProfileNameErrorStateHolder);
    final descriptionError = ref.watch(editProfileDescriptionErrorStateHolder);
    final initialName = ref.watch(myProfileInfoStateHolderProvider)?.name;
    final initialPhoto = ref.watch(myProfileInfoStateHolderProvider)?.imagePath;
    if (ref.read(editProfileNameStateHolder) == null) {
      Future(() {
        ref
            .read(editProfileNameStateHolder.notifier)
            .updateValue(initialName ?? '');
      });
    }
    nameController ??= TextEditingController(text: initialName ?? '');
    return WillPopScope(
      onWillPop: () async {
        ref.read(editProfileControllerProvider).clearAll();
        ref.read(editProfileDescriptionStateHolder.notifier).clearValue();
        ref.read(editProfileNameStateHolder.notifier).clearValue();
        return true;
      },
      child: GestureDetector(
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
                          ref.read(editProfileControllerProvider).clearAll();
                          ref
                              .read(editProfileDescriptionStateHolder.notifier)
                              .clearValue();
                          ref
                              .read(editProfileNameStateHolder.notifier)
                              .clearValue();
                          ref.watch(router)!.pop();
                        },
                        child: Container(
                          color: Colors.transparent,
                          padding:
                              const EdgeInsets.only(left: 7.0, right: 40.0),
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
                        onPressed: (usernameError != null ||
                                nameError != null ||
                                descriptionError)
                            ? null
                            : () async {
                                ref
                                    .read(editProfileControllerProvider)
                                    .setLoading(true);
                                await ref
                                    .read(editProfileControllerProvider)
                                    .save();
                                await ref
                                    .read(profileControllerApiProvider)
                                    .getUserInfo(null, context);
                                ref
                                    .read(editProfileControllerProvider)
                                    .setLoading(false);
                                ref.watch(router)!.pop();
                              },
                        child: ref.watch(editProfileLoadingStateHolder)
                            ? Center(
                                child: defaultTargetPlatform !=
                                        TargetPlatform.android
                                    ? CupertinoActivityIndicator(
                                        radius: 10.0,
                                        color: context.colors.buttonsPrimary!,
                                      )
                                    : SizedBox(
                                        width: 16,
                                        height: 16,
                                        child: CircularProgressIndicator(
                                          color: context.colors.buttonsPrimary!,
                                          strokeWidth: 2,
                                        ),
                                      ),
                              )
                            : const Text('Save'),
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
                        useSafeArea: false,
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
                          ? (initialPhoto == null
                              ? null
                              : Image.network(
                                  initialPhoto,
                                  fit: BoxFit.cover,
                                ).image)
                          : Image.memory(
                              photo,
                              fit: BoxFit.cover,
                              cacheWidth: 350,
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
                        useSafeArea: false,
                        builder: (context) => GestureDetector(
                          behavior: HitTestBehavior.opaque, // Добавьте это
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Container(
                            height: double.infinity,
                            color: Colors.transparent,
                            child: GestureDetector(
                              onTap: () {},
                              child: const ProfilePhotoDialog(),
                            ),
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
                              ref
                                  .read(editProfileNameStateHolder.notifier)
                                  .updateValue(value);
                              if (value.length > 32) {
                                ref
                                    .read(editProfileControllerProvider)
                                    .setTooLongErrorName();
                                return;
                              }
                              if (value.isEmpty) {
                                ref
                                    .read(editProfileControllerProvider)
                                    .setTooShortErrorName();
                                return;
                              }
                              ref
                                  .read(editProfileControllerProvider)
                                  .removeNameError();
                            },
                            onTap: () {
                              animateScrollTo(0, controller);
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
  String? initialUsername;

  @override
  Widget build(BuildContext context) {
    focusNode.addListener(() {
      setState(() {});
    });
    final screenHeight = (MediaQuery.of(context).size.height -
        MediaQuery.of(context).viewInsets.bottom);
    final usernameError = ref.watch(editProfileUsernameErrorStateHolder);
    if (initialUsername == null) {
      initialUsername ??= ref.watch(myProfileInfoStateHolderProvider)?.username;
      Future(() {
        ref
            .read(editProfileUsernameStateHolder.notifier)
            .updateValue(initialUsername ?? '');
      });
    }
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
        if (screenHeight - 900 < 0) {
          EditProfilePage.animateScrollTo(
              900 - screenHeight, widget.controller);
        }
      },
      onChanged: (value) {
        ref.read(editProfileUsernameStateHolder.notifier).updateValue(value);
        if (value.length < 5) {
          ref.read(editProfileControllerProvider).setTooShortErrorUsername();
          return;
        }
        if (value.length > 16) {
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

class ProfileDescriptionField extends ConsumerStatefulWidget {
  const ProfileDescriptionField({
    super.key,
    required this.controller,
  });

  final ScrollController controller;

  @override
  ConsumerState<ProfileDescriptionField> createState() =>
      _ProfileDescriptionFieldState();
}

class _ProfileDescriptionFieldState
    extends ConsumerState<ProfileDescriptionField> {
  TextEditingController? controller;

  @override
  Widget build(BuildContext context) {
    final screenHeight = (MediaQuery.of(context).size.height -
        MediaQuery.of(context).viewInsets.bottom);
    final initialDescription =
        ref.watch(myProfileInfoStateHolderProvider)?.description;
    if (ref.read(editProfileDescriptionStateHolder) == null) {
      Future(() {
        ref
            .read(editProfileDescriptionStateHolder.notifier)
            .updateValue(initialDescription ?? '');
      });
    }
    controller ??= TextEditingController(text: initialDescription ?? '');
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
                '${controller!.text.length}/140',
                style: context.textStyles.footNote!.copyWith(
                  color: controller!.text.length <= 140
                      ? context.colors.textsDisabled
                      : context.colors.textsError,
                ),
              ),
            ],
          ),
        ),
        TextField(
          controller: controller!,
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
            if (value.length > 140) {
              ref
                  .read(editProfileDescriptionErrorStateHolder.notifier)
                  .updateError(true);
            } else {
              ref
                  .read(editProfileDescriptionErrorStateHolder.notifier)
                  .updateError(false);
            }
            ref
                .read(editProfileDescriptionStateHolder.notifier)
                .updateValue(value);
            setState(() {});
          },
          onTap: () {
            if (screenHeight - 950 < 0) {
              EditProfilePage.animateScrollTo(
                  950 - screenHeight, widget.controller);
            }
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
                            onTap: () async {
                              XFile? image;
                              try {
                                image = await ImagePicker().pickImage(
                                  source: ImageSource.gallery,
                                );
                                if (image == null) throw Exception();
                                ref.read(profileControllerProvider).setPhoto(
                                      await File(image.path).readAsBytes(),
                                    );
                                await ref
                                    .read(pickCoverControllerProvider)
                                    .setImage(image.path);
                                Navigator.pop(context);
                              } catch (e) {
                                Logger.e('Ошибка при выборе из галереи $e');
                                scaffoldMessengerKey.currentState?.showSnackBar(
                                  SnackBars.build(
                                      context, null, "Could not pick image"),
                                );
                                return;
                              }
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
                              } else {
                                scaffoldMessengerKey.currentState?.showSnackBar(
                                  SnackBars.build(
                                      context, null, "Could not pick image"),
                                );
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
