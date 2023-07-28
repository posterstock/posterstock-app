import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:poster_stock/common/state_holders/auth_token_state_holder.dart';
import 'package:poster_stock/features/home/repository/home_page_posts_repository.dart';
import 'package:poster_stock/features/home/repository/i_home_page_posts_repository.dart';
import 'package:poster_stock/features/home/state_holders/home_page_posts_state_holder.dart';

final homePagePostsControllerProvider = Provider<HomePagePostsController>(
  (ref) => HomePagePostsController(
    homePagePostsState: ref.watch(homePagePostsStateHolderProvider.notifier),
    repository: HomePagePostsRepository(),
    token: ref.watch(authTokenStateHolderProvider)!,
  ),
);

class HomePagePostsController {
  final HomePagePostsStateHolder homePagePostsState;
  final IHomePagePostsRepository repository;
  final String token;
  bool gettingPosts = false;

  HomePagePostsController({
    required this.homePagePostsState,
    required this.repository,
    required this.token,
  });

  Future<void> getPosts({bool getNewPosts = false}) async {
    if (gettingPosts) return;
    gettingPosts = true;
    final result = await repository.getPosts(token, getNesPosts: getNewPosts);
    if (getNewPosts) {
      print("GETTING NEW");
      await homePagePostsState.updateState(result);
    } else {
      await homePagePostsState.updateStateEnd(result);
    }
    gettingPosts = false;
  }

  Future<void> setLike(int index) async {
    homePagePostsState.setLike(index);
    repository.setLike(token, homePagePostsState.state?[index][0].id,
        (homePagePostsState.state?[index][0].liked ?? false));
  }
}
