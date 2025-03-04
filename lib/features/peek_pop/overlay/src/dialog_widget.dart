import 'package:flutter/widgets.dart';

import '../overlay_dialog.dart';
import 'dialog_factory.dart';

/// Represents dialog in Material or Cupertino style,
/// adaptive dialog chooses style depends on platform
///
/// closable flag allows to hide dialog by back press or touch outside
class DialogWidget extends StatelessWidget {
  final bool closable;
  final Widget _widget;

  DialogWidget.alert({
    super.key,
    DialogStyle? style,
    required String title,
    required String content,
    required List<DialogAction> actions,
    this.closable = true,
  }) : _widget = DialogFactory(style ?? DialogHelper.defaultStyle)
            .alert(title, content, actions);

  /*DialogWidget.input();*/

  DialogWidget.progress({super.key, DialogStyle? style, this.closable = false})
      : _widget = DialogFactory(style ?? DialogHelper.defaultStyle).progress();

  DialogWidget.custom(
      {super.key,
      DialogStyle? style,
      required Widget child,
      this.closable = true})
      : _widget = DialogFactory(DialogHelper.defaultStyle).custom(child);

  @override
  Widget build(BuildContext context) {
    return _widget;
  }
}
