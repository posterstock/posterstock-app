// ignore_for_file: use_build_context_synchronously

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easylogger/flutter_logger.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:poster_stock/common/helpers/custom_ink_well.dart';
import 'package:poster_stock/common/services/text_info_service.dart';
import 'package:poster_stock/common/widgets/app_snack_bar.dart';
import 'package:poster_stock/features/poster/controller/post_controller.dart';
import 'package:poster_stock/features/poster/state_holder/my_lists_state_holder.dart';
import 'package:poster_stock/features/poster/state_holder/poster_state_holder.dart';
import 'package:poster_stock/main.dart';
import 'package:poster_stock/themes/build_context_extension.dart';

class AddToListDialog extends ConsumerWidget {
  AddToListDialog({
    Key? key,
  }) : super(key: key);

  final DraggableScrollableController _controller =
      DraggableScrollableController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lists = ref.watch(myListsStateHolderProvider);
    final post = ref.watch(posterStateHolderProvider);
    if (lists == null) {
      Future(() {
        try {
          ref.read(postControllerProvider).getMyLists();
        } catch (e) {
          Logger.e('Ошибка при получении списков $e');
        }
      });
    }

    return WillPopScope(
      onWillPop: () async {
        ref.watch(myListsStateHolderProvider.notifier).clear();
        return true;
      },
      child: GestureDetector(
        onTap: () {
          ref.watch(myListsStateHolderProvider.notifier).clear();
          Navigator.pop(context);
        },
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Padding(
            padding: const EdgeInsets.only(top: 50),
            child: Stack(
              children: [
                GestureDetector(
                  onTap: () {
                    ref.watch(myListsStateHolderProvider.notifier).clear();
                    Navigator.pop(context);
                  },
                  child: Container(
                    color: Colors.transparent,
                  ),
                ),
                LayoutBuilder(builder: (context, constraints) {
                  double contentHeight = calculateContentHeight(context, ref);
                  double initialChildSize =
                      contentHeight / constraints.maxHeight;
                  if (initialChildSize > 1) initialChildSize = 1;
                  if (initialChildSize < 0.25) initialChildSize = 0.25;
                  return DraggableScrollableSheet(
                    //shouldCloseOnMinExtent: true,
                    controller: _controller,
                    minChildSize: 0.25,
                    initialChildSize: initialChildSize,
                    maxChildSize: 1,
                    snap: true,
                    builder: (context, controller) => ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(16.0),
                        topLeft: Radius.circular(16.0),
                      ),
                      child: Scaffold(
                        backgroundColor: context.colors.backgroundsPrimary,
                        body: SafeArea(
                          child: NotificationListener<ScrollEndNotification>(
                            onNotification: (info) {
                              if (_controller.pixels != 0 &&
                                  _controller.pixels <= 5.0) {
                                ref
                                    .watch(myListsStateHolderProvider.notifier)
                                    .clear();
                                Navigator.pop(context);
                              }
                              return true;
                            },
                            child: SingleChildScrollView(
                              controller: controller,
                              physics: const ClampingScrollPhysics(),
                              child: Column(
                                children: [
                                  const SizedBox(
                                    height: 14,
                                    width: double.infinity,
                                  ),
                                  Container(
                                    height: 4,
                                    width: 36,
                                    color: context.colors.fieldsDefault,
                                  ),
                                  const SizedBox(height: 22),
                                  Text(
                                    context.txt.profile_addToList_title,
                                    style: context.textStyles.bodyBold,
                                  ),
                                  SizedBox(height: lists == null ? 100 : 10.5),
                                  if (lists == null)
                                    Padding(
                                      padding: const EdgeInsets.only(top: 80.0),
                                      child: Center(
                                        child: defaultTargetPlatform !=
                                                TargetPlatform.android
                                            ? CupertinoActivityIndicator(
                                                radius: 10.0,
                                                color: context
                                                    .colors.textsSecondary!,
                                              )
                                            : SizedBox(
                                                width: 16,
                                                height: 16,
                                                child:
                                                    CircularProgressIndicator(
                                                  color: context
                                                      .colors.textsSecondary!,
                                                  strokeWidth: 2,
                                                ),
                                              ),
                                      ),
                                    ),
                                  if (lists != null)
                                    ...List.generate(
                                      lists.length,
                                      (index) => CustomInkWell(
                                        child: Column(
                                          children: [
                                            Divider(
                                              height: 0.5,
                                              thickness: 0.5,
                                              color:
                                                  context.colors.fieldsDefault,
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 15.0),
                                              child: Row(
                                                children: [
                                                  const SizedBox(width: 19),
                                                  Expanded(
                                                    child: Text(
                                                      lists[index].title,
                                                      style: context.textStyles
                                                          .bodyRegular,
                                                    ),
                                                  ),
                                                  const SizedBox(width: 16),
                                                  Text(
                                                    '${lists[index].postersCount} ${context.txt.posters.toLowerCase()}',
                                                    style: context
                                                        .textStyles.footNote!
                                                        .copyWith(
                                                            color: context
                                                                .colors
                                                                .textsSecondary),
                                                  ),
                                                  const SizedBox(width: 16),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                        onTap: () async {
                                          var snack = scaffoldMessengerKey
                                              .currentState
                                              ?.showSnackBar(
                                            SnackBars.build(
                                              context,
                                              null,
                                              //TODO: localize
                                              'Adding poster to list...',
                                              duration:
                                                  const Duration(minutes: 2),
                                            ),
                                          );
                                          try {
                                            await ref
                                                .read(postControllerProvider)
                                                .addPosterToList(
                                                  lists[index].id,
                                                  post!.id,
                                                );
                                            await ref
                                                .watch(posterStateHolderProvider
                                                    .notifier)
                                                .updateState(
                                                  post.copyWith(
                                                    hasInCollection: true,
                                                  ),
                                                );
                                          } catch (e) {
                                            snack?.close();
                                            ref
                                                .watch(
                                                    myListsStateHolderProvider
                                                        .notifier)
                                                .clear();
                                            Navigator.pop(context);
                                            if (context.mounted) {
                                              scaffoldMessengerKey.currentState
                                                  ?.showSnackBar(
                                                SnackBars.build(
                                                  context,
                                                  null,
                                                  //TODO: localize
                                                  'Could not update list',
                                                ),
                                              );
                                            }
                                          }
                                          snack?.close();
                                          ref
                                              .watch(myListsStateHolderProvider
                                                  .notifier)
                                              .clear();
                                          Navigator.pop(context);
                                        },
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
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }

  double calculateContentHeight(BuildContext context, WidgetRef ref) {
    final lists = ref.watch(myListsStateHolderProvider);
    if (lists == null || lists.isEmpty) {
      return 0; // Возвращаем 0, если нет данных для расчета
    }

    double size = 0;
    final textStyle = context.textStyles.bodyRegular!;
    final baseWidth = MediaQuery.of(context).size.width;
    const padding = 120; // Общий отступ слева и справа
    final maxWidth =
        baseWidth - padding; // Рассчитываем доступную ширину для текста

    for (var e in lists) {
      final textSpan = TextSpan(text: e.title, style: textStyle);
      final textPainter = TextPainter(
        text: textSpan,
        textDirection: TextDirection.ltr,
        maxLines: null, // Убираем ограничение на количество строк
        ellipsis: null, // Убираем многоточие, чтобы текст полностью отображался
      );
      textPainter.layout(maxWidth: maxWidth);
      double textHeight = textPainter.size.height;
      size += textHeight + 55; // Добавляем высоту текста и отступ
    }
    return size;
  }
}
