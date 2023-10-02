import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:poster_stock/common/services/text_info_service.dart';
import 'package:poster_stock/common/widgets/app_snack_bar.dart';
import 'package:poster_stock/common/widgets/app_text_button.dart';
import 'package:poster_stock/common/widgets/app_text_field.dart';
import 'package:poster_stock/features/create_list/controllers/pick_cover_controller.dart';
import 'package:poster_stock/features/create_list/state_holders/chosen_cover_state_holder.dart';
import 'package:poster_stock/features/create_list/state_holders/create_list_chosen_poster_state_holder.dart';
import 'package:poster_stock/features/create_list/state_holders/list_search_posters_state_holder.dart';
import 'package:poster_stock/features/create_list/state_holders/lists_search_value_state_holder.dart';
import 'package:poster_stock/features/create_list/view/pick_cover_dialog.dart';
import 'package:poster_stock/features/create_list/view/widgets/%D1%81hoose_poster_tile.dart';
import 'package:poster_stock/features/home/models/post_movie_model.dart';
import 'package:poster_stock/features/navigation_page/controller/menu_controller.dart';
import 'package:poster_stock/features/profile/controllers/profile_controller.dart';
import 'package:poster_stock/features/profile/state_holders/my_profile_info_state_holder.dart';
import 'package:poster_stock/features/profile/state_holders/profile_posts_state_holder.dart';
import 'package:poster_stock/main.dart';
import 'package:poster_stock/themes/build_context_extension.dart';

