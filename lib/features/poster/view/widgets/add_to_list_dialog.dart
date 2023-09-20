import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:poster_stock/features/poster/state_holder/poster_state_holder.dart';
import 'package:poster_stock/themes/build_context_extension.dart';

class AddToListDialog extends ConsumerWidget {
  const AddToListDialog({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final postId = ref.watch(posterStateHolderProvider);
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
      },
      child: Padding(
        padding: const EdgeInsets.only(top: 50),
        child: DraggableScrollableSheet(
          shouldCloseOnMinExtent: true,
          snapSizes: const [0.5, 1],
          minChildSize: 0,
          initialChildSize: 0.5,
          maxChildSize: 1,
          snap: true,
          builder: (context, controller)=> ClipRRect(
            borderRadius: const BorderRadius.only(
              topRight: Radius.circular(16.0),
              topLeft: Radius.circular(16.0),
            ),
            child: Scaffold(
              backgroundColor: context.colors.backgroundsPrimary,
              body: SafeArea(
                child: SingleChildScrollView(
                  controller: controller,
                  physics: ClampingScrollPhysics(),
                  child: Column(
                    children: [
                      const SizedBox(height: 14),
                      Container(
                        height: 4,
                        width: 36,
                        color: context.colors.fieldsDefault,
                      ),
                      const SizedBox(height: 22),
                      Text(
                        'Add to list',
                        style: context.textStyles.bodyBold,
                      ),
                      const SizedBox(height: 10.5),
                      Divider(
                        height: 0.5,
                        thickness: 0.5,
                        color: context.colors.fieldsDefault,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}