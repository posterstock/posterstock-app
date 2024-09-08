// ignore_for_file: use_build_context_synchronously

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easylogger/flutter_logger.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:poster_stock/common/helpers/custom_ink_well.dart';
import 'package:poster_stock/common/services/text_info_service.dart';
import 'package:poster_stock/common/widgets/app_text_button.dart';
import 'package:poster_stock/common/widgets/app_text_field.dart';
import 'package:poster_stock/common/widgets/description_textfield.dart';
import 'package:poster_stock/features/home/models/post_movie_model.dart';
import 'package:poster_stock/features/navigation_page/controller/menu_controller.dart';
import 'package:poster_stock/features/poster/state_holder/poster_state_holder.dart';
import 'package:poster_stock/features/poster_dialog/controller/create_poster_controller.dart';
import 'package:poster_stock/features/poster_dialog/model/media_model.dart';
import 'package:poster_stock/features/poster_dialog/state_holder/create_poster_chosen_movie_state_holder.dart';
import 'package:poster_stock/features/poster_dialog/state_holder/create_poster_chosen_poster_state_holder.dart';
import 'package:poster_stock/features/poster_dialog/state_holder/create_poster_images_state_holder.dart';
import 'package:poster_stock/features/poster_dialog/state_holder/create_poster_loading_state_holder.dart';
import 'package:poster_stock/features/poster_dialog/state_holder/create_poster_search_list.dart';
import 'package:poster_stock/features/poster_dialog/state_holder/create_poster_search_state_holder.dart';
import 'package:poster_stock/features/poster_dialog/view/widgets/poster_radio.dart';
import 'package:poster_stock/themes/build_context_extension.dart';

class PosterDialog extends ConsumerStatefulWidget {
  const PosterDialog({Key? key, this.bookmark = false, this.postMovieModel})
      : super(key: key);
  final bool bookmark;
  final PostMovieModel? postMovieModel;

  @override
  ConsumerState<PosterDialog> createState() => _CreatePosterDialogState();
}

