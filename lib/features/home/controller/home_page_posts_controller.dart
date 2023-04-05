import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:poster_stock/features/home/repository/home_page_posts_repository.dart';
import 'package:poster_stock/features/home/repository/i_home_page_posts_repository.dart';
import 'package:poster_stock/features/home/state_holders/home_page_posts_state_holder.dart';

final homePagePostsControllerProvider = Provider<HomePagePostsController>(
  (ref) => HomePagePostsController(
    homePagePostsState: ref.watch(homePagePostsStateHolderProvider.notifier),
    repository: HomePagePostsRepository(),
  ),
);

class HomePagePostsController {
  final HomePagePostsStateHolder homePagePostsState;
  final IHomePagePostsRepository repository;

  HomePagePostsController({
    required this.homePagePostsState,
    required this.repository,
  });

  Future<void> getPosts() async {
    final result = await repository.getPosts();
    homePagePostsState.updateState(result);
  }
}
