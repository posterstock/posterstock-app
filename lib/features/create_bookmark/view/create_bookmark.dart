import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:poster_stock/common/widgets/app_text_button.dart';
import 'package:poster_stock/common/widgets/app_text_field.dart';
import 'package:poster_stock/features/create_bookmark/controller/bookmarks_controller.dart';
import 'package:poster_stock/features/create_bookmark/state_holders/bookmarks_chosen_poster_state_holder.dart';
import 'package:poster_stock/features/create_list/view/create_list_dialog.dart';
import 'package:poster_stock/features/create_poster/controller/create_poster_controller.dart';
import 'package:poster_stock/themes/build_context_extension.dart';

class CreateBookmarkDialog extends ConsumerStatefulWidget {
  const CreateBookmarkDialog({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState<CreateBookmarkDialog> createState() =>
      _CreateBookmarkDialogState();
}

class _CreateBookmarkDialogState extends ConsumerState<CreateBookmarkDialog> {
  final dragController = DraggableScrollableController();
  final searchController = TextEditingController();
  final FocusNode focus = FocusNode();
  bool disposed = false;
  bool animate = false;

  @override
  void dispose() {
    disposed = true;
    ref
        .read(bookmarksControllerProvider)
        .clearPoster();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (animate) {
      animate = false;
      Future((){
        dragController.animateTo(1, duration: Duration(milliseconds: 300), curve: Curves.linear);
      });
    }
    dragController.addListener(() {
      if (dragController.size < 0.1) {
        if (!disposed) {
          Navigator.pop(context);
        }
        disposed = true;
      }
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
              initialChildSize: 540 / (MediaQuery.of(context).size.height - MediaQuery.of(context).padding.bottom),
              maxChildSize:
              focus.hasFocus ? 1 : 540 / (MediaQuery.of(context).size.height - MediaQuery.of(context).padding.bottom),
              snap: true,
              snapSizes: [540 / (MediaQuery.of(context).size.height - MediaQuery.of(context).padding.bottom)],
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
                                extent: 135,
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
                                      'Add bookmark',
                                      style: context.textStyles.bodyBold,
                                    ),
                                    const SizedBox(height: 17),
                                    SizedBox(
                                      height: 36,
                                      child: AppTextField(
                                        focus: focus,
                                        searchField: true,
                                        hint: 'Movie or TV Series',
                                        removableWhenNotEmpty: true,
                                        crossPadding: const EdgeInsets.all(8.0),
                                        crossButton: SvgPicture.asset(
                                          'assets/icons/search_cross.svg',
                                        ),
                                        onRemoved: () {
                                          searchController.clear();
                                        },
                                        onTap: () {
                                          animate = true;
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
                                    return BookmarkChoosePosterRadio(
                                      images: List.generate(15, (index) =>
                                      index % 2 == 0
                                          ? 'https://image.api.playstation.com/vulcan/ap/rnd/202211/0720/hDCW9HZGHnWVaFRbcBlEgadl.png'
                                          : 'https://lumiere-a.akamaihd.net/v1/images/lswss-keyart-digital-1e_33_c1428772.jpeg?region=1%2C0%2C999%2C999',),
                                      index: index,
                                    );
                                  },
                                ),
                                gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                  crossAxisSpacing: 12.5,
                                  mainAxisSpacing: 15,
                                  mainAxisExtent:
                                  150,
                                ),
                              ),
                            ),
                            SliverToBoxAdapter(child: SizedBox(height: MediaQuery
                                .of(context)
                                .padding
                                .bottom + 80,),)
                          ],
                        ),
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
                  Divider(
                    height: 1,
                    thickness: 1,
                    color: context.colors.fieldsDefault,
                  ),
                  Container(
                    color: context.colors.backgroundsPrimary,
                    child: const Row(
                      children: [
                        Spacer(),
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 16.0,
                            vertical: 12.0,
                          ),
                          child: AppTextButton(text: 'Add bookmark'),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: MediaQuery
                        .of(context)
                        .padding
                        .bottom,
                    color: context.colors.backgroundsPrimary,
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

class ChooseOnlyPosterTile extends StatelessWidget {
  const ChooseOnlyPosterTile({
    Key? key,
    required this.chosen,
    required this.imagePath,
    this.name,
    this.year,
  }) : super(key: key);
  final bool chosen;
  final String imagePath;
  final String? name;
  final String? year;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {},
          child: Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Container(
                  color: context.colors.backgroundsSecondary,
                  height: 160,
                  width: double.infinity,
                  child: Image.network(
                    imagePath,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Positioned(
                  top: 4,
                  right: 4,
                  child: Container(
                    width: 22,
                    height: 22,
                    decoration: BoxDecoration(
                      color: chosen
                          ? context.colors.backgroundsPrimary
                          : context.colors.textsBackground!.withOpacity(0.4),
                      shape: BoxShape.circle,
                    ),
                    child: chosen
                        ? Center(
                      child: Container(
                        width: 4,
                        height: 4,
                        decoration: BoxDecoration(
                          color: context.colors.iconsActive,
                          shape: BoxShape.circle,
                        ),
                      ),
                    )
                        : null,
                  )),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Text(
          name ?? '',
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: context.textStyles.caption2!.copyWith(
            color: context.colors.textsPrimary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          year ?? '',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: context.textStyles.caption1!.copyWith(
            color: context.colors.textsDisabled,
          ),
        ),
      ],
    );
  }
}

class BookmarkChoosePosterRadio extends ConsumerWidget {
  const BookmarkChoosePosterRadio({
    super.key,
    required this.images,
    required this.index,
  });

  final List<String> images;
  final int index;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chosenPoster = ref.watch(bookmarksChosenPosterStateHolderProvider);
    return Stack(
      children: [
        GestureDetector(
          onTap: () {
            if (images.length > index) {
              ref
                  .read(bookmarksControllerProvider)
                  .updatePoster((index, images[index]));
            }
          },
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: Container(
              width: 106,
              height: 160,
              color: context.colors.backgroundsSecondary,
              child: Image.network(
                images[index],
                fit: BoxFit.cover,
                cacheWidth: 200,
              ),
            ),
          ),
        ),
        Positioned(
          right: 4,
          top: 4,
          child: GestureDetector(
            onTap: () {
              if (images.length > index) {
                ref
                    .read(bookmarksControllerProvider)
                    .updatePoster((index, images[index]));
              }
            },
            child: AnimatedContainer(
                width: 22,
                height: 22,
                duration: Duration(milliseconds: 150),
                decoration: BoxDecoration(
                  color: context.colors.backgroundsPrimary!
                      .withOpacity(chosenPoster?.$1 == index ? 1 : 0.4),
                  shape: BoxShape.circle,
                ),
                child: chosenPoster?.$1 == index
                    ? Center(
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 150),
                    width: 4,
                    height: 4,
                    decoration: BoxDecoration(
                      color: context.colors.iconsActive,
                      shape: BoxShape.circle,
                    ),
                  ),
                )
                    : null),
          ),
        ),
      ],
    );
  }
}