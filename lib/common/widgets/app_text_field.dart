import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:poster_stock/features/poster_dialog/model/media_model.dart';
import 'package:poster_stock/features/poster_dialog/state_holder/create_poster_chosen_movie_state_holder.dart';
import 'package:poster_stock/themes/build_context_extension.dart';

import '../../themes/constants.dart';

class AppTextField extends StatefulWidget {
  const AppTextField(
      {Key? key,
      required this.hint,
      this.removable = false,
      this.removableWhenNotEmpty = true,
      this.onSubmitted,
      this.onChanged,
      this.controller,
      this.inputFormatters,
      this.hasError = false,
      this.onRemoved,
      this.onTap,
      this.tickOnSuccess = false,
      this.isUsername = false,
      this.keyboardType,
      this.crossButton,
      this.crossPadding,
      this.searchField = false,
      this.autofocus = false,
      this.focus,
      this.maxLines,
      this.minLines,
      this.style,
      this.textCapitalization,
      this.disableOutline = false,
      this.alternativeCancel = false})
      : super(key: key);
  final String hint;
  final Function(String)? onSubmitted;
  final Function(String)? onChanged;
  final Function()? onRemoved;
  final Function()? onTap;
  final TextEditingController? controller;
  final bool removable;
  final bool removableWhenNotEmpty;
  final bool tickOnSuccess;
  final List<TextInputFormatter>? inputFormatters;
  final bool hasError;
  final bool isUsername;
  final TextInputType? keyboardType;
  final Widget? crossButton;
  final EdgeInsets? crossPadding;
  final bool searchField;
  final bool? autofocus;
  final FocusNode? focus;
  final int? maxLines;
  final int? minLines;
  final TextStyle? style;
  final TextCapitalization? textCapitalization;
  final bool disableOutline;
  final bool alternativeCancel;

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  final TextEditingController nullController = TextEditingController();
  late final FocusNode focus;

  bool focused = false;

