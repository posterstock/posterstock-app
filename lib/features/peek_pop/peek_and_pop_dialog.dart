library peek_and_pop_dialog;

import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vibration/vibration.dart';

import 'cubit/peek_and_pop_dialog_cubit.dart';
import 'overlay/overlay_dialog.dart';

class PeekAndPopDialog extends StatefulWidget {
  const PeekAndPopDialog({
    Key? key,
    required this.child,
    required this.dialog,
    required this.onTap,
    this.customOnLongTap,
  }) : super(key: key);
  final Widget child;
  final Widget dialog;
  final void Function() onTap;
  final void Function()? customOnLongTap;

  @override
  State<PeekAndPopDialog> createState() => _PeekAndPopDialogState();
}

class _PeekAndPopDialogState extends State<PeekAndPopDialog> {
  Timer? _timer;
  bool long = false;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => PeekAndPopDialogCubit(),
      child: BlocConsumer<PeekAndPopDialogCubit, bool>(
        listener: (context, isVisble) async {
          if (isVisble) {
            DialogHelper().show(context,
                DialogWidget.custom(closable: true, child: widget.dialog));
          } else {
            DialogHelper().hide(context);
          }
        },
        builder: (context, state) {
          return Listener(
            onPointerUp: (details) {
              _timer?.cancel(); context.read<PeekAndPopDialogCubit>().updateState(false); Future((){long = false;});
            },
            child: GestureDetector(
              onTap: () {if (!long) widget.onTap();},
              onPanCancel: () {_timer?.cancel();} ,
              onPanEnd: (d) { _timer?.cancel(); context.read<PeekAndPopDialogCubit>().updateState(false); Future((){long = false;});} ,
              onPanDown: (_) => {
                _timer = Timer(const Duration(milliseconds: 500), () {
                  long = true;
                  if (widget.customOnLongTap != null) {
                    widget.customOnLongTap!();
                    return;
                  }
                  context.read<PeekAndPopDialogCubit>().updateState(true);
                  if (Platform.isIOS) {
                    Vibration.vibrate(duration: 20, amplitude: 50);
                  } else {
                    Vibration.vibrate(duration: 50, amplitude: 100);
                  }
                })
              },
              child: widget.child,
            ),
          );
        },
      ),
    );
  }
}
