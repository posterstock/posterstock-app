import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:poster_stock/common/helpers/custom_ink_well.dart';
import 'package:poster_stock/common/services/text_info_service.dart';
import 'package:poster_stock/common/widgets/app_text_button.dart';
import 'package:poster_stock/common/widgets/app_text_field.dart';
import 'package:poster_stock/common/widgets/description_textfield.dart';
import 'package:poster_stock/features/create_list/view/create_list_dialog.dart';
import 'package:poster_stock/features/create_poster/controller/create_poster_controller.dart';
import 'package:poster_stock/features/create_poster/model/media_model.dart';
import 'package:poster_stock/features/create_poster/state_holder/create_poster_chosen_movie_state_holder.dart';
import 'package:poster_stock/features/create_poster/state_holder/create_poster_chosen_poster_state_holder.dart';
import 'package:poster_stock/features/create_poster/state_holder/create_poster_images_state_holder.dart';
import 'package:poster_stock/features/create_poster/state_holder/create_poster_loading_state_holder.dart';
import 'package:poster_stock/features/create_poster/state_holder/create_poster_search_list.dart';
import 'package:poster_stock/features/create_poster/state_holder/create_poster_search_state_holder.dart';
import 'package:poster_stock/features/create_poster/view/poster_radio.dart';
import 'package:poster_stock/features/home/models/post_movie_model.dart';
import 'package:poster_stock/features/navigation_page/controller/menu_controller.dart';
import 'package:poster_stock/features/poster/state_holder/poster_state_holder.dart';
import 'package:poster_stock/themes/build_context_extension.dart';

class CreatePosterDialog extends ConsumerStatefulWidget {
  const CreatePosterDialog(
      {Key? key, this.bookmark = false, this.postMovieModel})
      : super(key: key);
  final bool bookmark;
  final PostMovieModel? postMovieModel;

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
  void initState() {
    super.initState();
    Future(() {
      focus.requestFocus();
      if (widget.postMovieModel != null) {
        final years = widget.postMovieModel!.year.split('-');
        int? startYear = int.parse(years.first);
        int? endYear = years.length >= 2 ? int.tryParse(years.last) : null;

        ref.read(createPosterControllerProvider).chooseMovie(MediaModel(
            id: widget.postMovieModel!.mediaId!,
            title: widget.postMovieModel!.name,
            type: widget.postMovieModel!.mediaType == 'movie'
                ? MediaType.movie
                : MediaType.tv,
            startYear: startYear,
            endYear: endYear));
        if (widget.postMovieModel!.description != null) {
          descController.text = widget.postMovieModel!.description!;
        }
        ref
            .read(createPosterChosenPosterStateHolderProvider.notifier)
            .updateValue((-1, widget.postMovieModel!.imagePath));
      }
    });
  }

  @override
  void dispose() {
    disposed = true;
    super.dispose();
  }