  @override
  void initState() {
    focus = widget.focus ?? FocusNode();
    focus.addListener(() {
      if (mounted) {
        setState(() {
          focused = focus.hasFocus;
        });
      }
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
            : widget.disableOutline && !focused
                ? context.colors.backgroundsSecondary!
                : context.colors.fieldsDefault!,
      ),
      borderRadius: BorderRadius.circular(
        Constants.borderRadiusField,
      ),
    );
    return Row(
      children: [
        Expanded(
          child: SizedBox(
            height: Constants.fieldsAndButtonsHeight,
            child: Stack(
              children: [
                Stack(
                  children: [
                    TextField(
                      textCapitalization:
                          widget.textCapitalization ?? TextCapitalization.none,
                      autofocus: widget.autofocus!,
                      onTap: widget.onTap,
                      keyboardType: widget.keyboardType,
                      focusNode: widget.focus ?? focus,
                      cursorColor: context.colors.textsPrimary!,
                      inputFormatters: widget.inputFormatters,
                      style: (widget.style ?? context.textStyles.callout!)
                          .copyWith(color: context.colors.textsPrimary!),
                      onSubmitted: widget.onSubmitted,
                      controller: widget.controller ?? nullController,
                      decoration: InputDecoration(
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 18),
                        isDense: true,
                        prefix: Text(
                          widget.isUsername ? '@' : '',
                          style: (widget.style ?? context.textStyles.callout!)
                              .copyWith(
                            color: Colors.transparent,
                          ),
                        ),
                        prefixIcon: widget.searchField
                            ? Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(0, 10, 0, 10),
                                child: SvgPicture.asset(
                                  'assets/icons/ic_search.svg',
                                  width: 15,
                                  colorFilter: ColorFilter.mode(
                                    context.colors.iconsDisabled!,
                                    BlendMode.srcIn,
                                  ),
                                ),
                              )
                            : null,
                        suffixIcon: ((widget.crossButton == null ||
                                widget.controller?.text == '' ||
                                widget.controller?.text == null)
                            ? (widget.tickOnSuccess &&
                                    (widget.controller ?? nullController)
                                            .text
                                            .length >
                                        1 &&
                                    !widget.hasError
                                ? Padding(
                                    // key: const ValueKey<int>(3),
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
                                            (widget.controller ??
                                                    nullController)
                                                .text
                                                .isNotEmpty)
                                    ? GestureDetector(
                                        // key: const ValueKey<int>(0),
                                        onTap: () {
                                          widget.controller?.text = '';
                                          nullController.text = '';
                                          setState(() {});
                                          if (widget.onRemoved != null) {
                                            widget.onRemoved!();
                                          }
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
                                                    : context
                                                        .colors.iconsDisabled!,
                                                BlendMode.srcIn,
                                              ),
                                            ),
                                          ),
                                        ),
                                      )
                                    : const Padding(
                                        // key: ValueKey<int>(2),
                                        padding: EdgeInsets.all(16.0),
                                        child: SizedBox(height: 24),
                                      ))
                            : widget.alternativeCancel && !focused
                                ? null
                                : GestureDetector(
                                    // key: const ValueKey<int>(1),
                                    onTap: () {
                                      if (widget.onRemoved != null) {
                                        nullController.text = '';
                                        widget.controller?.text = '';
                                        widget.onRemoved!();
                                        setState(() {});
                                      }
                                    },
                                    child: Padding(
                                      padding: widget.crossPadding ??
                                          EdgeInsets.zero,
                                      child: widget.crossButton,
                                    ),
                                  )),
                        filled: true,
                        fillColor: focused
                            ? context.colors.backgroundsPrimary
                            : context.colors.backgroundsSecondary,
                        enabledBorder: defaultBorder,
                        focusedBorder: defaultBorder,
                        border: defaultBorder,
                        hintText: widget.hint,
                        hintStyle: widget.style ?? context.textStyles.callout!,
                      ),
                      onChanged: (value) {
                        if (widget.isUsername && value == '@') {
                          (widget.controller ?? nullController).text = '';
                        }
                        if (widget.onChanged != null) {
                          widget.onChanged!(
                              (widget.controller ?? nullController).text);
                        }
                        setState(() {});
                      },
                      maxLines: widget.maxLines ?? 1,
                      minLines: widget.minLines,
                    ),
                    Consumer(builder: (context, ref, widget) {
                      final MediaModel? chosenMovie =
                          ref.watch(createPosterChoseMovieStateHolderProvider);
                      if (chosenMovie?.startYear != null) {
                        return Positioned(
                          left: 48.0,
                          bottom: 6.0,
                          child: IgnorePointer(
                            ignoring: true,
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Row(
                                children: [
                                  Text(
                                    chosenMovie!.title,
                                    style: context.textStyles.callout!.copyWith(
                                        color: Colors.transparent,
                                        overflow: TextOverflow.ellipsis),
                                  ),
                                  const SizedBox(
                                    width: 8.0,
                                  ),
                                  Text(
                                    chosenMovie.startYear.toString(),
                                    style: context.textStyles.caption1!
                                        .copyWith(
                                            color:
                                                context.colors.textsSecondary,
                                            overflow: TextOverflow.ellipsis),
                                  ),
                                  if (chosenMovie.endYear != null)
                                    Text(
                                      ' - ${chosenMovie.endYear}',
                                      style:
                                          context.textStyles.caption1!.copyWith(
                                        color: context.colors.textsSecondary,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }
                      return const SizedBox.shrink();
                    })
                  ],
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 18.0),
                    child: Text(
                      widget.isUsername ? '@' : '',
                      style: (widget.style ?? context.textStyles.callout!)
                          .copyWith(
                        color: context.colors.textsDisabled,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        AnimatedSize(
          curve: Curves.easeInOut,
          duration: const Duration(milliseconds: 400),
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 400),
            transitionBuilder: (Widget child, Animation<double> animation) {
              return ScaleTransition(scale: animation, child: child);
            },
            child: (!(widget.crossButton == null ||
                        widget.controller?.text == '' ||
                        widget.controller?.text == null) &&
                    widget.alternativeCancel &&
                    !focused)
                ? CupertinoButton(
                    padding: const EdgeInsets.only(left: 16.0),
                    child: Text(
                      context.txt.cancel,
                      style: TextStyle(color: context.colors.textsAction),
                    ),
                    onPressed: () {
                      if (widget.onRemoved != null) {
                        nullController.text = '';
                        widget.controller?.text = '';
                        widget.onRemoved!();
                        setState(() {});
                      }
                    },
                  )
                : const SizedBox.shrink(),
          ),
        )
      ],
    );
  }
}
