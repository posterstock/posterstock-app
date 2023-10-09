import 'package:flutter_riverpod/flutter_riverpod.dart';
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

final createPosterControllerProvider = Provider<CreatePosterController>(
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
    profileInfoStateHolder: ref.watch(profileInfoStateHolderProvider),
  ),
);

class CreatePosterController {
  final CreatePosterSearchStateHolder createPosterSearchStateHolder;
  final CreatePosterChoseMovieStateHolder createPosterChoseMovieStateHolder;
  final CreatePosterImagesStateHolder createPosterImagesStateHolder;
  final CreatePosterChosenPosterStateHolder createPosterChosenPosterStateHolder;
  final CreatePosterSearchListStateHolder createPosterSearchListStateHolder;
  final ProfileControllerApi profileControllerApi;
  final UserDetailsModel? profileInfoStateHolder;
  final CreatePosterRepository createPosterRepository =
      CreatePosterRepository();

  CreatePosterController({
    required this.createPosterSearchStateHolder,
    required this.createPosterChoseMovieStateHolder,
    required this.createPosterImagesStateHolder,
    required this.createPosterChosenPosterStateHolder,
    required this.createPosterSearchListStateHolder,
    required this.profileControllerApi,
    required this.profileInfoStateHolder,
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
      await createPosterRepository.getSearchMedia(value),
    );
  }

  void chooseMovie(MediaModel? movie) async {
    createPosterChoseMovieStateHolder.updateValue(movie);
    createPosterChosenPosterStateHolder.updateValue(null);
    var chosenMovie = createPosterChoseMovieStateHolder.state;
    var images = movie == null ? null : await createPosterRepository.getMediaPosters(
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
      await createPosterRepository.createPoster(
        mediaState!.id,
        mediaState.type.name,
        image!.$2,
        description,
      );
      profileControllerApi.getUserInfo(null);
    } catch (e) {
      print(e);
    }
    createPosterChoseMovieStateHolder.updateValue(null);
    createPosterChosenPosterStateHolder.updateValue(null);
    createPosterSearchStateHolder.updateValue('');
    createPosterSearchListStateHolder.setValue(
      null,
    );
    createPosterImagesStateHolder.setValue([]);
  }

  Future<void> createBookmark() async {
    var mediaState = createPosterChoseMovieStateHolder.state;
    var image = createPosterChosenPosterStateHolder.state;
    try {
      await createPosterRepository.createBookmark(
        mediaState!.id,
        mediaState.type.name,
        image!.$2
      );
      profileControllerApi.getUserInfo(null);
    } catch (e) {
      print(e);
    }
    createPosterChoseMovieStateHolder.updateValue(null);
    createPosterChosenPosterStateHolder.updateValue(null);
    createPosterSearchStateHolder.updateValue('');
    createPosterSearchListStateHolder.setValue(
      null,
    );
    createPosterImagesStateHolder.setValue([]);
  }
}
