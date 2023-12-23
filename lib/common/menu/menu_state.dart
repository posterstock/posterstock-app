import 'dart:ui';

class MenuState {
  final String? title;
  final List<MenuItem> items;

  MenuState(this.title, this.items);
}

class MenuItem {
  final String asset;
  final String title;
  final bool danger;
  final VoidCallback callback;

  MenuItem(this.asset, this.title, this.callback) : danger = false;

  MenuItem.danger(this.asset, this.title, this.callback) : danger = true;
}
