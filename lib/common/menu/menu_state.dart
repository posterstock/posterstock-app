import 'dart:ui';

class MenuState {
  final String? title;
  final List<MenuElement> items;

  MenuState(this.title, this.items);
}

abstract class MenuElement {
  final String title;

  MenuElement(this.title);
}

class MenuItem extends MenuElement {
  final String asset;
  final bool danger;
  final VoidCallback callback;

  MenuItem(this.asset, String title, this.callback)
      : danger = false,
        super(title);

  MenuItem.danger(this.asset, String title, this.callback)
      : danger = true,
        super(title);
}

class MenuTitle extends MenuElement {
  MenuTitle(String title) : super(title);
}
