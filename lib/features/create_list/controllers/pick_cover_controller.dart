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
import 'package:poster_stock/features/create_list/repository/create_list_repository.dart';
import 'package:poster_stock/features/create_list/state_holders/chosen_cover_state_holder.dart';
import 'package:poster_stock/features/create_list/state_holders/create_list_chosen_poster_state_holder.dart';
import 'package:poster_stock/features/create_list/state_holders/gallery_index_state_holder.dart';
import 'package:poster_stock/features/create_list/state_holders/pick_cover_gallery_state_holder.dart';
import 'package:poster_stock/features/home/models/post_movie_model.dart';
import 'package:poster_stock/features/profile/state_holders/profile_posts_state_holder.dart';
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
  ),
);

class PickCoverController {
  final PickCoverGalleryStateHolder allImagesStateHolder;
  final ChosenCoverStateHolder chosenCoverStateHolder;
  final GalleryIndexStateHolder galleryIndexStateHolder;
  final List<(int, String)> createListChosenPosterState;
  final CreateListChosenPosterStateHolder createListChosenPosterStateHolder;
  final repository = CreateListRepository();
  List<int> loadingPages = [];
  int? max;
  List<String> paths = [];
  bool loading = false;

  PickCoverController({
    required this.allImagesStateHolder,
    required this.chosenCoverStateHolder,
    required this.galleryIndexStateHolder,
    required this.createListChosenPosterState,
    required this.createListChosenPosterStateHolder,
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
      Uint8List? image = await showScreenshot(context);
      bool? value = await repository.createList(
        title: title,
        description: description,
        posters: createListChosenPosterState.map((e) => e.$1).toList(),
        image: image,
      );
      if (value == false) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.black.withOpacity(0.8),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0)),
            behavior: SnackBarBehavior.floating,
            margin: EdgeInsets.all(8.0),
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            content: Row(
              children: [
                SvgPicture.asset(
                  'assets/images/dark_logo.svg',
                  width: 36,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    'List not created',
                    style: context.textStyles.bodyRegular!.copyWith(
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.black.withOpacity(0.8),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.all(8.0),
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          content: Row(
            children: [
              SvgPicture.asset(
                'assets/images/dark_logo.svg',
                width: 36,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  'Loading cover error. Default cover will be used.',
                  style: context.textStyles.bodyRegular!.copyWith(
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
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
    int height = MediaQuery.of(context).size.height.toInt();
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
        print(e);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.black.withOpacity(0.8),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0)),
            behavior: SnackBarBehavior.floating,
            margin: EdgeInsets.all(8.0),
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            content: Row(
              children: [
                SvgPicture.asset(
                  'assets/images/dark_logo.svg',
                  width: 36,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    'Loading cover error. Default cover will be used.',
                    style: context.textStyles.bodyRegular!.copyWith(
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
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
      print(18);
      return im;
    } else {
      print("unmount");
      throw Exception();
    }
  }

  Future<void> loadPage(int page) async {
    if (loading) return;
    if (max != null && page > max!) return;
    if (loadingPages.contains(page)) return;
    loading = true;
    loadingPages.add(page);
    var manager = await PhotoManager.requestPermissionExtend();
    if (!manager.isAuth) {
      loading = false;
      return;
    }
    if (max == null) {
      max ??= await PhotoManager.getAssetCount(
        type: RequestType.image,
      );
      galleryIndexStateHolder.setPage(0);
    }
    galleryIndexStateHolder.setPage(page + 30);
    var assets = await PhotoManager.getAssetListRange(
      start: page,
      end: page + 30,
      type: RequestType.image,
    );
    print("BOBA${assets.length} ${max} $page");
    List<String> files = [];
    try {
      for (var future in assets) {
        var path = (await future.fileWithSubtype.timeout(
          Duration(seconds: 5),
        ))
            ?.path;
        if (path != null) {
          //if (paths.contains(file.path)) { continue;}
          //paths.add(file.path);
          files.add(path);
        }
      }
      allImagesStateHolder.addElements(
        files,
        page,
      );
    } catch (e) {
      loading = false;
      print("EEERRROOOR");
      print(e);
    }
    loading = false;
  }
}