  Future<bool> tryExit() async {
    if (searchController.text.isEmpty ||
        (widget.postMovieModel != null && descController.text.isEmpty)) {
      return true;
    }
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
                        context.txt.search_add_poster_discart,
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
                            onTap: () async {
                              // print(dragController.size);
                              // await dragController.animateTo(
                              //   0,
                              //   duration: Duration(
                              //       milliseconds:
                              //           dragController.size < 1 ? 1 : 300),
                              //   curve: Curves.linear,
                              // );
                              ref.read(menuControllerProvider).hideMenu();
                              Navigator.pop(context, true);
                            },
                            child: Center(
                              child: Text(
                                context.txt.discart,
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
                                context.txt.cancel,
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
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.linear)
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
    if ((focus.hasFocus || focusSec.hasFocus) && !disposed && !popping) {
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
    double constValue = 480.0;
    if (widget.bookmark) constValue = 430.0;
    if (widget.postMovieModel != null) constValue = 490.0;
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
        resizeToAvoidBottomInset: false,
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
                if (chosenMovie != null) FocusScope.of(context).unfocus();
              },
              child: DraggableScrollableSheet(
                controller: dragController,
                minChildSize: 0,
                initialChildSize: constValue /
                    (MediaQuery.of(context).size.height -
                        MediaQuery.of(context).padding.bottom),
                maxChildSize:
                    focus.hasFocus || focusSec.hasFocus || chosenMovie == null
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
                    child: CustomScrollView(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      controller: controller,
                      slivers: [
                        SliverPersistentHeader(
                          delegate: AppDialogHeaderDelegate(
                            extent: widget.postMovieModel != null
                                ? 160.0
                                : searchText.isNotEmpty && chosenMovie == null
                                    ? 125.0
                                    : 144.0,
                            content: Stack(
                              alignment: Alignment.center,
                              children: [
                                Column(
                                  children: [
                                    const SizedBox(height: 14.0),
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
                                      widget.postMovieModel != null
                                          ? context.txt.posterEdit_editPoster
                                          : widget.bookmark
                                              ? context.txt.home_add_watchlist
                                              : context.txt.home_add_poster,
                                      style: context.textStyles.bodyBold
                                          ?.copyWith(fontSize: 19.0),
                                    ),
                                    const SizedBox(height: 20.0),
                                    if (widget.postMovieModel != null)
                                      Text(
                                        widget.postMovieModel!.name,
                                        style: context.textStyles.title3,
                                      ),
                                    if (widget.postMovieModel != null)
                                      const SizedBox(height: 6.0),
                                    if (widget.postMovieModel != null)
                                      Text(
                                        widget.postMovieModel!.year,
                                        style: context.textStyles.bodyMedium
                                            ?.copyWith(
                                                color: context
                                                    .colors.textsSecondary),
                                      ),
                                    if (widget.postMovieModel == null)
                                      SizedBox(
                                        height: 36,
                                        child: AppTextField(
                                          controller: searchController,
                                          searchField: true,
                                          disableOutline: true,
                                          focus: focus,
                                          hint: context.txt.search_hint,
                                          removableWhenNotEmpty: true,
                                          crossPadding:
                                              const EdgeInsets.all(8.0),
                                          crossButton: SvgPicture.asset(
                                            'assets/icons/search_cross.svg',
                                          ),
                                          alternativeCancel: true,
                                          onRemoved: () {
                                            searchController.clear();
                                            ref
                                                .read(
                                                    createPosterControllerProvider)
                                                .updateSearch('');
                                            ref
                                                .read(
                                                    createPosterControllerProvider)
                                                .choosePoster(null);
                                            ref
                                                .read(
                                                    createPosterControllerProvider)
                                                .chooseMovie(null);
                                            ref
                                                .read(
                                                    createPosterControllerProvider)
                                                .createPosterChosenPosterStateHolder
                                                .updateValue(null);
                                            dragController
                                                .animateTo(
                                              1,
                                              duration: const Duration(
                                                  milliseconds: 100),
                                              curve: Curves.linear,
                                            )
                                                .then((value) {
                                              if (dragController.size != 1) {
                                                dragController.animateTo(
                                                  1,
                                                  duration: const Duration(
                                                      milliseconds: 100),
                                                  curve: Curves.linear,
                                                );
                                              }
                                            });
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
                                      ),
                                    if (searchText.isEmpty ||
                                        chosenMovie != null)
                                      const SizedBox(height: 16),
                                  ],
                                ),
                                // Positioned(
                                //   right: 0,
                                //   top: 70,
                                //   bottom:
                                //       searchController.text.isEmpty ? 30 : 0,
                                //   child: GestureDetector(
                                //     behavior: HitTestBehavior.opaque,
                                //     onTap: () {
                                //       searchController.clear();
                                //       ref
                                //           .read(createPosterControllerProvider)
                                //           .updateSearch('');
                                //     },
                                //     child: Container(
                                //       color: Colors.transparent,
                                //       width: 60,
                                //     ),
                                //   ),
                                // ),
                              ],
                            ),
                          ),
                          pinned: true,
                        ),
                        if (searchText.isEmpty && chosenMovie == null)
                          SliverToBoxAdapter(
                            child: IgnorePointer(
                              child: AnimatedBuilder(
                                animation: dragController,
                                builder: (context, child) {
                                  return Transform.translate(
                                    offset: Offset(
                                      0,
                                      !dragController.isAttached
                                          ? 0
                                          : (MediaQuery.of(context)
                                                      .size
                                                      .height -
                                                  370 -
                                                  MediaQuery.of(context)
                                                      .padding
                                                      .top -
                                                  MediaQuery.of(context)
                                                      .viewInsets
                                                      .bottom) /
                                              2,
                                    ),
                                    child: child,
                                  );
                                },
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SvgPicture.asset(
                                        widget.bookmark
                                            ? 'assets/icons/ic_bookmark_second.svg'
                                            : 'assets/icons/ic_collection_second.svg',
                                        width: 48,
                                        colorFilter: ColorFilter.mode(
                                          context.colors.textsDisabled!,
                                          BlendMode.srcIn,
                                        ),
                                      ),
                                      const SizedBox(height: 5),
                                      Text(
                                        context.txt.search_add_watched_hint,
                                        style: context
                                            .textStyles.subheadlineBold!
                                            .copyWith(
                                          color: context.colors.textsDisabled!,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        if (chosenMovie != null)
                          SliverToBoxAdapter(
                            child: SizedBox(
                              height: 160,
                              child: ListView.separated(
                                itemCount:
                                    chosenMovie == null ? 20 : images.length,
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
                                  child: PosterRadio(
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
                                        color: context.colors.iconsDisabled!,
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
                                      .read(createPosterControllerProvider)
                                      .chooseMovie(
                                        (results[index]),
                                      );
                                  focus.unfocus();
                                  setState(() {});
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
                                                  context
                                                      .textStyles.bodyRegular!,
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
                                                            context.textStyles
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
                                                context.textStyles.bodyRegular!,
                                              ).width,
                                        child: Text(
                                          results[index].title,
                                          style: context.textStyles.bodyRegular,
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
                                        style: context.textStyles.caption1!
                                            .copyWith(
                                          color: context.colors.textsSecondary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        if (!focus.hasFocus && searchController.text.isEmpty ||
                            chosenMovie != null &&
                                (dragController.isAttached ||
                                    widget.postMovieModel != null))
                          SliverToBoxAdapter(
                            child: AnimatedBuilder(
                              animation: dragController,
                              builder: (context, child) {
                                return Transform.translate(
                                  offset: Offset(
                                      0,
                                      !dragController.isAttached
                                          ? 0
                                          : dragController.size >= 0.2
                                              ? 0
                                              : (0.2 - dragController.size) *
                                                  MediaQuery.of(context)
                                                      .size
                                                      .height),
                                  child: child!,
                                );
                              },
                              child: Column(
                                children: <Widget>[
                                  // Divider(
                                  //   height: 1,
                                  //   thickness: 1,
                                  //   color: context.colors.fieldsDefault,
                                  // ),
                                  if (!widget.bookmark)
                                    Container(
                                      height: 16.0,
                                      color: context.colors.backgroundsPrimary,
                                    ),
                                  if (!widget.bookmark && chosenMovie != null)
                                    Container(
                                      color: context.colors.backgroundsPrimary,
                                      child: DescriptionTextField(
                                        focus: focusSec,
                                        hint:
                                            context.txt.search_add_poster_hint,
                                        showDivider: true,
                                        button: widget.postMovieModel != null
                                            ? context.txt.save
                                            : context.txt.add,
                                        buttonAddCheck: !(chosenCover == null),
                                        disableWithoutText:
                                            widget.postMovieModel != null
                                                ? false
                                                : true,
                                        buttonLoading: ref.watch(
                                            createPosterLoadingStateHolderProvider),
                                        maxSymbols: 280,
                                        controller: descController,
                                        onTap: () async {
                                          try {
                                            ref
                                                .read(
                                                    createPosterLoadingStateHolderProvider
                                                        .notifier)
                                                .updateValue(true);
                                            // if (widget.mediaModel == null) {
                                            final currPost = ref.read(
                                                posterStateHolderProvider);
                                            final createId = ref.read(
                                                createPosterChoseMovieStateHolderProvider);
                                            if (currPost?.name ==
                                                    createId?.title &&
                                                currPost?.year ==
                                                    '${createId?.startYear}${createId?.endYear == null ? '' : ' - ${createId?.endYear}'}') {
                                              ref
                                                  .read(
                                                      posterStateHolderProvider
                                                          .notifier)
                                                  .updateState(
                                                    currPost!.copyWith(
                                                        hasInCollection: true),
                                                  );
                                            }
                                            if (widget.postMovieModel == null) {
                                              await ref
                                                  .read(
                                                      createPosterControllerProvider)
                                                  .createPoster(
                                                      descController.text);
                                            } else {
                                              await ref
                                                  .read(
                                                      createPosterControllerProvider)
                                                  .editPoster(
                                                      widget.postMovieModel!.id,
                                                      widget.postMovieModel!
                                                          .imagePath,
                                                      descController.text);
                                            }
                                          } catch (_) {
                                            print(_);
                                          }
                                          ref
                                              .read(
                                                  createPosterLoadingStateHolderProvider
                                                      .notifier)
                                              .updateValue(false);
                                          ref
                                              .read(menuControllerProvider)
                                              .hideMenu();
                                          if (context.mounted) {
                                            Navigator.pop(context);

                                            final selectedImage = ref
                                                .read(
                                                    createPosterControllerProvider)
                                                .createPosterChosenPosterStateHolder
                                                .state;
                                            PostMovieModel? updatedState = ref
                                                .read(posterStateHolderProvider
                                                    .notifier)
                                                .state
                                                ?.copyWith(
                                                    description:
                                                        descController.text);
                                            if (selectedImage != null) {
                                              updatedState =
                                                  updatedState?.copyWith(
                                                      imagePath:
                                                          selectedImage.$2);
                                            }
                                            ref
                                                .read(
                                                    createPosterControllerProvider)
                                                .createPosterChosenPosterStateHolder
                                                .updateValue(null);

                                            ref
                                                .read(posterStateHolderProvider
                                                    .notifier)
                                                .updateState(updatedState);
                                          }
                                        },
                                      ),
                                    ),
                                  if (widget.bookmark)
                                    const SizedBox(
                                      height: 28.0,
                                    ),
                                  if (widget.bookmark && chosenMovie != null)
                                    Container(
                                      color: context.colors.backgroundsPrimary,
                                      child: Padding(
                                        padding: EdgeInsets.only(
                                          bottom: MediaQuery.of(context)
                                              .padding
                                              .bottom,
                                        ),
                                        child: Container(
                                          height: 36,
                                          color:
                                              context.colors.backgroundsPrimary,
                                          child: Row(
                                            children: [
                                              const Spacer(),
                                              SizedBox(
                                                width: TextInfoService.textSize(
                                                      context.txt
                                                          .watchlistAdd_bookmark,
                                                      context.textStyles
                                                          .calloutBold!
                                                          .copyWith(
                                                        color: context.colors
                                                            .textsBackground,
                                                      ),
                                                    ).width +
                                                    32,
                                                child: AppTextButton(
                                                  disabled: chosenCover == null,
                                                  child: ref.watch(
                                                          createPosterLoadingStateHolderProvider)
                                                      ? Center(
                                                          child: defaultTargetPlatform !=
                                                                  TargetPlatform
                                                                      .android
                                                              ? CupertinoActivityIndicator(
                                                                  radius: 10.0,
                                                                  color: context
                                                                      .colors
                                                                      .textsBackground!,
                                                                )
                                                              : SizedBox(
                                                                  width: 16,
                                                                  height: 16,
                                                                  child:
                                                                      CircularProgressIndicator(
                                                                    color: context
                                                                        .colors
                                                                        .textsBackground!,
                                                                    strokeWidth:
                                                                        2,
                                                                  ),
                                                                ),
                                                        )
                                                      : Text(
                                                          context.txt
                                                              .watchlistAdd_bookmark,
                                                          style: context
                                                              .textStyles
                                                              .calloutBold!
                                                              .copyWith(
                                                            color: context
                                                                .colors
                                                                .textsBackground,
                                                          ),
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        ),
                                                  onTap: () async {
                                                    try {
                                                      ref
                                                          .read(
                                                              createPosterLoadingStateHolderProvider
                                                                  .notifier)
                                                          .updateValue(true);
                                                      await ref
                                                          .read(
                                                              createPosterControllerProvider)
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
                                                          .read(
                                                              menuControllerProvider)
                                                          .hideMenu();
                                                    }
                                                  },
                                                ),
                                              ),
                                              const SizedBox(width: 16),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  Container(
                                    height:
                                        MediaQuery.of(context).padding.bottom,
                                    color: context.colors.backgroundsPrimary,
                                  ),
                                ],
                              ),
                            ),
                          ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
