import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:poster_stock/common/services/text_info_service.dart';
import 'package:poster_stock/common/widgets/app_text_button.dart';
import 'package:poster_stock/features/home/controller/home_page_posts_controller.dart';
import 'package:poster_stock/features/poster/controller/post_controller.dart';
import 'package:poster_stock/themes/build_context_extension.dart';

class CommentTextField extends ConsumerStatefulWidget {
  const CommentTextField({
    super.key,
    required this.id,
    this.isList = false,
  });

  final int id;
  final bool isList;

  @override
  ConsumerState<CommentTextField> createState() => _CommentTextFieldState();
}

class _CommentTextFieldState extends ConsumerState<CommentTextField> {
  final FocusNode focus = FocusNode();
  final GlobalKey key = GlobalKey();
  final TextEditingController controller = TextEditingController();
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    focus.addListener(() {
      setState(() {});
    });
    return NotificationListener(
      onNotification: (not) {
        return true;
      },
      child: Column(
        children: [
          Divider(
            height: 0.5,
            thickness: 0.5,
            color: context.colors.fieldsDefault,
          ),
          Container(
            height:
                focus.hasFocus && MediaQuery.of(context).viewInsets.bottom != 0
                    ? null
                    : 56 + MediaQuery.of(context).padding.bottom,
            color: context.colors.backgroundsPrimary,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: TextField(
                key: key,
                maxLines: null,
                focusNode: focus,
                controller: controller,
                cursorWidth: 1,
                cursorColor: context.colors.textsAction,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText:
                      AppLocalizations.of(context)!.poster_reply_field_hint,
                  hintStyle: context.textStyles.callout!.copyWith(
                    color: context.colors.textsDisabled,
                  ),
                ),
                textCapitalization: TextCapitalization.sentences,
                onChanged: (value) {
                  setState(() {});
                },
              ),
            ),
          ),
          if (focus.hasFocus)
            KeyboardVisibilityBuilder(builder: (context, visible) {
              if (!visible) return const SizedBox();
              return Container(
                height: 56,
                color: context.colors.backgroundsPrimary,
                child: Row(
                  children: [
                    const Spacer(),
                    Text(
                      '${controller.text.length}/140',
                      style: context.textStyles.footNote!.copyWith(
                        color: controller.text.length > 140
                            ? context.colors.textsError
                            : context.colors.textsDisabled,
                      ),
                    ),
                    const SizedBox(width: 12),
                    SizedBox(
                      height: 32,
                      width: TextInfoService.textSize(
                                  AppLocalizations.of(context)!.poster_reply,
                                  context.textStyles.calloutBold!)
                              .width +
                          32,
                      child: AppTextButton(
                        text: AppLocalizations.of(context)!.poster_reply,
                        disabled: controller.text.isEmpty ||
                            controller.text.length > 140,
                        child: loading
                            ? Center(
                                child: defaultTargetPlatform !=
                                        TargetPlatform.android
                                    ? CupertinoActivityIndicator(
                                        radius: 10.0,
                                        color: context.colors.textsBackground!,
                                      )
                                    : SizedBox(
                                        width: 16,
                                        height: 16,
                                        child: CircularProgressIndicator(
                                          color:
                                              context.colors.textsBackground!,
                                          strokeWidth: 2,
                                        ),
                                      ),
                              )
                            : null,
                        onTap: () async {
                          loading = true;
                          setState(() {});
                          if (!widget.isList) {
                            await ref
                                .read(postControllerProvider)
                                .postComment(widget.id, controller.text);
                            await ref
                                .read(homePagePostsControllerProvider)
                                .addComment(widget.id);
                          } else {
                            await ref
                                .read(postControllerProvider)
                                .postCommentList(widget.id, controller.text);
                            await ref
                                .read(homePagePostsControllerProvider)
                                .addCommentList(widget.id);
                          }
                          loading = false;
                          setState(() {});
                          controller.clear();
                          focus.unfocus();
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                  ],
                ),
              );
            })
        ],
      ),
    );
  }
}
