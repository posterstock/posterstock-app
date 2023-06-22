import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:poster_stock/features/create_list/controllers/pick_cover_controller.dart';
import 'package:poster_stock/themes/build_context_extension.dart';

import '../state_holders/pick_cover_gallery_state_holder.dart';
import 'create_list_dialog.dart';

class PickCoverDialog extends ConsumerStatefulWidget {
  const PickCoverDialog({super.key, required this.onItemTap});
  final void Function(BuildContext, WidgetRef, Uint8List) onItemTap;

  @override
  ConsumerState<PickCoverDialog> createState() => _PickCoverDialogState();
}

class _PickCoverDialogState extends ConsumerState<PickCoverDialog> {
  final dragController = DraggableScrollableController();
  bool disposed = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    disposed = true;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    dragController.addListener(() {
      if (dragController.size < 0.1) {
        if (!disposed) {
          Navigator.pop(context);
        }
        disposed = true;
      }
    });
    return DraggableScrollableSheet(
      minChildSize: 0,
      initialChildSize: 0.7,
      maxChildSize: 1,
      controller: dragController,
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
          child: CustomScrollView(
            controller: controller,
            slivers: [
              SliverPersistentHeader(
                delegate: AppDialogHeaderDelegate(
                  extent: 100,
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
                        'Gallery',
                        style: context.textStyles.bodyBold,
                      ),
                      const SizedBox(height: 0.5),
                      Text(
                        'Upload a 380х212 resolution picture or larger',
                        style: context.textStyles.footNote!.copyWith(
                          color: context.colors.textsSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                pinned: true,
              ),
              SliverGrid(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    return Container(
                      color: context.colors.backgroundsSecondary,
                      child: GalleryCover(
                        index: index,
                        onTap: widget.onItemTap,
                      ),
                    );
                  },
                ),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 2,
                  mainAxisSpacing: 2,
                  mainAxisExtent: (MediaQuery.of(context).size.width - 4) / 3,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class GalleryCover extends ConsumerWidget {
  const GalleryCover({
    Key? key,
    required this.index,
    required this.onTap,
  }) : super(key: key);
  final int index;
  final void Function(BuildContext, WidgetRef, Uint8List) onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var images = ref.read(pickCoverGalleryStateHolderProvider);
    if (images.length > index) {
      var image = Image.memory(
        images[index],
        cacheWidth: 212,
        fit: BoxFit.cover,
      );
      return GestureDetector(
        onTap: () {
          onTap(context, ref, images[index]);
        },
        child: image,
      );
    }
    return FutureBuilder(
      future: getData(context, ref),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const SizedBox();
        return GestureDetector(
          child: snapshot.data!.$1,
          onTap: () {
            if (snapshot.data!.$2 == null) return;
            onTap(context, ref, snapshot.data!.$2!);
          },
        );
      },
    );
  }

  Future<(Image?, Uint8List?)?> getData(
      BuildContext context, WidgetRef ref) async {
    var res = await PhotoManager.requestPermissionExtend();
    if (!res.isAuth) {
      return null;
    }
    var path = (await PhotoManager.getAssetPathList(
      hasAll: true,
      onlyAll: true,
      type: RequestType.image,
    ))[0];
    var assets = await path.getAssetListRange(
      start: index,
      end: index + 1,
    );
    File? file = await assets[0].file;
    if (file == null) return null;
    var bytes = file.readAsBytesSync();
    ref.read(pickCoverGalleryStateHolderProvider.notifier).addElement(bytes);
    Image image = Image.memory(
      bytes,
      cacheWidth: 212,
      fit: BoxFit.cover,
    );
    if (!context.mounted) return (image, bytes);
    await precacheImage(image.image, context);
    return (image, bytes);
  }
}
