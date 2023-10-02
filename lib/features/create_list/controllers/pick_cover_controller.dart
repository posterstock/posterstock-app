import 'dart:io';

import 'package:davinci/core/davinci_capture.dart';
import 'package:image/image.dart' as img;
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:poster_stock/common/widgets/app_snack_bar.dart';
import 'package:poster_stock/features/create_list/repository/create_list_repository.dart';
import 'package:poster_stock/features/create_list/state_holders/chosen_cover_state_holder.dart';
import 'package:poster_stock/features/create_list/state_holders/create_list_chosen_poster_state_holder.dart';
import 'package:poster_stock/features/create_list/state_holders/gallery_index_state_holder.dart';
import 'package:poster_stock/features/create_list/state_holders/list_search_posters_state_holder.dart';
import 'package:poster_stock/features/create_list/state_holders/pick_cover_gallery_state_holder.dart';
import 'package:poster_stock/features/home/models/post_movie_model.dart';
import 'package:poster_stock/features/list/state_holder/list_state_holder.dart';
import 'package:poster_stock/features/profile/controllers/profile_controller.dart';
import 'package:poster_stock/features/profile/state_holders/my_profile_info_state_holder.dart';
import 'package:poster_stock/features/profile/state_holders/profile_posts_state_holder.dart';
import 'package:poster_stock/main.dart';
import 'package:poster_stock/themes/build_context_extension.dart';

final pickCoverControllerProvider = Provider<PickCoverController>(
  (ref) => PickCoverController(
    allImagesStateHolder:
        ref.watch(pickCoverGalleryStateHolderProvider.notifier),
    chosenCoverStateHolder: ref.watch(chosenCoverStateHolderProvider.notifier),
    galleryIndexStateHolder:
        ref.watch(galleryIndexStateHolderProvider.notifier),
    createListChosenPosterState:
        ref.watch(createListChosenPosterStateHolderProvider),
    createListChosenPosterStateHolder: ref.watch(
      createListChosenPosterStateHolderProvider.notifier,
    ),
    profileControllerApi: ref.watch(profileControllerApiProvider),
    searchPostsStateHolder:
        ref.watch(listSearchPostsStateHolderProvider.notifier),
    myProfileInfoStateHolder: ref.watch(myProfileInfoStateHolderProvider.notifier),
  ),
);

class PickCoverController {
  final PickCoverGalleryStateHolder allImagesStateHolder;
  final ListSearchPostsStateHolder searchPostsStateHolder;
  final ChosenCoverStateHolder chosenCoverStateHolder;
  final GalleryIndexStateHolder galleryIndexStateHolder;
  final List<(int, String)> createListChosenPosterState;
  final CreateListChosenPosterStateHolder createListChosenPosterStateHolder;
  final ProfileControllerApi profileControllerApi;
  final MyProfileInfoStateHolder myProfileInfoStateHolder;
  final repository = CreateListRepository();
  bool gotAllPosts = false;
  String? searchValue = null;
  List<int> loadingPages = [];
  int page = 0;
  int? max;
  List<String> paths = [];
  bool loading = false;
  bool loadedAll = false;

  PickCoverController({
    required this.allImagesStateHolder,
    required this.chosenCoverStateHolder,
    required this.galleryIndexStateHolder,
    required this.createListChosenPosterState,
    required this.createListChosenPosterStateHolder,
    required this.profileControllerApi,
    required this.searchPostsStateHolder,
    required this.myProfileInfoStateHolder,
  });

  void clearAll() {
    chosenCoverStateHolder.clear();
    createListChosenPosterStateHolder.clear();
  }

  Future<void> createList({
    required String title,
    required String description,
    required BuildContext context,
  }) async {
    try {
      bool generated = chosenCoverStateHolder.state == null;
      Uint8List? image = await showScreenshot(context);
      bool? value = await repository.createList(
        title: title,
        description: description,
        posters: createListChosenPosterState.map((e) => e.$1).toList(),
        image: image,
        generated: generated,
      );
      profileControllerApi.getUserInfo(null);
      if (value == false) {
        scaffoldMessengerKey.currentState?.showSnackBar(
          SnackBars.build(
            context,
            null,
            'List not created',
          ),
        );
      }
    } catch (e) {
      scaffoldMessengerKey.currentState?.showSnackBar(
        SnackBars.build(
          context,
          null,
          'Loading cover error. Default cover will be used.',
        ),
      );
    }
    clearAll();
  }

  Future<void> setImage(String image) async {
    chosenCoverStateHolder.setImage(image);
  }

  Future<void> removeImage() async {
    chosenCoverStateHolder.setImage(null);
  }

  Future<Uint8List?> showScreenshot(BuildContext context) async {
    if (chosenCoverStateHolder.state != null) {
      return File(chosenCoverStateHolder.state!).readAsBytesSync();
    }
    int width = MediaQuery.of(context).size.width.toInt();
    Widget widget;
    List<String> images = createListChosenPosterState.map((e) => e.$2).toList();
    List<Uint8List> data = [];
    for (int i = 0; i < (images.length > 7 ? 7 : images.length); i++) {
      try {
        var wid = await Dio().get(
          images[i],
          options: Options(
            responseType: ResponseType.bytes,
          ),
        );
        await precacheImage(MemoryImage(wid.data as Uint8List), context);
        data.add(wid.data as Uint8List);
      } catch (e) {
        scaffoldMessengerKey.currentState?.showSnackBar(
          SnackBars.build(
            context,
            null,
            'Loading cover error. Default cover will be used.',
          ),
        );
        return null;
      }
    }

    widget = SizedBox(
      width: width.toDouble(),
      height: width / 195 * 120,
      child: Row(
        children: List.generate(
          data.length,
          (index) => Expanded(
            child: Image.memory(
              data[index],
              fit: BoxFit.fitHeight,
              height: width / 195 * 120,
              cacheHeight: 700,
              frameBuilder: ((context, child, frame, wasSynchronouslyLoaded) {
                return child;
              }),
            ),
          ),
        ),
      ),
    );
    if (context.mounted) {
      Uint8List im = await DavinciCapture.offStage(
        widget,
        context: context,
        saveToDevice: false,
        openFilePreview: false,
        returnImageUint8List: true,
        wait: const Duration(milliseconds: 500),
      );
      for (int i = 0; i < (images.length > 7 ? 7 : images.length); i++) {
        try {
          await MemoryImage(data[i]).evict();
        } catch (e) {
          rethrow;
        }
      }
      return im;
    } else {
      throw Exception();
    }
  }

  Future<void> loadPage() async {
    if (loading) return;
    var assets = await PhotoManager.getAssetListRange(
      start: page,
      end: page+30,
      type: RequestType.image,
    );
    page += 30;
    if (assets.isEmpty) return;
    allImagesStateHolder.addElements(assets);
    loadPage();
  }

  Future<void> updateSearch(String value) async {
    gotAllPosts = false;
    bool stop = false;
    if (searchValue != value) {
      loadedAll = false;
      searchPostsStateHolder.clearState();
    }
    searchValue = value;
    if (searchValue?.isEmpty != false) return;
    await Future.delayed(const Duration(milliseconds: 500), () {
      if (searchValue != value) {
        loadedAll = false;
        stop = true;
      }
    });
    if (loadedAll) return;
    if (stop) return;
    final list = await repository.searchPosts(value, myProfileInfoStateHolder.state!.id);
    loadedAll = list.$2;
    if (searchValue == value) {
      searchPostsStateHolder.updateState(list.$1);
    }
  }
}
