import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:poster_stock/common/widgets/app_text_field.dart';
import 'package:poster_stock/common/widgets/custom_scaffold.dart';
import 'package:poster_stock/themes/build_context_extension.dart';

class SearchPage extends StatelessWidget {
  SearchPage({Key? key}) : super(key: key);

  final TextEditingController textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 12.0,
            ),
            child: SizedBox(
              height: 36,
              child: Row(
                children: [
                  Expanded(
                    child: AppTextField(
                      controller: textController,
                      hint: 'Search',
                      removableWhenNotEmpty: true,
                      crossPadding: const EdgeInsets.all(8.0),
                      crossButton: SvgPicture.asset(
                        'assets/icons/search_cross.svg',
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 12,
                  ),
                  CupertinoButton(
                    padding: EdgeInsets.zero,
                    child: Text(
                      'Cancel',
                      style: context.textStyles.bodyRegular!.copyWith(
                        color: context.colors.textsAction,
                      ),
                    ),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
          ),
          SearchPageContent(),
        ],
      ),
    );
  }
}

class SearchPageContent extends StatefulWidget {
  const SearchPageContent({Key? key}) : super(key: key);

  @override
  SearchPageContentState createState() => SearchPageContentState();
}

class SearchPageContentState extends State<SearchPageContent> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class SearchTabView extends StatefulWidget {
  const SearchTabView({Key? key}) : super(key: key);

  @override
  SearchTabViewState createState() => SearchTabViewState();
}

class SearchTabViewState extends State<SearchTabView>
    with SingleTickerProviderStateMixin {
  late final TabController controller;
  @override
  void initState() {
    controller = TabController(vsync: this, length: 3);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TabBar(
          dividerColor: Colors.transparent,
          controller: controller,
          indicatorColor: context.colors.iconsActive,
          tabs: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 14.0),
              child: Text(
                "Users",
                style: context.textStyles.subheadline,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 14.0),
              child: Text(
                "Posters",
                style: context.textStyles.subheadline,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 14.0),
              child: Text(
                "Lists",
                style: context.textStyles.subheadline,
              ),
            ),
          ],
        ),
        TabBarView(
          controller: controller,
          children: [],
        ),
      ],
    );
  }
}
