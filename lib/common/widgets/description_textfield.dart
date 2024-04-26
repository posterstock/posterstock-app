import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:poster_stock/common/services/text_info_service.dart';
import 'package:poster_stock/common/widgets/app_text_button.dart';
import 'package:poster_stock/themes/build_context_extension.dart';

class DescriptionTextField extends StatefulWidget {
  const DescriptionTextField(
      {super.key,
      this.hint,
      this.showDivider = true,
      this.button,
      this.maxSymbols = 140,
      this.buttonAddCheck = true,
      this.controller,
      this.buttonLoading = false,
      this.onTap,
      this.focus,
      this.disableWithoutText = false});

  final String? hint;
  final bool showDivider;
  final String? button;
  final int maxSymbols;
  final bool buttonAddCheck;
  final bool buttonLoading;
  final FocusNode? focus;
  final TextEditingController? controller;
  final void Function()? onTap;
  final bool disableWithoutText;

  @override
  State<DescriptionTextField> createState() => _DescriptionTextFieldState();
}

class _DescriptionTextFieldState extends State<DescriptionTextField> {
  TextEditingController? descriptionController;
  bool disable = false;

  @override
  Widget build(BuildContext context) {
    descriptionController ??= widget.controller ?? TextEditingController();
    return Column(
      children: [
        if (widget.showDivider)
          Divider(
            height: 0.5,
            thickness: 0.5,
            color: context.colors.fieldsDefault,
          ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: TextField(
            textCapitalization: TextCapitalization.sentences,
            focusNode: widget.focus,
            minLines: 2,
            maxLines: 5,
            controller: descriptionController,
            cursorWidth: 1,
            cursorColor: context.colors.textsAction,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: widget.hint ?? 'Description your list',
              hintStyle: context.textStyles.bodyRegular!.copyWith(
                color: context.colors.textsDisabled,
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 4.0),
            ),
            style: context.textStyles.callout!.copyWith(
              overflow: TextOverflow.visible,
              color: context.colors.textsPrimary,
            ),
            onChanged: (String text) => setState(() {
              if (text.isEmpty && widget.disableWithoutText) {
                disable = true;
              } else {
                disable = false;
              }
            }),
          ),
        ),
        Container(
          height: 56 + MediaQuery.of(context).padding.bottom,
          color: context.colors.backgroundsPrimary,
          child: Row(
            children: [
              const Spacer(),
              Text(
                '${descriptionController!.text.length}/${widget.maxSymbols}',
                style: context.textStyles.footNote!.copyWith(
                  color: descriptionController!.text.length > widget.maxSymbols
                      ? context.colors.textsError
                      : context.colors.textsDisabled,
                ),
              ),
              const SizedBox(width: 12),
              SizedBox(
                height: 32,
                width: TextInfoService.textSize(
                      widget.button ?? context.txt.listCreate_create,
                      context.textStyles.calloutBold!.copyWith(
                        color: context.colors.textsBackground,
                      ),
                    ).width +
                    32,
                child: AppTextButton(
                  disabled: (descriptionController!.text.length >
                          widget.maxSymbols) ||
                      !widget.buttonAddCheck ||
                      disable,
                  onTap: widget.onTap,
                  child: widget.buttonLoading
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
                          widget.button ?? context.txt.listCreate_create,
                          style: context.textStyles.calloutBold!.copyWith(
                            color: context.colors.textsBackground,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                ),
              ),
              const SizedBox(width: 16),
            ],
          ),
        ),
      ],
    );
  }
}
