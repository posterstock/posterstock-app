import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:poster_stock/common/widgets/app_text_button.dart';
import 'package:poster_stock/common/widgets/app_text_field.dart';
import 'package:poster_stock/features/create_list/view/create_list_dialog.dart';
import 'package:poster_stock/features/create_poster/controller/create_poster_controller.dart';
import 'package:poster_stock/features/create_poster/state_holder/create_poster_chosen_movie_state_holder.dart';
import 'package:poster_stock/features/create_poster/state_holder/create_poster_chosen_poster_state_holder.dart';
import 'package:poster_stock/features/create_poster/state_holder/create_poster_images_state_holder.dart';
import 'package:poster_stock/features/create_poster/state_holder/create_poster_search_state_holder.dart';
import 'package:poster_stock/themes/build_context_extension.dart';

class CreatePosterDialog extends ConsumerStatefulWidget {
  const CreatePosterDialog({
    Key? key,
    this.bookmark = false,
  }) : super(key: key);
  final bool bookmark;

  @override
  ConsumerState<CreatePosterDialog> createState() => _CreatePosterDialogState();
}

class _CreatePosterDialogState extends ConsumerState<CreatePosterDialog> {
  final dragController = DraggableScrollableController();
  final searchController = TextEditingController();
  final focus = FocusNode();
  bool disposed = false;

