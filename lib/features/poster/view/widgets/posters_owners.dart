import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:poster_stock/features/NFT/models/nft_owners.dart';
import 'package:poster_stock/features/poster/view/widgets/owner_poster.dart';
import 'package:poster_stock/features/poster/view/widgets/owners_item.dart';
import 'package:poster_stock/themes/build_context_extension.dart';

class PostersOwnersModal extends StatefulWidget {
  final PosterOwner owner;
  const PostersOwnersModal({super.key, required this.owner});
  @override
  State<PostersOwnersModal> createState() => _PostersOwnersModalState();
}

class _PostersOwnersModalState extends State<PostersOwnersModal> {
  final dragController = DraggableScrollableController();
  bool disposed = false;
  bool popping = false;

  @override
  void dispose() {
    disposed = true;
    dragController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    dragController.addListener(() async {
      if (dragController.size < 0.1) {
        if (!disposed && !popping) {
          popping = true;
          if (Navigator.of(context).canPop()) Navigator.of(context).pop();
          disposed = true;
        }
      }
    });

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        Navigator.pop(context);
      },
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            Positioned.fill(
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(color: Colors.transparent),
              ),
            ),
            DraggableScrollableSheet(
              controller: dragController,
              minChildSize: 0,
              initialChildSize: widget.owner.nftOwners.isEmpty ? 0.3 : 0.5,
              maxChildSize: 0.9,
              shouldCloseOnMinExtent: false,
              snap: true,
              snapSizes: const [0.3, 0.5, 0.7, 0.9],
              builder: (context, controller) {
                return AnimatedBuilder(
                  // Добавляем AnimatedBuilder
                  animation: dragController,
                  builder: (context, child) {
                    return Transform.translate(
                      offset: Offset(
                          0,
                          !dragController.isAttached
                              ? 0
                              : dragController.size >= 0.3
                                  ? 0
                                  : (0.3 - dragController.size) *
                                      MediaQuery.of(context).size.height),
                      child: child!,
                    );
                  },
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(16.0),
                        topLeft: Radius.circular(16.0),
                      ),
                      color: context.colors.backgroundsPrimary,
                    ),
                    child: Column(
                      children: [
                        const Gap(14),
                        Container(
                          height: 4,
                          width: 36,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(2.0),
                            color: context.colors.fieldsDefault,
                          ),
                        ),
                        const Gap(22),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Column(
                              children: [
                                PosterOwnerWidget(
                                  posterOwner: widget.owner,
                                ),
                                const Gap(30),
                                if (widget.owner.nftOwners.isNotEmpty)
                                  ...widget.owner.nftOwners
                                      .map((item) => OwnersItem(owner: item))
                                      .toList(),
                                if (widget.owner.nftOwners.isEmpty)
                                  Expanded(
                                    child: Center(
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 40),
                                        child: Text(
                                          context.txt.poster_owners_empty,
                                          style: context.textStyles.subheadline!
                                              .copyWith(
                                            color: context.colors.iconsDisabled,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
