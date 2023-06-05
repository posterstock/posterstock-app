import 'dart:math';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:poster_stock/common/widgets/custom_scaffold.dart';
import 'package:poster_stock/themes/build_context_extension.dart';

class EditProfilePage extends StatelessWidget {
  const EditProfilePage({Key? key}) : super(key: key);

  static const List<Color> avatar = [
    Color(0xfff09a90),
    Color(0xfff3d376),
    Color(0xff92bdf4),
  ];

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      backgroundColor: context.colors.backgroundsSecondary,
      child: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
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
                    backgroundColor: Colors.transparent,
                    isScrollControlled: true,
                  );
                },
                child: CircleAvatar(
                  radius: 50,
                  backgroundColor: avatar[Random().nextInt(3)],
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
                onPressed: () {},
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
                      width: 100,
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
                        keyboardType: TextInputType.phone,
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
                          color: context.colors.textsPrimary,
                        ),
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
                      width: 100,
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
                      child: TextField(
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          prefixText: '@',
                          filled: true,
                          fillColor: context.colors.backgroundsPrimary,
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20.0,
                            vertical: 12.0,
                          ),
                        ),
                        style: context.textStyles.callout!.copyWith(
                          color: context.colors.textsPrimary,
                        ),
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
              const SizedBox(height: 40),
              Divider(
                height: 1,
                thickness: 1,
                color: context.colors.fieldsDefault,
              ),
              Column(
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
                          '0/140',
                          style: context.textStyles.footNote!.copyWith(
                            color: context.colors.textsDisabled,
                          ),
                        ),
                      ],
                    ),
                  ),
                  TextField(
                    keyboardType: TextInputType.phone,
                    maxLines: null,
                    minLines: 5,
                    decoration: InputDecoration(
                      hintText: 'What can you say about it?',
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
                  ),
                ],
              ),
              Divider(
                height: 1,
                thickness: 1,
                color: context.colors.fieldsDefault,
              ),
            ],
          ),
        ),
      ),
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
                              print(1);
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
                            onTap: () {
                              print(1);
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
                              print(1);
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
