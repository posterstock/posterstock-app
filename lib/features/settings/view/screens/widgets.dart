import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:poster_stock/common/helpers/custom_ink_well.dart';
import 'package:poster_stock/themes/build_context_extension.dart';

class DoubleButton extends StatelessWidget {
  const DoubleButton(
      {Key? key,
      required this.onTap1,
      required this.child1,
      required this.onTap2,
      required this.child2})
      : super(key: key);
  final void Function() onTap1;
  final Widget child1;
  final void Function() onTap2;
  final Widget child2;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12.0),
      child: Material(
        color: context.colors.backgroundsPrimary,
        child: SizedBox(
          height: 96.5,
          child: Column(
            children: [
              Expanded(
                child: InkWell(
                  highlightColor: Colors.transparent.withOpacity(0.1),
                  onTap: onTap1,
                  child: SizedBox(
                    width: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                      ),
                      child: child1,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Divider(
                  color: context.colors.fieldsDefault,
                  height: 0.5,
                  thickness: 0.5,
                ),
              ),
              Expanded(
                child: InkWell(
                  highlightColor: Colors.transparent.withOpacity(0.1),
                  onTap: onTap2,
                  child: SizedBox(
                    width: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                      ),
                      child: child2,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AreYouSureDialog extends ConsumerWidget {
  const AreYouSureDialog({
    Key? key,
    required this.actionText,
    required this.secondAction,
    required this.onTap,
    required this.onTapSecond,
  }) : super(key: key);

  final String actionText;
  final String secondAction;
  final void Function() onTap;
  final void Function() onTapSecond;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: SizedBox(
        height: 252,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(16.0),
                child: SizedBox(
                  height: 140,
                  child: Material(
                    color: context.colors.backgroundsPrimary,
                    child: Column(
                      children: [
                        SizedBox(
                          height: 36,
                          child: Center(
                            child: Text(
                              context.txt.settings_disconnect_confirm,
                              style: context.textStyles.footNote!.copyWith(
                                color: context.colors.textsSecondary,
                              ),
                            ),
                          ),
                        ),
                        Divider(
                          height: 0.5,
                          thickness: 0.5,
                          color: context.colors.fieldsDefault,
                        ),
                        Expanded(
                          child: InkWell(
                            onTap: onTap,
                            child: Center(
                              child: Text(
                                actionText,
                                style: context.textStyles.bodyRegular!.copyWith(
                                  color: context.colors.textsPrimary,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Divider(
                          height: 0.5,
                          thickness: 0.5,
                          color: context.colors.fieldsDefault,
                        ),
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              onTapSecond();
                            },
                            child: Center(
                              child: Text(
                                secondAction,
                                style: context.textStyles.bodyRegular!.copyWith(
                                  color: context.colors.textsError,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(16.0),
                child: SizedBox(
                  height: 52,
                  child: Material(
                    color: context.colors.backgroundsPrimary,
                    child: InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Center(
                        child: Text(
                          context.txt.cancel,
                          style: context.textStyles.bodyRegular,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SettingsButton extends StatelessWidget {
  const SettingsButton({
    Key? key,
    required this.onTap,
    required this.child,
  }) : super(key: key);
  final void Function() onTap;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12.0),
      child: Material(
        color: context.colors.backgroundsPrimary,
        child: InkWell(
          highlightColor: Colors.transparent.withOpacity(0.1),
          onTap: onTap,
          child: SizedBox(
            height: 48,
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}

class MultipleSettingsButton extends StatelessWidget {
  const MultipleSettingsButton({
    Key? key,
    required this.onTaps,
    required this.children,
  })  : assert(onTaps.length == children.length),
        super(key: key);
  final List<void Function()> onTaps;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12.0),
      child: Material(
        color: context.colors.backgroundsPrimary,
        child: SizedBox(
          height: 48 * children.length + (children.length - 1) * 0.5,
          child: Column(
            children: List.generate(
              children.length,
              (index) => Expanded(
                child: Column(
                  children: [
                    Expanded(
                      child: InkWell(
                        highlightColor: Colors.transparent.withOpacity(0.1),
                        onTap: onTaps[index],
                        child: SizedBox(
                          width: double.infinity,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16.0,
                            ),
                            child: children[index],
                          ),
                        ),
                      ),
                    ),
                    if (index != children.length - 1)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Divider(
                          color: context.colors.fieldsDefault,
                          height: 0.5,
                          thickness: 0.5,
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
  }
}

Future<bool> treDelete(BuildContext context) async {
  bool? exit = await showDialog(
    context: context,
    builder: (context) => Padding(
      padding: const EdgeInsets.symmetric(horizontal: 38.0),
      child: Center(
        child: Material(
          color: Colors.transparent,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16.0),
            child: Container(
              height: 132,
              decoration: BoxDecoration(
                color: context.colors.backgroundsPrimary,
                borderRadius: BorderRadius.circular(16.0),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x29000000),
                    offset: Offset(0, 16),
                    blurRadius: 24,
                    spreadRadius: 0,
                  )
                ],
              ),
              child: Column(
                children: [
                  Expanded(
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(
                          //TODO: localize
                          "Are you sure you want to delete all your user data?",
                          style: context.textStyles.bodyBold,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                  Divider(
                    height: 0.5,
                    thickness: 0.5,
                    color: context.colors.fieldsDefault,
                  ),
                  SizedBox(
                    height: 52,
                    child: Row(
                      children: [
                        Expanded(
                          child: CustomInkWell(
                            onTap: () {
                              Navigator.pop(context, true);
                            },
                            child: Center(
                              child: Text(
                                context.txt.delete,
                                style: context.textStyles.bodyRegular!.copyWith(
                                  color: context.colors.textsError,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: CustomInkWell(
                            onTap: () {
                              Navigator.pop(context, false);
                            },
                            child: Center(
                              child: Text(
                                context.txt.cancel,
                                style: context.textStyles.bodyRegular,
                              ),
                            ),
                          ),
                        ),
                      ],
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
  return exit ?? false;
}
