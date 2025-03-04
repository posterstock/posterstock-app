import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_easylogger/flutter_logger.dart';

import '../overlay_dialog.dart';
import 'animation/appear_widget.dart';

///Helper class to handle dialog appearance
///Keeps the latest dialog and closes the previous dialog automatically
class DialogHelper {
  static const Color backgroundColor = Color(0x61000000);
  static const Duration defaultDuration = Duration(milliseconds: 150);

  static final DialogHelper _instance = DialogHelper._();

  static DialogStyle defaultStyle = DialogStyle.adaptive;

  factory DialogHelper() => _instance;

  DialogHelper._();

  final List<IndexedData<OverlayEntry>> _currentOverlay = [];
  final List<IndexedData<Future<bool> Function()>> _currentCallback = [];
  final List<IndexedData<StreamController<double>>> _currentController = [];

  Future<bool> onWillPop() {
    return _currentCallback.isEmpty
        ? Future.value(true)
        : _currentCallback.last.data.call();
  }

  // Shows the dialog
  void show(BuildContext context, DialogWidget dialog,
      {bool rootOverlay = true, int? id, bool hidePrevious = true}) {
    if (hidePrevious || id == null) hideImmediate(context);

    OverlayState? overlayState = rootOverlay
        ? context.findRootAncestorStateOfType<OverlayState>()
        : context.findAncestorStateOfType<OverlayState>();

    if (dialog.closable) {
      _currentCallback.add(IndexedData<Future<bool> Function()>(
          id: id,
          data: () {
            hide(context, id: id);
            return Future.value(false);
          }));
    } else {
      _currentCallback.add(IndexedData<Future<bool> Function()>(
        id: id,
        data: () => Future.value(true),
      ));
    }

    if (_currentCallback.length == 1) {
      ModalRoute.of(context)?.addScopedWillPopCallback(onWillPop);
    }

    final StreamController<double> controller = StreamController();

    final OverlayEntry overlayEntry = OverlayEntry(
      builder: (_) => AppearWidget(
        progress: controller.stream,
        duration: defaultDuration,
        style: AppearStyle.opacity,
        child: dialog,
      ),
      maintainState: true,
    );

    _currentController
        .add(IndexedData<StreamController<double>>(id: id, data: controller));

    _currentOverlay.add(IndexedData<OverlayEntry>(id: id, data: overlayEntry));

    overlayState?.insert(overlayEntry);
    controller.add(1.0);
  }

  // Hide opened dialog with animation
  void hide(BuildContext context, {int? id}) {
    if (_currentCallback.length == 1 || id == null) {
      ModalRoute.of(context)?.removeScopedWillPopCallback(onWillPop);
    }

    _currentController
        .where((controller) => controller.id == id || id == null)
        .forEach((controller) => controller.data.add(0.0));

    Future.delayed(defaultDuration)
        .then((_) => _hide(id))
        .catchError((error) {});
  }

  // Hide opened dialog without animation, clear closable callback if any
  void hideImmediate(BuildContext context, {int? id}) {
    //reset back press handler
    if (_currentCallback.length == 1 || id == null) {
      ModalRoute.of(context)?.removeScopedWillPopCallback(onWillPop);
    }

    _hide(id);
  }

  void _hide(int? id) {
    _currentOverlay.removeWhere((overlay) {
      if (overlay.id == id || id == null) {
        try {
          overlay.data.remove();
        } catch (_) {
          Logger.e('Ошибка removeWhere $_ ');
        }

        return true;
      }

      return false;
    });

    _currentController.removeWhere((controller) {
      if (controller.id == id || id == null) {
        try {
          controller.data.close();
        } catch (_) {
          Logger.e('Ошибка removeWhere $_ ');
        }
        return true;
      }

      return false;
    });

    _currentCallback.removeWhere((callback) => callback.id == id || id == null);
  }
}

class IndexedData<T> {
  int? id;
  T data;

  IndexedData({this.id, required this.data});
}
