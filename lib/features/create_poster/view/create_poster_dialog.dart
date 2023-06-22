import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:poster_stock/common/widgets/app_text_field.dart';
import 'package:poster_stock/features/create_list/view/create_list_dialog.dart';
import 'package:poster_stock/features/create_poster/controller/create_poster_controller.dart';
import 'package:poster_stock/features/create_poster/state_holder/create_poster_chosen_movie_state_holder.dart';
import 'package:poster_stock/features/create_poster/state_holder/create_poster_images_state_holder.dart';
import 'package:poster_stock/features/create_poster/state_holder/create_poster_search_state_holder.dart';
import 'package:poster_stock/themes/build_context_extension.dart';

class CreatePosterDialog extends ConsumerStatefulWidget {
  const CreatePosterDialog({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState<CreatePosterDialog> createState() => _CreatePosterDialogState();
}

class _CreatePosterDialogState extends ConsumerState<CreatePosterDialog> {
  final dragController = DraggableScrollableController();
  final searchController = TextEditingController();
  bool disposed = false;

  @override
  void dispose() {
    disposed = true;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final String searchText = ref.watch(createPosterSearchStateHolderNotifier);
    final (String, String)? chosenMovie =
        ref.watch(createPosterChoseMovieStateHolderProvider);
    final List<String> images =
        ref.watch(createPosterImagesStateHolderProvider);
    if (searchText != searchController.text) {
      searchController.text = searchText;
    }
    dragController.addListener(() {
      if (dragController.size < 0.1) {
        if (!disposed) {
          Navigator.pop(context);
        }
        disposed = true;
      }
    });
    return Scaffold(
      backgroundColor: Colors.transparent,
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            bottom: 0,
            right: 0,
            child: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                color: Colors.transparent,
              ),
            ),
          ),
          DraggableScrollableSheet(
            controller: dragController,
            minChildSize: 0,
            initialChildSize: 0.7,
            maxChildSize: 1,
            snap: true,
            snapSizes: const [0.7, 1],
            builder: (context, controller) {
              return Container(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(16.0),
                    topLeft: Radius.circular(16.0),
                  ),
                  color: context.colors.backgroundsPrimary,
                ),
                child: Column(
                  children: [
                    Expanded(
                      child: CustomScrollView(
                        controller: controller,
                        slivers: [
                          SliverPersistentHeader(
                            delegate: AppDialogHeaderDelegate(
                              extent: 150,
                              content: Column(
                                children: [
                                  const SizedBox(height: 14),
                                  Container(
                                    height: 4,
                                    width: 36,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(2.0),
                                      color: context.colors.fieldsDefault,
                                    ),
                                  ),
                                  const SizedBox(height: 22),
                                  Text(
                                    'Add poster',
                                    style: context.textStyles.bodyBold,
                                  ),
                                  const SizedBox(height: 17),
                                  SizedBox(
                                    height: 36,
                                    child: Stack(
                                      children: [
                                        AppTextField(
                                          searchField: true,
                                          hint: 'Movie or TV Series',
                                          removableWhenNotEmpty: true,
                                          crossPadding:
                                              const EdgeInsets.all(8.0),
                                          crossButton: SvgPicture.asset(
                                            'assets/icons/search_cross.svg',
                                          ),
                                          onRemoved: () {
                                            searchController.clear();
                                            ref
                                                .read(
                                                    createPosterControllerProvider)
                                                .updateSearch('');
                                          },
                                          onChanged: (value) {
                                            ref
                                                .read(
                                                    createPosterControllerProvider)
                                                .updateSearch(value);
                                          },
                                          controller: searchController,
                                        ),
                                        if (chosenMovie != null)
                                          Positioned(
                                            top: 2.0,
                                            left: 48.0,
                                            child: Material(
                                              color: context
                                                  .colors.backgroundsPrimary,
                                              child: SizedBox(
                                                height: 30,
                                                child: Row(
                                                  children: [
                                                    Text(
                                                      'Jay and Silent bob',
                                                      style: context.textStyles
                                                          .bodyRegular,
                                                    ),
                                                    const SizedBox(
                                                      width: 8,
                                                    ),
                                                    Text(
                                                      '1999',
                                                      style: context
                                                          .textStyles.caption1!
                                                          .copyWith(
                                                        color: context.colors
                                                            .textsSecondary,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                  if (searchText.isEmpty || chosenMovie != null)
                                    const SizedBox(height: 16),
                                ],
                              ),
                            ),
                            pinned: true,
                          ),
                          if (searchText.isEmpty || chosenMovie != null)
                            SliverToBoxAdapter(
                              child: SizedBox(
                                height: 160,
                                child: ListView.separated(
                                  itemCount:
                                      chosenMovie == null ? 20 : images.length,
                                  itemBuilder: (context, index) => Padding(
                                    padding: EdgeInsets.only(
                                        left: index == 0 ? 16.0 : 0.0,
                                        right: index ==
                                                ((chosenMovie == null
                                                        ? 20
                                                        : images.length) -
                                                    1)
                                            ? 16.0
                                            : 0.0),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(8.0),
                                      child: Container(
                                        width: 106,
                                        color:
                                            context.colors.backgroundsSecondary,
                                        child: chosenMovie == null
                                            ? null
                                            : Image.network(
                                                images[index],
                                                fit: BoxFit.cover,
                                                cacheWidth: 200,
                                              ),
                                      ),
                                    ),
                                  ),
                                  separatorBuilder: (context, index) =>
                                      const SizedBox(
                                    width: 8,
                                  ),
                                  scrollDirection: Axis.horizontal,
                                ),
                              ),
                            ),
                          if (searchText.isNotEmpty && chosenMovie == null)
                            SliverList.builder(
                              itemBuilder: (context, index) => Material(
                                color: context.colors.backgroundsPrimary,
                                child: InkWell(
                                  onTap: () {
                                    ref
                                        .read(createPosterControllerProvider)
                                        .chooseMovie(
                                      ('Jay and Silent bob', '1999'),
                                    );
                                  },
                                  child: Padding(
                                    padding: EdgeInsets.fromLTRB(
                                      16.0,
                                      12.0,
                                      16.0,
                                      12.0,
                                    ),
                                    child: Row(
                                      children: [
                                        Text(
                                          'Jay and Silent bob',
                                          style: context.textStyles.bodyRegular,
                                        ),
                                        const SizedBox(
                                          width: 8,
                                        ),
                                        Text(
                                          '1999',
                                          style: context.textStyles.caption1!
                                              .copyWith(
                                            color:
                                                context.colors.textsSecondary,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          SliverToBoxAdapter(
                            child: SizedBox(
                              height:
                                  MediaQuery.of(context).padding.bottom + 130,
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Column(
              children: [
                Divider(
                  height: 1,
                  thickness: 1,
                  color: context.colors.fieldsDefault,
                ),
                Container(
                  height: 17.5,
                  color: context.colors.backgroundsPrimary,
                ),
                Container(
                  color: context.colors.backgroundsPrimary,
                  child: const DescriptionTextField(
                    hint:
                        'Share your one-line review with your audience, \nit matters for them.',
                    showDivider: false,
                  ),
                ),
                Container(
                  height: MediaQuery.of(context).padding.bottom,
                  color: context.colors.backgroundsPrimary,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