class CreateListDialog extends ConsumerStatefulWidget {
  const CreateListDialog({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState<CreateListDialog> createState() => _CreateListDialogState();
}

class _CreateListDialogState extends ConsumerState<CreateListDialog> {
  final dragController = DraggableScrollableController();
  final searchController = TextEditingController();
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final FocusNode focus = FocusNode();
  bool disposed = false;
  bool loading = false;

  @override
  void initState() {
    super.initState();
    Future(() {
      ref.read(pickCoverControllerProvider).clearAll();
      ref.read(listSearchValueStateHolderProvider.notifier).clearState();
      ref.read(profilePostsStateHolderProvider.notifier).clearState();
    });
  }

  @override
  void dispose() {
    disposed = true;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final image = ref.watch(chosenCoverStateHolderProvider);
    final searchValue = ref.watch(listSearchValueStateHolderProvider);
    final posts = ref.watch(profilePostsStateHolderProvider);
    final postersSearch = ref.watch(listSearchPostsStateHolderProvider);
    final me = ref.watch(myProfileInfoStateHolderProvider);
    if (posts == null) {
      ref.read(profileControllerApiProvider).getUserInfo(null);
    }
    List<PostMovieModel>? posters;
    if (searchValue.isEmpty) {
      posters = posts;
    } else {
      posters = postersSearch;
    }
    dragController.addListener(() {
      if (dragController.size < 0.1) {
        if (!disposed) {
          ref.read(pickCoverControllerProvider).clearAll();
          ref.read(listSearchValueStateHolderProvider.notifier).clearState();
          Navigator.pop(context);
        }
        disposed = true;
      }
    });
    focus.addListener(() {
      if (focus.hasFocus) {
        dragController.animateTo(
          1,
          duration: Duration(milliseconds: 300),
          curve: Curves.linear,
        );
      }
      setState(() {});
    });
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: Colors.transparent,
        resizeToAvoidBottomInset: true,
        body: Stack(
          children: [
            Positioned(
              top: 0,
              left: 0,
              bottom: 0,
              right: 0,
              child: GestureDetector(
                onTap: () {
                  ref
                      .read(listSearchValueStateHolderProvider.notifier)
                      .clearState();
                  ref.read(pickCoverControllerProvider).clearAll();
                  Navigator.pop(context);
                },
                child: Container(
                  color: Colors.transparent,
                ),
              ),
            ),
            DraggableScrollableSheet(
              controller: dragController,
              minChildSize: 0,
              initialChildSize: 0.7,
              maxChildSize: 1,
              snap: true,
              snapSizes: const [0.7, 1],
              builder: (context, controller) {
                return Container(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(16.0),
                      topLeft: Radius.circular(16.0),
                    ),
                    color: context.colors.backgroundsPrimary,
                  ),
                  child: Column(
                    children: [
                      Expanded(
                        child: NotificationListener<ScrollUpdateNotification>(
                          onNotification: (info) {
                            if (info.metrics.pixels >=
                                info.metrics.maxScrollExtent -
                                    MediaQuery.of(context).size.height) {
                              ref
                                  .read(pickCoverControllerProvider)
                                  .updateSearch(searchValue)
                                  .then((value) {
                                ref
                                    .read(profileControllerApiProvider)
                                    .updatePosts(me!.id);
                              });
                            }
                            return true;
                          },
                          child: CustomScrollView(
                            controller: controller,
                            slivers: [
                              SliverPersistentHeader(
                                delegate: AppDialogHeaderDelegate(
                                  extent: 150,
                                  content: Column(
                                    children: [
                                      const SizedBox(height: 14),
                                      Container(
                                        height: 4,
                                        width: 36,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(2.0),
                                          color: context.colors.fieldsDefault,
                                        ),
                                      ),
                                      const SizedBox(height: 22),
                                      Text(
                                        'Create list',
                                        style: context.textStyles.bodyBold,
                                      ),
                                      const SizedBox(height: 0.5),
                                      SubTextCreateList(),
                                      const SizedBox(height: 16.5),
                                      SizedBox(
                                        height: 36,
                                        child: posters?.isEmpty == true
                                            ? null
                                            : AppTextField(
                                                searchField: true,
                                                focus: focus,
                                                hint: 'Search',
                                                removableWhenNotEmpty: true,
                                                crossPadding:
                                                    const EdgeInsets.all(8.0),
                                                crossButton: SvgPicture.asset(
                                                  'assets/icons/search_cross.svg',
                                                ),
                                                onRemoved: () {
                                                  searchController.clear();
                                                  ref
                                                      .read(
                                                          pickCoverControllerProvider)
                                                      .updateSearch('');
                                                  ref
                                                      .read(
                                                          listSearchValueStateHolderProvider
                                                              .notifier)
                                                      .clearState();
                                                },
                                                onChanged: (value) {
                                                  ref
                                                      .read(
                                                          pickCoverControllerProvider)
                                                      .updateSearch(value);
                                                  ref
                                                      .read(
                                                          listSearchValueStateHolderProvider
                                                              .notifier)
                                                      .updateState(value);
                                                },
                                                controller: searchController,
                                              ),
                                      ),
                                      const SizedBox(height: 16),
                                    ],
                                  ),
                                ),
                                pinned: true,
                              ),
                              if (posters?.isEmpty == true)
                                SliverFillRemaining(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 32.0,
                                      vertical: 16.0,
                                    ),
                                    child: Column(
                                      children: [
                                        SvgPicture.asset(
                                          'assets/icons/empty_collection.svg',
                                          colorFilter: ColorFilter.mode(
                                            context.colors.iconsDisabled!,
                                            BlendMode.srcIn,
                                          ),
                                        ),
                                        const SizedBox(height: 12),
                                        Text(
                                          searchValue.isEmpty
                                              ? 'To create a list, first add posters to your collection.'
                                              : 'No posters found',
                                          style: context
                                              .textStyles.subheadlineBold!
                                              .copyWith(
                                            color: context.colors.textsDisabled,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              if (posters?.isEmpty != true)
                                SliverPadding(
                                  padding:
                                      const EdgeInsets.fromLTRB(16, 0, 16, 24),
                                  sliver: SliverGrid(
                                    delegate: SliverChildBuilderDelegate(
                                      childCount: posters?.length,
                                      (context, index) {
                                        return ChoosePosterTile(
                                          imagePath: posters?[index].imagePath,
                                          name: posters?[index].name,
                                          year: posters?[index].year,
                                          id: posters?[index].id,
                                          index: index,
                                        );
                                      },
                                    ),
                                    gridDelegate:
                                        const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 3,
                                      crossAxisSpacing: 12.5,
                                      mainAxisSpacing: 15,
                                      mainAxisExtent: 201,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                      if (!focus.hasFocus)
                        SizedBox(
                          height: 146,
                        ),
                      Container(
                        color: context.colors.backgroundsPrimary,
                        height: MediaQuery.of(context).padding.bottom,
                      ),
                    ],
                  ),
                );
              },
            ),
            if (!focus.hasFocus)
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Column(
                  children: [
                    Divider(
                      height: 0.5,
                      thickness: 0.5,
                      color: context.colors.fieldsDefault,
                    ),
                    Container(
                      color: context.colors.backgroundsPrimary,
                      height: 56,
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: nameController,
                              decoration: InputDecoration(
                                hintText: 'List name',
                                hintStyle: context.textStyles.callout!.copyWith(
                                  color: context.colors.textsDisabled,
                                ),
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
                              onChanged: (value) {
                                if (nameController.text.length > 70) {
                                  nameController.text =
                                      nameController.text.substring(0, 70);
                                }
                                setState(() {});
                              },
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              dragController
                                  .animateTo(
                                0.7,
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.linear,
                              )
                                  .then((value) async {
                                XFile? image ;
                                try {
                                  image = await ImagePicker().pickImage(
                                    source: ImageSource.gallery,
                                  );
                                } catch (e) {
                                  scaffoldMessengerKey.currentState
                                      ?.showSnackBar(
                                    SnackBars.build(context, null, "Could not pick image"),
                                  );
                                  return;
                                }
                                if (image == null) {
                                  scaffoldMessengerKey.currentState
                                      ?.showSnackBar(
                                    SnackBars.build(context, null, "Could not pick image"),
                                  );
                                  return;
                                }
                                ref
                                    .read(pickCoverControllerProvider)
                                    .setImage(image!.path);
                              });
                            },
                            child: Container(
                              color: context.colors.backgroundsPrimary,
                              child: image == null
                                  ? Row(
                                      children: [
                                        Text(
                                          'Upload cover',
                                          style: context.textStyles.caption2!
                                              .copyWith(
                                            color: context.colors.textsDisabled,
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        SvgPicture.asset(
                                          'assets/icons/ic_pick_photo.svg',
                                          width: 24,
                                        ),
                                        //SizedBox(width: 36, height: 24, child: Image.memory(image, fit: BoxFit.cover, cacheWidth: 24,)),
                                        const SizedBox(width: 16),
                                      ],
                                    )
                                  : Row(
                                      children: [
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(2.0),
                                          child: SizedBox(
                                            width: 36,
                                            height: 24,
                                            child: Image.file(
                                              File(image),
                                              fit: BoxFit.cover,
                                              cacheWidth: 24,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        GestureDetector(
                                          onTap: () {
                                            ref
                                                .read(
                                                    pickCoverControllerProvider)
                                                .removeImage();
                                          },
                                          child: SvgPicture.asset(
                                            'assets/icons/ic_trash.svg',
                                            width: 24,
                                          ),
                                        ),
                                        //SizedBox(width: 36, height: 24, child: Image.memory(image, fit: BoxFit.cover, cacheWidth: 24,)),
                                        const SizedBox(width: 16),
                                      ],
                                    ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                      color: context.colors.backgroundsPrimary,
                      child: DescriptionTextField(
                        buttonAddCheck: nameController.text.isNotEmpty &&
                            ref
                                    .watch(
                                        createListChosenPosterStateHolderProvider)
                                    .length >
                                2 &&
                            ref
                                    .watch(
                                        createListChosenPosterStateHolderProvider)
                                    .length <
                                31,
                        controller: descriptionController,
                        buttonLoading: loading,
                        onTap: () async {
                          loading = true;
                          setState(() {});
                          await ref
                              .read(pickCoverControllerProvider)
                              .createList(
                                title: nameController.text,
                                description: descriptionController.text,
                                context: context,
                              );
                          if (context.mounted) {
                            Navigator.pop(context);
                            ref.read(menuControllerProvider).switchMenu();
                          }
                          loading = false;
                          setState(() {});
                        },
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class SubTextCreateList extends ConsumerWidget {
  const SubTextCreateList({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chosenPosters = ref.watch(createListChosenPosterStateHolderProvider);
    return Text(
      '${chosenPosters.length} of 30 posters',
      style: context.textStyles.footNote!.copyWith(
        color: context.colors.textsSecondary,
      ),
    );
  }
}

class AppDialogHeaderDelegate extends SliverPersistentHeaderDelegate {
  AppDialogHeaderDelegate({
    required this.content,
    required this.extent,
  });

  final Widget content;
  final double extent;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topRight: Radius.circular(16.0),
        topLeft: Radius.circular(16.0),
      ),
      child: Material(
        color: context.colors.backgroundsPrimary,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: content,
        ),
      ),
    );
  }

  @override
  double get maxExtent => extent;

  @override
  double get minExtent => extent;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}

class DescriptionTextField extends StatefulWidget {
  const DescriptionTextField({
    super.key,
    this.hint,
    this.showDivider = true,
    this.button,
    this.maxSymbols = 140,
    this.buttonAddCheck = true,
    this.controller,
    this.buttonLoading = false,
    this.onTap,
    this.focus,
  });

  final String? hint;
  final bool showDivider;
  final String? button;
  final int maxSymbols;
  final bool buttonAddCheck;
  final bool buttonLoading;
  final FocusNode? focus;
  final TextEditingController? controller;
  final void Function()? onTap;

  @override
  State<DescriptionTextField> createState() => _DescriptionTextFieldState();
}

class _DescriptionTextFieldState extends State<DescriptionTextField> {
  TextEditingController? descriptionController;

  @override
  Widget build(BuildContext context) {
    descriptionController ??= widget.controller ?? TextEditingController();
    return Column(
      children: [
        if (widget.showDivider)
          Divider(
            height: 0.5,
            thickness: 0.5,
            color: context.colors.fieldsDefault,
          ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: TextField(
            focusNode: widget.focus,
            maxLines: null,
            controller: descriptionController,
            cursorWidth: 1,
            cursorColor: context.colors.textsAction,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: widget.hint ?? 'Description your list',
              hintStyle: context.textStyles.callout!.copyWith(
                color: context.colors.textsDisabled,
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 4.0),
            ),
            style: context.textStyles.callout!.copyWith(
              overflow: TextOverflow.visible,
              color: context.colors.textsPrimary,
            ),
            onChanged: (value) {
              setState(() {});
            },
          ),
        ),
        Container(
          height: 56 + MediaQuery.of(context).padding.bottom,
          color: context.colors.backgroundsPrimary,
          child: Row(
            children: [
              const Spacer(),
              if (descriptionController!.text.isNotEmpty)
                Text(
                  '${descriptionController!.text.length}/${widget.maxSymbols}',
                  style: context.textStyles.footNote!.copyWith(
                    color:
                        descriptionController!.text.length > widget.maxSymbols
                            ? context.colors.textsError
                            : context.colors.textsDisabled,
                  ),
                ),
              const SizedBox(width: 12),
              SizedBox(
                height: 32,
                width: TextInfoService.textSize(
                      widget.button ?? "Create list",
                      context.textStyles.calloutBold!.copyWith(
                        color: context.colors.textsBackground,
                      ),
                    ).width +
                    32,
                child: AppTextButton(
                  disabled: (descriptionController!.text.isEmpty ||
                          descriptionController!.text.length >
                              widget.maxSymbols) ||
                      !widget.buttonAddCheck,
                  onTap: widget.onTap,
                  child: widget.buttonLoading
                      ? Center(
                          child: defaultTargetPlatform != TargetPlatform.android
                              ? CupertinoActivityIndicator(
                                  radius: 10.0,
                                  color: context.colors.textsBackground!,
                                )
                              : SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(
                                    color: context.colors.textsBackground!,
                                    strokeWidth: 2,
                                  ),
                                ),
                        )
                      : Text(
                          widget.button ?? "Create list",
                          style: context.textStyles.calloutBold!.copyWith(
                            color: context.colors.textsBackground,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                ),
              ),
              const SizedBox(width: 16),
            ],
          ),
        ),
      ],
    );
  }
}
