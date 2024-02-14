import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:poster_stock/features/account/account_network.dart';
import 'package:poster_stock/features/account/notifiers/account_notifier.dart';
import 'package:poster_stock/features/account/notifiers/bookmarks_notifier.dart';
import 'package:poster_stock/features/account/notifiers/posters_notifier.dart';
import 'package:poster_stock/features/create_poster/model/media_model.dart';
import 'package:poster_stock/features/create_poster/repository/create_poster_repository.dart';
import 'package:poster_stock/features/create_poster/state_holder/create_poster_chosen_movie_state_holder.dart';
import 'package:poster_stock/features/create_poster/state_holder/create_poster_chosen_poster_state_holder.dart';
import 'package:poster_stock/features/create_poster/state_holder/create_poster_images_state_holder.dart';
import 'package:poster_stock/features/create_poster/state_holder/create_poster_search_list.dart';
import 'package:poster_stock/features/create_poster/state_holder/create_poster_search_state_holder.dart';
import 'package:poster_stock/features/profile/controllers/profile_controller.dart';
import 'package:poster_stock/features/profile/models/user_details_model.dart';
import 'package:poster_stock/features/profile/state_holders/profile_info_state_holder.dart';
import 'package:poster_stock/features/settings/state_holders/chosen_language_state_holder.dart';

final createPosterControllerProvider =
    Provider.autoDispose<CreatePosterController>(
  (ref) => CreatePosterController(
    createPosterSearchStateHolder: ref.watch(
      createPosterSearchStateHolderNotifier.notifier,
    ),
    createPosterChoseMovieStateHolder: ref.watch(
      createPosterChoseMovieStateHolderProvider.notifier,
    ),
    createPosterImagesStateHolder: ref.watch(
      createPosterImagesStateHolderProvider.notifier,
    ),
    createPosterChosenPosterStateHolder: ref.watch(
      createPosterChosenPosterStateHolderProvider.notifier,
    ),
    createPosterSearchListStateHolder: ref.watch(
      createPosterSearchListStateHolderProvider.notifier,
    ),
    profileControllerApi: ref.read(profileControllerApiProvider),
    accountNotifier: ref.read(accountNotifier.notifier),
    posterNotifier: ref.read(accountPostersStateNotifier.notifier),
    bookmarkNotifier: ref.read(accountBookmarksStateNotifier.notifier),
    profileInfoStateHolder: ref.watch(profileInfoStateHolderProvider),
    languages: ref.watch(chosenLanguageStateHolder.notifier),
  ),
);

class CreatePosterController {
  final CreatePosterSearchStateHolder createPosterSearchStateHolder;
  final CreatePosterChoseMovieStateHolder createPosterChoseMovieStateHolder;
  final CreatePosterImagesStateHolder createPosterImagesStateHolder;
  final CreatePosterChosenPosterStateHolder createPosterChosenPosterStateHolder;
  final CreatePosterSearchListStateHolder createPosterSearchListStateHolder;
  final ProfileControllerApi profileControllerApi;
  final AccountNotifier accountNotifier;
  final PostersNotifier posterNotifier;
  final BookmarksNotifier bookmarkNotifier;
  final UserDetailsModel? profileInfoStateHolder;
  final CreatePosterRepository createPosterRepository =
      CreatePosterRepository();
  final ChosenLanguageStateHolder languages;

  CreatePosterController({
    required this.createPosterSearchStateHolder,
    required this.createPosterChoseMovieStateHolder,
    required this.createPosterImagesStateHolder,
    required this.createPosterChosenPosterStateHolder,
    required this.createPosterSearchListStateHolder,
    required this.profileControllerApi,
    required this.accountNotifier,
    required this.posterNotifier,
    required this.bookmarkNotifier,
    required this.profileInfoStateHolder,
    required this.languages,
  });

  void updateSearch(String value) async {
    createPosterChoseMovieStateHolder.updateValue(null);
    createPosterChosenPosterStateHolder.updateValue(null);
    createPosterImagesStateHolder.setValue([]);
    createPosterSearchStateHolder.updateValue(value);
    createPosterSearchListStateHolder.setValue(
      null,
    );
    createPosterSearchListStateHolder.updateValue(
      await createPosterRepository.getSearchMedia(value, languages.state!),
    );
  }

  void chooseMovie(MediaModel? movie) async {
    createPosterChoseMovieStateHolder.updateValue(movie);
    createPosterChosenPosterStateHolder.updateValue(null);
    var chosenMovie = createPosterChoseMovieStateHolder.state;
    var images = movie == null
        ? null
        : await createPosterRepository.getMediaPosters(
            chosenMovie!.type.name, chosenMovie.id);
    createPosterImagesStateHolder.setValue(images ?? []);
  }

  void choosePoster((int, String)? poster) {
    createPosterChosenPosterStateHolder.updateValue(poster);
  }

  Future<void> createPoster(String description) async {
    var mediaState = createPosterChoseMovieStateHolder.state;
    var image = createPosterChosenPosterStateHolder.state;
    try {
      await createPosterRepository.createPoster(mediaState!.id,
          mediaState.type.name, image!.$2, description, languages.state!);
      posterNotifier.reload(accountNotifier.state!.id);
      profileControllerApi.getUserInfo(null); //TODO: redundant
    } catch (e) {
      print(e);
    }
    createPosterChoseMovieStateHolder.updateValue(null);
    createPosterChosenPosterStateHolder.updateValue(null);
    createPosterSearchStateHolder.updateValue('');
    createPosterSearchListStateHolder.setValue(null);
    createPosterImagesStateHolder.setValue([]);
  }

  Future<void> createBookmark() async {
    var mediaState = createPosterChoseMovieStateHolder.state;
    var image = createPosterChosenPosterStateHolder.state;
    try {
      await createPosterRepository.createBookmark(
        mediaState!.id,
        mediaState.type.name,
        image!.$2,
        languages.state!,
      );
      bookmarkNotifier.reload();
      profileControllerApi.getUserInfo(null); //TODO: redundant
    } catch (e) {
      print(e);
    }
    createPosterChoseMovieStateHolder.updateValue(null);
    createPosterChosenPosterStateHolder.updateValue(null);
    createPosterSearchStateHolder.updateValue('');
    createPosterSearchListStateHolder.setValue(null);
    createPosterImagesStateHolder.setValue([]);
  }
}