  @override
  void dispose() {
    disposed = true;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    focus.addListener(() {
      setState(() {});
    });
    final String searchText = ref.watch(createPosterSearchStateHolderNotifier);
    final (String, String)? chosenMovie =
        ref.watch(createPosterChoseMovieStateHolderProvider);
    final List<String> images =
        ref.watch(createPosterImagesStateHolderProvider);
    if (searchText != searchController.text) {
      searchController.text = searchText;
    }
    dragController.addListener(() {
      if (dragController.size < 0.1) {
        if (!disposed) {
          ref.read(createPosterControllerProvider).choosePoster(null);
          ref.read(createPosterControllerProvider).chooseMovie(null);
          ref.read(createPosterControllerProvider).updateSearch('');
          Navigator.pop(context);
        }
        disposed = true;
      }
    });
    if (focus.hasFocus) {
      dragController
          .animateTo(
        1,
        duration: const Duration(milliseconds: 100),
        curve: Curves.linear,
      )
          .then((value) {
        if (dragController.size != 1) {
          dragController.animateTo(
            1,
            duration: const Duration(milliseconds: 100),
            curve: Curves.linear,
          );
        }
      });
    }
    searchController.text = chosenMovie?.$1 ?? searchController.text;
    double constValue = 540;
    if (widget.bookmark) constValue = 480;
    return WillPopScope(
      onWillPop: () async {
        ref.read(createPosterControllerProvider).choosePoster(null);
        ref.read(createPosterControllerProvider).chooseMovie(null);
        ref.read(createPosterControllerProvider).updateSearch('');
        return true;
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
                  ref.read(createPosterControllerProvider).choosePoster(null);
                  ref.read(createPosterControllerProvider).chooseMovie(null);
                  ref.read(createPosterControllerProvider).updateSearch('');
                  Navigator.pop(context);
                },
                child: Container(
                  color: Colors.transparent,
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                FocusScope.of(context).unfocus();
              },
              child: DraggableScrollableSheet(
                controller: dragController,
                minChildSize: 0,
                initialChildSize: constValue /
                    (MediaQuery.of(context).size.height -
                        MediaQuery.of(context).padding.bottom),
                maxChildSize: focus.hasFocus
                    ? 1
                    : constValue /
                        (MediaQuery.of(context).size.height -
                            MediaQuery.of(context).padding.bottom),
                snap: true,
                snapSizes: [
                  constValue /
                      (MediaQuery.of(context).size.height -
                          MediaQuery.of(context).padding.bottom)
                ],
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
                                  extent:
                                      searchText.isNotEmpty && chosenMovie == null
                                          ? 125
                                          : 150,
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
                                        widget.bookmark
                                            ? 'Add bookmark'
                                            : 'Add poster',
                                        style: context.textStyles.bodyBold,
                                      ),
                                      const SizedBox(height: 17),
                                      SizedBox(
                                        height: 36,
                                        child: Stack(
                                          children: [
                                            AppTextField(
                                              searchField: true,
                                              focus: focus,
                                              hint: 'Movie or TV Series',
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
                                                        createPosterControllerProvider)
                                                    .updateSearch('');
                                              },
                                              onChanged: (value) {
                                                ref
                                                    .read(
                                                        createPosterControllerProvider)
                                                    .chooseMovie(null);
                                                ref
                                                    .read(
                                                        createPosterControllerProvider)
                                                    .updateSearch(value);
                                              },
                                              controller: searchController,
                                            ),
                                            if (chosenMovie?.$2 != null)
                                              Positioned(
                                                left: 50,
                                                top: 0,
                                                bottom: 0,
                                                child: Align(
                                                  alignment: Alignment.centerLeft,
                                                  child: Row(
                                                    children: [
                                                      Text(
                                                        chosenMovie!.$1,
                                                        style: context.textStyles
                                                            .bodyRegular!
                                                            .copyWith(
                                                          color:
                                                              Colors.transparent,
                                                        ),
                                                      ),
                                                      Text(
                                                        chosenMovie!.$2,
                                                        style: context
                                                            .textStyles.caption1!
                                                            .copyWith(
                                                          color: context.colors
                                                              .textsSecondary,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                          ],
                                        ),
                                      ),
                                      if (searchText.isEmpty ||
                                          chosenMovie != null)
                                        SizedBox(height: 16),
                                    ],
                                  ),
                                ),
                                pinned: true,
                              ),
                              if (searchText.isEmpty || chosenMovie != null)
                                SliverToBoxAdapter(
                                  child: SizedBox(
                                    height: 160,
                                    child: ListView.separated(
                                      itemCount: chosenMovie == null
                                          ? 20
                                          : images.length,
                                      itemBuilder: (context, index) => Padding(
                                        padding: EdgeInsets.only(
                                            left: index == 0 ? 16.0 : 0.0,
                                            right: index ==
                                                    ((chosenMovie == null
                                                            ? 20
                                                            : images.length) -
                                                        1)
                                                ? 16.0
                                                : 0.0),
                                        child: ChoosePosterRadio(
                                          chosenMovie: chosenMovie,
                                          images: images,
                                          index: index,
                                        ),
                                      ),
                                      separatorBuilder: (context, index) =>
                                          const SizedBox(
                                        width: 8,
                                      ),
                                      scrollDirection: Axis.horizontal,
                                    ),
                                  ),
                                ),
                              if (searchText.isNotEmpty && chosenMovie == null)
                                SliverList.builder(
                                  itemBuilder: (context, index) => Material(
                                    color: context.colors.backgroundsPrimary,
                                    child: InkWell(
                                      onTap: () {
                                        ref
                                            .read(createPosterControllerProvider)
                                            .chooseMovie(
                                          ('Jay and Silent bob', '1999'),
                                        );
                                        focus.unfocus();
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                          16.0,
                                          12.0,
                                          16.0,
                                          12.0,
                                        ),
                                        child: Row(
                                          children: [
                                            Text(
                                              'Jay and Silent bob',
                                              style:
                                                  context.textStyles.bodyRegular,
                                            ),
                                            const SizedBox(
                                              width: 8,
                                            ),
                                            Text(
                                              '1999',
                                              style: context.textStyles.caption1!
                                                  .copyWith(
                                                color:
                                                    context.colors.textsSecondary,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              SliverToBoxAdapter(
                                child: SizedBox(
                                  height:
                                      MediaQuery.of(context).padding.bottom + 130,
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            if (!focus.hasFocus && searchController.text.isEmpty ||
                chosenMovie != null)
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
                      height: 17.5,
                      color: context.colors.backgroundsPrimary,
                    ),
                    if (!widget.bookmark)
                      Container(
                        color: context.colors.backgroundsPrimary,
                        child: const DescriptionTextField(
                          hint:
                              'Share your one-line review with your audience, it matters for them.',
                          showDivider: false,
                          button: 'Add poster',
                          maxSymbols: 280,
                        ),
                      ),
                    if (widget.bookmark)
                      Container(
                          color: context.colors.backgroundsPrimary,
                          child: Padding(
                            padding: EdgeInsets.only(
                                bottom: MediaQuery.of(context).padding.bottom),
                            child: Container(
                              height: 36,
                              color: context.colors.backgroundsPrimary,
                              child: Row(
                                children: [
                                  const Spacer(),
                                  AppTextButton(
                                    text: "Add bookmark",
                                    disabled: chosenMovie == null,
                                  ),
                                  const SizedBox(width: 16),
                                ],
                              ),
                            ),
                          )),
                    Container(
                      height: MediaQuery.of(context).padding.bottom,
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

class ChoosePosterRadio extends ConsumerWidget {
  const ChoosePosterRadio({
    super.key,
    required this.chosenMovie,
    required this.images,
    required this.index,
  });

  final (String, String)? chosenMovie;
  final List<String> images;
  final int index;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chosenPoster = ref.watch(createPosterChosenPosterStateHolderProvider);
    return Stack(
      children: [
        GestureDetector(
          onTap: () {
            if (images.length > index) {
              ref
                  .read(createPosterControllerProvider)
                  .choosePoster((index, images[index]));
            }
          },
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: Container(
              width: 106,
              height: 160,
              color: context.colors.backgroundsSecondary,
              child: chosenMovie == null
                  ? null
                  : Image.network(
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
                    .read(createPosterControllerProvider)
                    .choosePoster((index, images[index]));
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
