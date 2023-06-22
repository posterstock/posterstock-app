import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:poster_stock/common/widgets/app_text_button.dart';
import 'package:poster_stock/common/widgets/app_text_field.dart';
import 'package:poster_stock/features/create_list/controllers/pick_cover_controller.dart';
import 'package:poster_stock/features/create_list/state_holders/chosen_cover_state_holder.dart';
import 'package:poster_stock/features/create_list/view/pick_cover_dialog.dart';
import 'package:poster_stock/features/create_list/view/widgets/%D1%81hoose_poster_tile.dart';
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
  bool disposed = false;

  @override
  void dispose() {
    disposed = true;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final image = ref.watch(chosenCoverStateHolderProvider);
    dragController.addListener(() {
      if (dragController.size < 0.1) {
        if (!disposed) {
          Navigator.pop(context);
        }
        disposed = true;
      }
    });
    return Scaffold(
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
                                      borderRadius: BorderRadius.circular(2.0),
                                      color: context.colors.fieldsDefault,
                                    ),
                                  ),
                                  const SizedBox(height: 22),
                                  Text(
                                    'Create list',
                                    style: context.textStyles.bodyBold,
                                  ),
                                  const SizedBox(height: 0.5),
                                  Text(
                                    '0 of 30 posters',
                                    style:
                                        context.textStyles.footNote!.copyWith(
                                      color: context.colors.textsSecondary,
                                    ),
                                  ),
                                  const SizedBox(height: 16.5),
                                  SizedBox(
                                    height: 36,
                                    child: AppTextField(
                                      searchField: true,
                                      hint: 'Search',
                                      removableWhenNotEmpty: true,
                                      crossPadding: const EdgeInsets.all(8.0),
                                      crossButton: SvgPicture.asset(
                                        'assets/icons/search_cross.svg',
                                      ),
                                      onRemoved: () {
                                        searchController.clear();
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
                          SliverPadding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            sliver: SliverGrid(
                              delegate: SliverChildBuilderDelegate(
                                childCount: 15,
                                (context, index) {
                                  return ChoosePosterTile(
                                    imagePath:
                                        'https://i.ebayimg.com/images/g/3JkAAOSwOU9jJjJi/s-l1600.jpg',
                                    name: 'Star Wars',
                                    year: '1999',
                                    index: index,
                                  );
                                },
                              ),
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                crossAxisSpacing: 12.5,
                                mainAxisSpacing: 15,
                                mainAxisExtent:
                                    ((MediaQuery.of(context).size.width - 57) /
                                            3) /
                                        106 *
                                        195,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
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
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Column(
              children: [
                Container(
                  color: context.colors.backgroundsPrimary,
                  height: 56,
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
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
                              .then(
                                (value) => showModalBottomSheet(
                                  context: context,
                                  backgroundColor: Colors.transparent,
                                  isScrollControlled: true,
                                  useSafeArea: true,
                                  builder: (context) => PickCoverDialog(
                                    onItemTap: (BuildContext context,
                                        WidgetRef ref, Uint8List image) {
                                      ref
                                          .read(pickCoverControllerProvider)
                                          .setImage(image);
                                      Navigator.pop(context);
                                    },
                                  ),
                                ),
                              );
                        },
                        child: Container(
                          color: context.colors.backgroundsPrimary,
                          child: image == null
                              ? Row(
                                  children: [
                                    Text(
                                      'Upload cover',
                                      style:
                                          context.textStyles.caption2!.copyWith(
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
                                      borderRadius: BorderRadius.circular(2.0),
                                      child: SizedBox(
                                        width: 36,
                                        height: 24,
                                        child: Image.memory(
                                          image,
                                          fit: BoxFit.cover,
                                          cacheWidth: 24,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    GestureDetector(
                                      onTap: () {
                                        ref
                                            .read(pickCoverControllerProvider)
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
                  child: const DescriptionTextField(),
                ),
              ],
            ),
          ),
        ],
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
  const DescriptionTextField({super.key, this.hint, this.showDivider = true});

  final String? hint;
  final bool showDivider;

  @override
  State<DescriptionTextField> createState() => _DescriptionTextFieldState();
}

class _DescriptionTextFieldState extends State<DescriptionTextField> {
  final TextEditingController descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (widget.showDivider)
          Divider(
            height: 0.5,
            thickness: 0.5,
            color: context.colors.fieldsDefault,
          ),
        Container(
          height: 32 + MediaQuery.of(context).padding.bottom,
          color: context.colors.backgroundsPrimary,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: TextField(
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
                  contentPadding: const EdgeInsets.symmetric(horizontal: 4.0)),
              onChanged: (value) {
                setState(() {});
              },
            ),
          ),
        ),
        Container(
          height: 56,
          color: context.colors.backgroundsPrimary,
          child: Row(
            children: [
              const Spacer(),
              if (descriptionController.text.isNotEmpty)
                Text(
                  '${descriptionController.text.length}/140',
                  style: context.textStyles.footNote!.copyWith(
                    color: descriptionController.text.length > 140
                        ? context.colors.textsError
                        : context.colors.textsDisabled,
                  ),
                ),
              const SizedBox(width: 12),
              AppTextButton(
                text: "Create list",
                disabled: descriptionController.text.isEmpty ||
                    descriptionController.text.length > 140,
              ),
              const SizedBox(width: 16),
            ],
          ),
        )
      ],
    );
  }
}
