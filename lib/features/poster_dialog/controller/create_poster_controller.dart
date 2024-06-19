import 'package:flutter_easylogger/flutter_logger.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:poster_stock/features/account/notifiers/bookmarks_notifier.dart';
import 'package:poster_stock/features/account/notifiers/posters_notifier.dart';
import 'package:poster_stock/features/poster_dialog/model/media_model.dart';
import 'package:poster_stock/features/poster_dialog/repository/create_poster_repository.dart';
import 'package:poster_stock/features/poster_dialog/state_holder/create_poster_chosen_movie_state_holder.dart';
import 'package:poster_stock/features/poster_dialog/state_holder/create_poster_chosen_poster_state_holder.dart';
import 'package:poster_stock/features/poster_dialog/state_holder/create_poster_images_state_holder.dart';
import 'package:poster_stock/features/poster_dialog/state_holder/create_poster_search_list.dart';
import 'package:poster_stock/features/poster_dialog/state_holder/create_poster_search_state_holder.dart';
import 'package:poster_stock/features/profile/controllers/profile_controller.dart';
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
    posterNotifier: ref.read(accountPostersStateNotifier.notifier),
    bookmarkNotifier: ref.read(accountBookmarksStateNotifier.notifier),
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
  // final AccountNotifier accountNotifier;
  final PostersNotifier posterNotifier;
  final BookmarksNotifier bookmarkNotifier;
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
    required this.posterNotifier,
    required this.bookmarkNotifier,
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
    final languageState = languages.currentState;
    createPosterSearchListStateHolder.updateValue(
      await createPosterRepository.getSearchMedia(value, languageState!),
    );
  }

  void chooseMovie(MediaModel? movie) async {
    createPosterChoseMovieStateHolder.updateValue(movie);
    createPosterChosenPosterStateHolder.updateValue(null);
    var chosenMovie = createPosterChoseMovieStateHolder.currentState;
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
    var mediaState = createPosterChoseMovieStateHolder.currentState;
    var image = createPosterChosenPosterStateHolder.currentState;
    try {
      await createPosterRepository.createPoster(
          mediaState!.id,
          mediaState.type.name,
          image!.$2,
          description,
          languages.currentState!);
      posterNotifier.reload();
      profileControllerApi.getUserInfo(null); //TODO: redundant
    } catch (e) {
      Logger.e('Ошибка при создании постера $e');
    }
    createPosterChoseMovieStateHolder.updateValue(null);
    createPosterChosenPosterStateHolder.updateValue(null);
    createPosterSearchStateHolder.updateValue('');
    createPosterSearchListStateHolder.setValue(null);
    createPosterImagesStateHolder.setValue([]);
  }

  Future<void> editPoster(int id, String image, String description) async {
    var selectedImage = createPosterChosenPosterStateHolder.currentState;
    if (selectedImage != null) {
      image = selectedImage.$2;
    }
    try {
      await createPosterRepository.editPoster(id, image, description);
      posterNotifier.reload();
      profileControllerApi.getUserInfo(null);
    } catch (e) {
      Logger.e('Ошибка при редактировании постера $e');
    }
    createPosterChoseMovieStateHolder.updateValue(null);
    createPosterSearchStateHolder.updateValue('');
    createPosterSearchListStateHolder.setValue(null);
    createPosterImagesStateHolder.setValue([]);
  }

  Future<void> createBookmark() async {
    var mediaState = createPosterChoseMovieStateHolder.currentState;
    var image = createPosterChosenPosterStateHolder.currentState;
    try {
      await createPosterRepository.createBookmark(
        mediaState!.id,
        mediaState.type.name,
        image!.$2,
        languages.currentState!,
      );
      bookmarkNotifier.reload();
      profileControllerApi.getUserInfo(null); //TODO: redundant
    } catch (e) {
      Logger.e('Ошибка при создании закладки $e');
    }
    createPosterChoseMovieStateHolder.updateValue(null);
    createPosterChosenPosterStateHolder.updateValue(null);
    createPosterSearchStateHolder.updateValue('');
    createPosterSearchListStateHolder.setValue(null);
    createPosterImagesStateHolder.setValue([]);
  }
}
