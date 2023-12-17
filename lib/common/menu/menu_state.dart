class MenuState {
  final String? title;
  final List<MenuItem> items;

  MenuState(this.title, this.items);
}

class MenuItem {
  final String asset;
  final String title;
  final bool danger;

  MenuItem(this.asset, this.title, [this.danger = false]);
}
