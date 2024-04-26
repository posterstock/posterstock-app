import 'package:flutter/material.dart';
import 'package:poster_stock/features/home/view/helpers/custom_bounce_physic.dart';

class ImageDialog extends StatefulWidget {
  const ImageDialog({
    super.key,
    required this.image,
  });

  final Widget image;

  @override
  State<ImageDialog> createState() => _ImageDialogState();
}

class _ImageDialogState extends State<ImageDialog>
    with SingleTickerProviderStateMixin {
  ScrollController? controller;
  late final AnimationController animController;

  @override
  void initState() {
    animController = AnimationController(
      vsync: this,
      duration: Duration.zero,
    );
    animController.animateTo(1);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    controller ??= ScrollController();
    return AnimatedBuilder(
      animation: animController,
      builder: (context, child) {
        return Dialog(
          backgroundColor: Colors.black.withOpacity(animController.value),
          insetPadding: EdgeInsets.zero,
          child: child,
        );
      },
      child: Listener(
        behavior: HitTestBehavior.translucent,
        onPointerUp: (_) {
          if (controller!.offset.abs() >
              (MediaQuery.of(context).size.height * 0.3)) {
            Navigator.pop(context);
          }
        },
        child: NotificationListener<ScrollNotification>(
          onNotification: (notification) {
            if (notification is ScrollUpdateNotification) {
              animController.animateTo(
                1 -
                    (notification.metrics.pixels).abs() /
                        (MediaQuery.of(context).size.height * 0.3),
              );
            }
            return true;
          },
          child: Stack(
            children: [
              Center(
                child: AnimatedBuilder(
                  animation: animController,
                  builder: (context, child) {
                    return Transform.translate(
                      offset: Offset(
                          0, controller!.hasClients ? -controller!.offset : 0),
                      child: child,
                    );
                  },
                  child: Hero(
                    tag: 'image',
                    child: widget.image,
                  ),
                ),
              ),
              ListView(
                physics: const AlwaysScrollableScrollPhysics(
                  parent: CustomBouncePhysic(),
                ),
                controller: controller,
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 2,
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
