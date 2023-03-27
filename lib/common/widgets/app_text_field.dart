import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:poster_stock/themes/build_context_extension.dart';

import '../../themes/constants.dart';

class AppTextField extends StatefulWidget {
  const AppTextField({
    Key? key,
    required this.hint,
    this.removable = false,
    this.removableWhenNotEmpty = true,
    this.onSubmitted,
    this.onChanged,
    this.controller,
    this.inputFormatters,
    this.hasError = false,
    this.onRemoved,
    this.tickOnSuccess = false,
    this.isUsername = false,
    this.keyboardType,
  }) : super(key: key);
  final String hint;
  final Function(String)? onSubmitted;
  final Function(String)? onChanged;
  final Function()? onRemoved;
  final TextEditingController? controller;
  final bool removable;
  final bool removableWhenNotEmpty;
  final bool tickOnSuccess;
  final List<TextInputFormatter>? inputFormatters;
  final bool hasError;
  final bool isUsername;
  final TextInputType? keyboardType;

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  final TextEditingController nullController = TextEditingController();
  final FocusNode focus = FocusNode();

  bool focused = false;

  @override
  void initState() {
    focus.addListener(() {
      setState(() {
        focused = focus.hasFocus;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final defaultBorder = OutlineInputBorder(
      borderSide: BorderSide(
        width: 1.5,
        color: widget.hasError
            ? context.colors.textsError!
            : context.colors.fieldsDefault!,
      ),
      borderRadius: BorderRadius.circular(
        Constants.borderRadiusField,
      ),
    );
    return SizedBox(
      height: Constants.fieldsAndButtonsHeight,
      child: Stack(
        children: [
          TextField(
            keyboardType: widget.keyboardType,
            focusNode: focus,
            cursorColor: context.colors.textsPrimary!,
            inputFormatters: widget.inputFormatters,
            style: context.textStyles.callout!
                .copyWith(color: context.colors.textsPrimary!),
            onSubmitted: widget.onSubmitted,
            controller: widget.controller ?? nullController,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(horizontal: 18),
              isDense: true,
              prefix: Text(
                widget.isUsername ? '@' : '',
                style: context.textStyles.callout!.copyWith(
                  color: Colors.transparent,
                ),
              ),
              suffixIcon: (widget.tickOnSuccess &&
                      (widget.controller ?? nullController).text.length > 1 &&
                      !widget.hasError
                  ? Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: SvgPicture.asset(
                        'assets/icons/ic_check.svg',
                        colorFilter: ColorFilter.mode(
                          context.colors.iconsActive!,
                          BlendMode.srcIn,
                        ),
                      ),
                    )
                  : widget.removable ||
                          (widget.removableWhenNotEmpty &&
                              (widget.controller ?? nullController)
                                  .text
                                  .isNotEmpty)
                      ? GestureDetector(
                          onTap: () {
                            widget.controller?.text = '';
                            nullController.text = '';
                            setState(() {});
                            if (widget.onRemoved != null) widget.onRemoved!();
                          },
                          child: Container(
                            color: Colors.transparent,
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: SvgPicture.asset(
                                'assets/icons/ic_close.svg',
                                colorFilter: ColorFilter.mode(
                                  widget.hasError
                                      ? context.colors.textsError!
                                      : context.colors.iconsDisabled!,
                                  BlendMode.srcIn,
                                ),
                              ),
                            ),
                          ),
                        )
                      : const Padding(
                          padding: EdgeInsets.all(16.0),
                          child: SizedBox(height: 24),
                        )),
              filled: true,
              fillColor: focused
                  ? context.colors.backgroundsPrimary
                  : context.colors.backgroundsSecondary,
              enabledBorder: defaultBorder,
              focusedBorder: defaultBorder,
              border: defaultBorder,
              hintText: widget.hint,
              hintStyle: context.textStyles.callout,
            ),
            onChanged: (value) {
              if (widget.onChanged != null) widget.onChanged!(value);
              setState(() {});
            },
            maxLines: 1,
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 18.0),
              child: Text(
                widget.isUsername ? '@' : '',
                style: context.textStyles.callout!.copyWith(
                  color: context.colors.textsDisabled,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
