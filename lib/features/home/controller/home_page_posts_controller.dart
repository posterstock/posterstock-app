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
  bool gettingPosts = false;
  bool gotAll = false;

  HomePagePostsController({
    required this.homePagePostsState,
    required this.repository,
  });

  Future<void> getPosts({bool getNewPosts = false}) async {
    if (gettingPosts) return;
    if (!getNewPosts && gotAll) return;
    gettingPosts = true;
    final result = await repository.getPosts(getNesPosts: getNewPosts);
    gotAll = result?.$2 ?? false;
    try {
      if (getNewPosts) {
        await homePagePostsState.updateState(result?.$1);
      } else {
        await homePagePostsState.updateStateEnd(result?.$1);
      }
    } catch (e) {
      print("ss$e");
    }
    gettingPosts = false;
  }

  Future<void> setLike(int index, int index2) async {
    homePagePostsState.setLike(index, index2);
    repository.setLike(homePagePostsState.state?[index][index2].id,
        (homePagePostsState.state?[index][index2].liked ?? false));
  }

  Future<void> setLikeId(int id, bool value) async {
    homePagePostsState.setLikeId(id, value);
    repository.setLike(id, value);
  }

  Future<void> setFollowId(int id, bool value) async {
    homePagePostsState.setFollow(id, !value);
  }

  Future<void> addComment(int id) async {
    homePagePostsState.addComment(id);
  }
}
