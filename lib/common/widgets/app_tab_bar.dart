import 'package:flutter/material.dart';
import 'package:poster_stock/themes/build_context_extension.dart';

class AppTabBar extends StatelessWidget {
  final List<Tab> tabs;
  final TabController tabController;

  AppTabBar(
    this.tabController,
    List<String> tabs, {
    super.key,
  }) : tabs = tabs
            .map((it) =>
                Tab(child: FittedBox(fit: BoxFit.fitWidth, child: Text(it))))
            .toList();

  @override
  Widget build(BuildContext context) {
    return TabBar(
      controller: tabController,
      labelColor: context.colors.textsPrimary,
      // indicatorColor: context.colors.iconsActive,
      labelPadding: const EdgeInsets.symmetric(vertical: 14),
      labelStyle: context.textStyles.subheadlineBold,
      indicatorSize: TabBarIndicatorSize.tab,
      dividerColor: context.colors.fieldsDefault,
      dividerHeight: 1,
      tabs: tabs,
      indicator: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: context.colors.iconsActive!,
            width: 2, // Толщина полоски таба
          ),
        ),
      ),
    );
  }
}
