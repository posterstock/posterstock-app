import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';

// Supported animation type
// opacity creates fade in / out effect
// blur makes background blurred
enum AppearStyle {
  opacity,
}

// Uses to animate dialog appearance
class AppearWidget extends StatefulWidget {
  final Widget _child;
  final Stream _progress;
  final Duration _duration;
  final AppearStyle _style;

  const AppearWidget(
      {super.key,
      required Widget child,
      required progress,
      required Duration duration,
      AppearStyle style = AppearStyle.opacity})
      : _child = child,
        _progress = progress,
        _duration = duration,
        _style = style;

  @override
  AppearWidgetState createState() => AppearWidgetState();
}

class AppearWidgetState extends State<AppearWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late StreamSubscription _subscription;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: widget._duration,
      vsync: this,
    );

    _subscription = widget._progress.listen((progress) {
      _controller.animateTo(progress);
    });
  }

  @override
  void dispose() {
    _subscription.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: _controller,
        child: widget._child,
        builder: (_, child) => Opacity(
              opacity: _controller.value,
              child: child,
            ));
  }

  Widget getWidget(Widget? child, double progress) {
    switch (widget._style) {
      case AppearStyle.opacity:
        return Opacity(
          opacity: progress,
          child: child,
        );
      default:
        return Opacity(
          opacity: progress,
          child: child,
        );
    }
  }
}
