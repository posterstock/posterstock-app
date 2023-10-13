import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:poster_stock/common/helpers/custom_ink_well.dart';
import 'package:poster_stock/common/services/text_info_service.dart';
import 'package:poster_stock/common/widgets/app_text_button.dart';
import 'package:poster_stock/common/widgets/app_text_field.dart';
import 'package:poster_stock/features/create_list/view/create_list_dialog.dart';
import 'package:poster_stock/features/create_poster/controller/create_poster_controller.dart';
import 'package:poster_stock/features/create_poster/model/media_model.dart';
import 'package:poster_stock/features/create_poster/state_holder/create_poster_chosen_movie_state_holder.dart';
import 'package:poster_stock/features/create_poster/state_holder/create_poster_chosen_poster_state_holder.dart';
import 'package:poster_stock/features/create_poster/state_holder/create_poster_images_state_holder.dart';
import 'package:poster_stock/features/create_poster/state_holder/create_poster_loading_state_holder.dart';
import 'package:poster_stock/features/create_poster/state_holder/create_poster_search_list.dart';
import 'package:poster_stock/features/create_poster/state_holder/create_poster_search_state_holder.dart';
import 'package:poster_stock/features/home/view/widgets/shimmer_loader.dart';
import 'package:poster_stock/features/navigation_page/controller/menu_controller.dart';
import 'package:poster_stock/features/poster/state_holder/poster_state_holder.dart';
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
  final descController = TextEditingController();
  final focus = FocusNode();
  final focusSec = FocusNode();
  bool disposed = false;

  @override
  void dispose() {
    disposed = true;
    super.dispose();
  }

  Future<bool> tryExit() async {
    bool? exit = await showDialog(
      context: context,
      builder: (context) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 38.0),
        child: Center(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16.0),
            child: Container(
              height: 132,
              decoration: BoxDecoration(
                color: context.colors.backgroundsPrimary,
                borderRadius: BorderRadius.circular(16.0),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x29000000),
                    offset: Offset(0, 16),
                    blurRadius: 24,
                    spreadRadius: 0,
                  )
                ],
              ),
              child: Column(
                children: [
                  Expanded(
                    child: Center(
                      child: Text(
                        'Do you want to discard\nthe ${widget.bookmark ? 'bookmark' : 'post'}?',
                        style: context.textStyles.bodyBold,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  Divider(
                    height: 0.5,
                    thickness: 0.5,
                    color: context.colors.fieldsDefault,
                  ),
                  SizedBox(
                    height: 52,
                    child: Row(
                      children: [
                        Expanded(
                          child: CustomInkWell(
                            onTap: () {
                              Navigator.pop(context, true);
                            },
                            child: Center(
                              child: Text(
                                'Discard',
                                style: context.textStyles.bodyRegular!.copyWith(
                                  color: context.colors.textsError,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: CustomInkWell(
                            onTap: () {
                              Navigator.pop(context, false);
                            },
                            child: Center(
                              child: Text(
                                'Cancel',
                                style: context.textStyles.bodyRegular,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
    return exit ?? false;
  }

  bool popping = false;

  @override
  Widget build(BuildContext context) {
    focus.addListener(() {
      setState(() {});
    });
    focusSec.addListener(() {
      setState(() {});
    });
    final String searchText = ref.watch(createPosterSearchStateHolderNotifier);
    final List<MediaModel>? results =
        ref.watch(createPosterSearchListStateHolderProvider);
    final MediaModel? chosenMovie =
        ref.watch(createPosterChoseMovieStateHolderProvider);
    final List<String> images =
        ref.watch(createPosterImagesStateHolderProvider);
    final chosenCover = ref.watch(createPosterChosenPosterStateHolderProvider);
    if (searchText != searchController.text) {
      searchController.text = searchText;
    }
    dragController.addListener(() async {
      if (dragController.size < 0.1) {
        if (!disposed && !popping) {
          popping = true;
          bool exit = await tryExit();
          if (!exit) {
            dragController
                .animateTo(0.7,
                    duration: Duration(milliseconds: 200), curve: Curves.linear)
                .then((value) => popping = false);
            return;
          }
          ref.read(createPosterControllerProvider).choosePoster(null);
          ref.read(createPosterControllerProvider).chooseMovie(null);
          ref.read(createPosterControllerProvider).updateSearch('');
          popping = false;
          disposed = true;
          Navigator.pop(context);
        }
      }
    });
    if (focus.hasFocus || focusSec.hasFocus) {
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
    if (chosenMovie != null && chosenMovie.title != searchController.text) {
      searchController.text = chosenMovie.title;
      searchController.selection = TextSelection(
        baseOffset: searchController.text.length,
        extentOffset: searchController.text.length,
      );
    }
    double constValue = 540;
    if (widget.bookmark) constValue = 480;
    return WillPopScope(
      onWillPop: () async {
        bool exit = await tryExit();
        if (!exit) return false;
        ref.read(createPosterControllerProvider).choosePoster(null);
        ref.read(createPosterControllerProvider).chooseMovie(null);
        ref.read(createPosterControllerProvider).updateSearch('');
        return exit;
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
                onTap: () async {
                  bool exit = await tryExit();
                  if (!exit) return;
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
                maxChildSize: focus.hasFocus || focusSec.hasFocus
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
                                  extent: searchText.isNotEmpty &&
                                          chosenMovie == null
                                      ? 125
                                      : 150,
                                  content: Stack(
                                    children: [
                                      Column(
                                        children: [
                                          const SizedBox(height: 14),
                                          Container(
                                            height: 4,
                                            width: 36,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(2.0),
                                              color:
                                                  context.colors.fieldsDefault,
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
                                                  controller: searchController,
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
                                                    if (chosenMovie != null) {
                                                      ref
                                                          .read(
                                                              createPosterControllerProvider)
                                                          .chooseMovie(null);
                                                    }
                                                    ref
                                                        .read(
                                                            createPosterControllerProvider)
                                                        .updateSearch(value);
                                                  },
                                                ),
                                                if (chosenMovie?.startYear !=
                                                    null)
                                                  Positioned(
                                                    left: 50,
                                                    top: 0,
                                                    bottom: 0,
                                                    child: IgnorePointer(
                                                      ignoring: true,
                                                      child: Align(
                                                        alignment: Alignment
                                                            .centerLeft,
                                                        child: Row(
                                                          children: [
                                                            Text(
                                                              chosenMovie!
                                                                  .title,
                                                              style: context
                                                                  .textStyles
                                                                  .bodyRegular!
                                                                  .copyWith(
                                                                color: Colors
                                                                    .transparent,
                                                              ),
                                                            ),
                                                            Text(
                                                              chosenMovie
                                                                  .startYear
                                                                  .toString(),
                                                              style: context
                                                                  .textStyles
                                                                  .caption1!
                                                                  .copyWith(
                                                                color: context
                                                                    .colors
                                                                    .textsSecondary,
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                              ),
                                                            ),
                                                            if (chosenMovie
                                                                    .endYear !=
                                                                null)
                                                              Text(
                                                                ' - ${chosenMovie.endYear}',
                                                                style: context
                                                                    .textStyles
                                                                    .caption1!
                                                                    .copyWith(
                                                                  color: context
                                                                      .colors
                                                                      .textsSecondary,
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                ),
                                                              ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                              ],
                                            ),
                                          ),
                                          if (searchText.isEmpty ||
                                              chosenMovie != null)
                                            const SizedBox(height: 16),
                                        ],
                                      ),
                                      Positioned(
                                        right: 0,
                                        top: 70,
                                        bottom: searchController.text.isEmpty
                                            ? 30
                                            : 0,
                                        child: GestureDetector(
                                          behavior: HitTestBehavior.opaque,
                                          onTap: () {
                                            searchController.clear();
                                            ref
                                                .read(
                                                    createPosterControllerProvider)
                                                .updateSearch('');
                                          },
                                          child: Container(
                                            color: Colors.transparent,
                                            width: 60,
                                          ),
                                        ),
                                      ),
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
                              if (searchText.isNotEmpty && results == null)
                                SliverFillRemaining(
                                  child: Center(
                                    child: defaultTargetPlatform !=
                                            TargetPlatform.android
                                        ? const CupertinoActivityIndicator(
                                            radius: 10,
                                          )
                                        : SizedBox(
                                            width: 20,
                                            height: 20,
                                            child: CircularProgressIndicator(
                                              color:
                                                  context.colors.iconsDisabled!,
                                              strokeWidth: 2,
                                            ),
                                          ),
                                  ),
                                ),
                              if (searchText.isNotEmpty &&
                                  results != null &&
                                  chosenMovie == null)
                                SliverList.builder(
                                  itemCount: results.length,
                                  itemBuilder: (context, index) => Material(
                                    color: context.colors.backgroundsPrimary,
                                    child: InkWell(
                                      onTap: () {
                                        ref
                                            .read(
                                                createPosterControllerProvider)
                                            .chooseMovie(
                                              (results[index]),
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
                                            SizedBox(
                                              width: TextInfoService.textSize(
                                                        results[index].title,
                                                        context.textStyles
                                                            .bodyRegular!,
                                                      ).width >
                                                      (MediaQuery.of(context)
                                                              .size
                                                              .width -
                                                          54 -
                                                          TextInfoService.textSize(
                                                                  results[index]
                                                                              .endYear ==
                                                                          null
                                                                      ? results[index]
                                                                          .startYear
                                                                          .toString()
                                                                      : '${results[index].startYear} - ${results[index].endYear}',
                                                                  context
                                                                      .textStyles
                                                                      .caption1!)
                                                              .width)
                                                  ? (MediaQuery.of(context)
                                                          .size
                                                          .width -
                                                      54 -
                                                      TextInfoService.textSize(
                                                              results[index]
                                                                          .endYear ==
                                                                      null
                                                                  ? results[index]
                                                                      .startYear
                                                                      .toString()
                                                                  : '${results[index].startYear} - ${results[index].endYear}',
                                                              context.textStyles
                                                                  .caption1!)
                                                          .width)
                                                  : TextInfoService.textSize(
                                                      results[index].title,
                                                      context.textStyles
                                                          .bodyRegular!,
                                                    ).width,
                                              child: Text(
                                                results[index].title,
                                                style: context
                                                    .textStyles.bodyRegular,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 8,
                                            ),
                                            Text(
                                              results[index].endYear == null
                                                  ? results[index]
                                                      .startYear
                                                      .toString()
                                                  : '${results[index].startYear} - ${results[index].endYear}',
                                              style: context
                                                  .textStyles.caption1!
                                                  .copyWith(
                                                color: context
                                                    .colors.textsSecondary,
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
                                      MediaQuery.of(context).padding.bottom +
                                          130,
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
                chosenMovie != null && dragController.isAttached)
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: AnimatedBuilder(
                  animation: dragController,
                  builder: (context, child) {
                    return Transform.translate(offset: Offset(0,!dragController.isAttached ? 0 : dragController.size >=0.2 ? 0 : (0.2 - dragController.size) * MediaQuery.of(context).size.height), child: child!,);
                  },
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
                          child: DescriptionTextField(
                            focus: focusSec,
                            hint:
                                'Share your one-line review with your audience, it matters for them.',
                            showDivider: false,
                            button: 'Add poster',
                            buttonAddCheck: chosenCover != null,
                            buttonLoading:
                                ref.watch(createPosterLoadingStateHolderProvider),
                            maxSymbols: 280,
                            controller: descController,
                            onTap: () async {
                              try {
                                ref
                                    .read(createPosterLoadingStateHolderProvider
                                        .notifier)
                                    .updateValue(true);
                                final currPost =
                                    ref.read(posterStateHolderProvider);
                                final createId = ref.read(
                                    createPosterChoseMovieStateHolderProvider);
                                print("ABBB");
                                print("${currPost?.name} ${createId?.title}");
                                print(
                                    "${currPost?.year} ${'${createId?.startYear}${createId?.endYear == null ? '' : ' - ${createId?.endYear}'}'}");
                                if (currPost?.name == createId?.title &&
                                    currPost?.year ==
                                        '${createId?.startYear}${createId?.endYear == null ? '' : ' - ${createId?.endYear}'}') {
                                  ref
                                      .read(posterStateHolderProvider.notifier)
                                      .updateState(
                                        currPost!.copyWith(hasInCollection: true),
                                      );
                                }
                                await ref
                                    .read(createPosterControllerProvider)
                                    .createPoster(descController.text);
                              } catch (_) {
                                print(_);
                              }
                              ref
                                  .read(createPosterLoadingStateHolderProvider
                                      .notifier)
                                  .updateValue(false);
                              if (context.mounted) {
                                Navigator.pop(context);
                                ref.read(menuControllerProvider).switchMenu();
                              }
                            },
                          ),
                        ),
                      if (widget.bookmark)
                        Container(
                          color: context.colors.backgroundsPrimary,
                          child: Padding(
                            padding: EdgeInsets.only(
                              bottom: MediaQuery.of(context).padding.bottom,
                            ),
                            child: Container(
                              height: 36,
                              color: context.colors.backgroundsPrimary,
                              child: Row(
                                children: [
                                  const Spacer(),
                                  AppTextButton(
                                    text: "Add bookmark",
                                    disabled: chosenMovie == null,
                                    onTap: () async {
                                      try {
                                        ref
                                            .read(
                                                createPosterLoadingStateHolderProvider
                                                    .notifier)
                                            .updateValue(true);
                                        await ref
                                            .read(createPosterControllerProvider)
                                            .createBookmark();
                                      } catch (_) {
                                        print(_);
                                      }
                                      ref
                                          .read(
                                              createPosterLoadingStateHolderProvider
                                                  .notifier)
                                          .updateValue(false);
                                      if (context.mounted) {
                                        Navigator.pop(context);
                                        ref
                                            .read(menuControllerProvider)
                                            .switchMenu();
                                      }
                                    },
                                  ),
                                  const SizedBox(width: 16),
                                ],
                              ),
                            ),
                          ),
                        ),
                      Container(
                        height: MediaQuery.of(context).padding.bottom,
                        color: context.colors.backgroundsPrimary,
                      ),
                    ],
                  ),
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

  final MediaModel? chosenMovie;
  final List<String> images;
  final int index;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chosenPoster = ref.watch(createPosterChosenPosterStateHolderProvider);
    final shimmer = ShimmerLoader(
      child: Container(
        color: context.colors.backgroundsSecondary,
      ),
    );
    return Stack(
      children: [
        GestureDetector(
          onTap: () {
            if (chosenMovie == null || images.isEmpty) {
              return;
            }
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
                      errorBuilder: (context, obj, trace) {
                        return shimmer;
                      },
                      loadingBuilder: (context, child, event) {
                        if (event?.cumulativeBytesLoaded !=
                            event?.expectedTotalBytes) return shimmer;
                        return child;
                      },
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
                duration: const Duration(milliseconds: 150),
                decoration: BoxDecoration(
                  color: context.colors.backgroundsPrimary!
                      .withOpacity(chosenPoster?.$1 == index ? 1 : 0.4),
                  shape: BoxShape.circle,
                ),
                child: chosenPoster?.$1 == index
                    ? Center(
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 150),
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