class _CreatePosterDialogState extends ConsumerState<PosterDialog>
    with SingleTickerProviderStateMixin {
  final searchController = TextEditingController();
  final descController = TextEditingController();
  final focus = FocusNode();
  final focusSec = FocusNode();
  bool disposed = false;
  bool popping = false;

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
      builder: (context) => TapRegion(
        groupId: 'CreatePosterDialog Region',
        behavior: HitTestBehavior.opaque,
        child: Padding(
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
                                ref.read(menuControllerProvider).hideMenu();
                                Navigator.pop(context);
                                Navigator.pop(context, false);
                              },
                              child: Center(
                                child: Text(
                                  context.txt.discard,
                                  style:
                                      context.textStyles.bodyRegular!.copyWith(
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
      ),
    );
    return exit ?? false;
  }

  Widget _searchEmpty() => Expanded(
        child: IgnorePointer(
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
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
                  style: context.textStyles.subheadlineBold!.copyWith(
                    color: context.colors.textsDisabled!,
                  ),
                )
              ],
            ),
          ),
        ),
      );

  Widget _textField(MediaModel? chosenMovie) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: SizedBox(
          height: 36,
          child: AppTextField(
            controller: searchController,
            searchField: true,
            disableOutline: true,
            focus: focus,
            hint: context.txt.search_hint,
            removableWhenNotEmpty: true,
            crossPadding: const EdgeInsets.all(8.0),
            crossButton: SvgPicture.asset(
              'assets/icons/search_cross.svg',
            ),
            alternativeCancel: true,
            onRemoved: () {
              searchController.clear();
              ref.read(createPosterControllerProvider).updateSearch('');
              ref.read(createPosterControllerProvider).choosePoster(null);
              ref.read(createPosterControllerProvider).chooseMovie(null);
              ref
                  .read(createPosterControllerProvider)
                  .createPosterChosenPosterStateHolder
                  .updateValue(null);
            },
            onChanged: (value) {
              if (chosenMovie != null) {
                ref.read(createPosterControllerProvider).chooseMovie(null);
              }
              ref.read(createPosterControllerProvider).updateSearch(value);
            },
          ),
        ),
      );

  Widget _imagesList(List<String> images, MediaModel? chosenMovie) => SizedBox(
        height: 160,
        child: ListView.separated(
          itemCount: chosenMovie == null ? 20 : images.length,
          itemBuilder: (context, index) => Padding(
            padding: EdgeInsets.only(
                left: index == 0 ? 16.0 : 0.0,
                right: index == ((chosenMovie == null ? 20 : images.length) - 1)
                    ? 16.0
                    : 0.0),
            child: PosterRadio(
              chosenMovie: chosenMovie,
              images: images,
              index: index,
            ),
          ),
          separatorBuilder: (context, index) => const SizedBox(
            width: 8,
          ),
          scrollDirection: Axis.horizontal,
        ),
      );

  Widget _moviesList(List<MediaModel> results) => Expanded(
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: results.length,
          itemBuilder: (context, index) => Material(
            color: context.colors.backgroundsPrimary,
            child: InkWell(
              onTap: () {
                ref.read(createPosterControllerProvider).chooseMovie(
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
                                context.textStyles.bodyRegular!,
                              ).width >
                              (MediaQuery.of(context).size.width -
                                  54 -
                                  TextInfoService.textSize(
                                          results[index].endYear == null
                                              ? results[index]
                                                  .startYear
                                                  .toString()
                                              : '${results[index].startYear} - ${results[index].endYear}',
                                          context.textStyles.caption1!)
                                      .width)
                          ? (MediaQuery.of(context).size.width -
                              54 -
                              TextInfoService.textSize(
                                      results[index].endYear == null
                                          ? results[index].startYear.toString()
                                          : '${results[index].startYear} - ${results[index].endYear}',
                                      context.textStyles.caption1!)
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
                          ? results[index].startYear.toString()
                          : '${results[index].startYear} - ${results[index].endYear}',
                      style: context.textStyles.caption1!.copyWith(
                        color: context.colors.textsSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );

  Widget _descriptionTextField((int, String)? chosenCover) =>
      DescriptionTextField(
        focus: focusSec,
        hint: context.txt.search_add_poster_hint,
        showDivider: true,
        button: widget.postMovieModel != null
            ? context.txt.poster_dialog_save
            : context.txt.poster_dialog_add_button,
        buttonAddCheck: !(chosenCover == null),
        disableWithoutText: widget.postMovieModel != null ? false : true,
        buttonLoading: ref.watch(createPosterLoadingStateHolderProvider),
        maxSymbols: 280,
        controller: descController,
        onTap: () async {
          try {
            ref
                .read(createPosterLoadingStateHolderProvider.notifier)
                .updateValue(true);
            final currPost = ref.read(posterStateHolderProvider);
            final createId =
                ref.read(createPosterChoseMovieStateHolderProvider);
            if (currPost?.name == createId?.title &&
                currPost?.year ==
                    '${createId?.startYear}${createId?.endYear == null ? '' : ' - ${createId?.endYear}'}') {
              ref.read(posterStateHolderProvider.notifier).updateState(
                    currPost!.copyWith(hasInCollection: true),
                  );
            }
            if (widget.postMovieModel == null) {
              await ref
                  .read(createPosterControllerProvider)
                  .createPoster(descController.text, context);
            } else {
              await ref.read(createPosterControllerProvider).editPoster(
                  widget.postMovieModel!.id,
                  widget.postMovieModel!.imagePath,
                  descController.text,
                  context);
            }
          } catch (_) {
            Logger.e('Ошибка при создании постера $_');
          }
          ref
              .read(createPosterLoadingStateHolderProvider.notifier)
              .updateValue(false);
          ref.read(menuControllerProvider).hideMenu();
          if (context.mounted) {
            Navigator.pop(context, true);
            final selectedImage =
                ref.read(createPosterChosenPosterStateHolderProvider);
            PostMovieModel? updatedState = ref.read(posterStateHolderProvider);
            if (selectedImage != null) {
              updatedState =
                  updatedState?.copyWith(imagePath: selectedImage.$2);
            }
            ref
                .read(createPosterControllerProvider)
                .createPosterChosenPosterStateHolder
                .updateValue(null);

            ref
                .read(posterStateHolderProvider.notifier)
                .updateState(updatedState);
          }
        },
      );

  Widget _addButton((int, String)? chosenCover) => Container(
        height: 36,
        color: context.colors.backgroundsPrimary,
        child: Row(
          children: [
            const Spacer(),
            SizedBox(
              width: TextInfoService.textSize(
                    context.txt.watchlistAdd_bookmark,
                    context.textStyles.calloutBold!.copyWith(
                      color: context.colors.textsBackground,
                    ),
                  ).width +
                  32,
              child: AppTextButton(
                disabled: chosenCover == null,
                child: ref.watch(createPosterLoadingStateHolderProvider)
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
                        context.txt.watchlistAdd_bookmark,
                        style: context.textStyles.calloutBold!.copyWith(
                          color: context.colors.textsBackground,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                onTap: () async {
                  try {
                    ref
                        .read(createPosterLoadingStateHolderProvider.notifier)
                        .updateValue(true);
                    await ref
                        .read(createPosterControllerProvider)
                        .createBookmark(context);
                  } catch (_) {
                    Logger.e('Ошибка при создании закладки $_');
                  }
                  ref
                      .read(createPosterLoadingStateHolderProvider.notifier)
                      .updateValue(false);
                  if (context.mounted) {
                    Navigator.pop(context, true);
                    ref.read(menuControllerProvider).hideMenu();
                  }
                },
              ),
            ),
            const SizedBox(width: 16),
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    final String searchText = ref.watch(createPosterSearchStateHolderNotifier);
    final List<MediaModel>? results =
        ref.watch(createPosterSearchListStateHolderProvider);
    final MediaModel? chosenMovie =
        ref.watch(createPosterChoseMovieStateHolderProvider);

    final List<String> images =
        ref.watch(createPosterImagesStateHolderProvider);
    final chosenCover = ref.watch(createPosterChosenPosterStateHolderProvider);
    if (chosenMovie != null && chosenMovie.title != searchController.text) {
      searchController.text = chosenMovie.title;
      searchController.selection = TextSelection(
        baseOffset: searchController.text.length,
        extentOffset: searchController.text.length,
      );
    }

    /// создаем список nft постеров

    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: TapRegion(
        groupId: 'CreatePosterDialog Region',
        onTapOutside: (event) => tryExit(),
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            if (chosenMovie != null) FocusScope.of(context).unfocus();
          },
          child: SafeArea(
            child: AnimatedSize(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              child: Column(
                mainAxisSize:
                    chosenMovie == null ? MainAxisSize.max : MainAxisSize.min,
                children: [
                  const SizedBox(height: 12.0),
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
                    widget.postMovieModel != null
                        ? context.txt.posterEdit_editPoster
                        : widget.bookmark
                            ? context.txt.poster_dialog_watchlistAdd_header
                            : context.txt.poster_dialog_add_header,
                    style: context.textStyles.bodyBold,
                  ),
                  SizedBox(height: widget.postMovieModel == null ? 24.0 : 12.0),
                  if (widget.postMovieModel != null) ...[
                    Text(
                      widget.postMovieModel!.name,
                      style: context.textStyles.headline,
                    ),
                    const Gap(4),
                    Text(
                      widget.postMovieModel!.year,
                      style: context.textStyles.callout
                          ?.copyWith(color: context.colors.textsSecondary),
                    ),
                  ],
                  if (widget.postMovieModel == null) _textField(chosenMovie),
                  if (searchText.isEmpty || chosenMovie != null) const Gap(16),
                  if (searchText.isEmpty && chosenMovie == null) _searchEmpty(),
                  if (chosenMovie != null) _imagesList(images, chosenMovie),
                  // if (nftPosters.isNotEmpty) ...[
                  //   const Gap(40),
                  //   Text('NFT >>>>>>>>>>>>>>>>',
                  //       style: context.textStyles.headline),
                  //   const Gap(13),
                  //   // for (var i = 0; i < nftPosters.length; i++)
                  //   //   NFTPosterWidget(nftPosters[i]),
                  // ],
                  if (searchText.isNotEmpty && results == null)
                    Expanded(
                      child: Center(
                        child: defaultTargetPlatform != TargetPlatform.android
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
                    _moviesList(results),
                  if (!focus.hasFocus && searchController.text.isEmpty ||
                      chosenMovie != null)
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        if (!widget.bookmark)
                          Container(
                            height: 10.0,
                            color: context.colors.backgroundsPrimary,
                          ),
                        if (!widget.bookmark && chosenMovie != null)
                          _descriptionTextField(chosenCover),
                        if (widget.bookmark)
                          const SizedBox(
                            height: 28.0,
                          ),
                        if (widget.bookmark && chosenMovie != null)
                          _addButton(chosenCover),
                        if (widget.bookmark &&
                            (focus.hasFocus || focus.hasFocus))
                          const Gap(8),
                      ],
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
