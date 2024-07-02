import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:poster_stock/features/create_list/controllers/pick_cover_controller.dart';
import 'package:poster_stock/themes/build_context_extension.dart';
import 'package:transparent_image/transparent_image.dart';

import '../state_holders/pick_cover_gallery_state_holder.dart';
import 'create_list_dialog.dart';

class PickCoverDialog extends ConsumerStatefulWidget {
  const PickCoverDialog({super.key, required this.onItemTap});

  final void Function(BuildContext, WidgetRef, String) onItemTap;

  @override
  ConsumerState<PickCoverDialog> createState() => _PickCoverDialogState();
}

class _PickCoverDialogState extends ConsumerState<PickCoverDialog> {
  final dragController = DraggableScrollableController();
  bool disposed = false;

  @override
  void initState() {
    super.initState();
    Future(() {
      ref.read(pickCoverControllerProvider).loadPage();
    });
  }

  @override
  void dispose() {
    disposed = true;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final images = ref.watch(pickCoverGalleryStateHolderProvider);
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
                  addAutomaticKeepAlives: false,
                  (context, index) {
                    return Container(
                      key: Key(index.toString()),
                      color: context.colors.backgroundsSecondary,
                      child: images.length <= index || images[index] == null
                          ? const SizedBox()
                          : FutureBuilder(
                              future: images[index]!.file,
                              builder: (context, snapshot) {
                                if (!snapshot.hasData) return const SizedBox();
                                return GalleryCover(
                                  key: Key("image${images[index]!.id}"),
                                  image: snapshot.data!.path,
                                  onTap: widget.onItemTap,
                                );
                              }),
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

class GalleryCover extends ConsumerStatefulWidget {
  GalleryCover({
    Key? key,
    required this.image,
    required this.onTap,
  })  : fileImage = Image.file(
          key: Key(image),
          File(image),
          cacheWidth: 200,
        ),
        super(key: key);
  final String image;
  final void Function(BuildContext, WidgetRef, String) onTap;
  final Image fileImage;

  @override
  ConsumerState<GalleryCover> createState() => _GalleryCoverState();
}

class _GalleryCoverState extends ConsumerState<GalleryCover> {
  @override
  void initState() {
    super.initState();
    Future(() {
      precacheImage(widget.fileImage.image, context);
    });
  }

  @override
  void dispose() {
    widget.fileImage.image.evict();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.onTap(context, ref, widget.image);
      },
      child: FadeInImage(
        key: Key(widget.image),
        fadeInDuration: const Duration(milliseconds: 300),
        placeholder: MemoryImage(kTransparentImage),
        placeholderFit: BoxFit.cover,
        image: widget.fileImage.image,
      ),
    );
  }
}
