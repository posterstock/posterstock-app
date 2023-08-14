import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:poster_stock/features/create_poster/repository/create_poster_repository.dart';
import 'package:poster_stock/features/create_poster/state_holder/create_poster_chosen_movie_state_holder.dart';
import 'package:poster_stock/features/create_poster/state_holder/create_poster_chosen_poster_state_holder.dart';
import 'package:poster_stock/features/create_poster/state_holder/create_poster_images_state_holder.dart';
import 'package:poster_stock/features/create_poster/state_holder/create_poster_search_list.dart';
import 'package:poster_stock/features/create_poster/state_holder/create_poster_search_state_holder.dart';

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
  ),
);

class CreatePosterController {
  final CreatePosterSearchStateHolder createPosterSearchStateHolder;
  final CreatePosterChoseMovieStateHolder createPosterChoseMovieStateHolder;
  final CreatePosterImagesStateHolder createPosterImagesStateHolder;
  final CreatePosterChosenPosterStateHolder createPosterChosenPosterStateHolder;
  final CreatePosterSearchListStateHolder createPosterSearchListStateHolder;
  final CreatePosterRepository createPosterRepository =
      CreatePosterRepository();

  CreatePosterController({
    required this.createPosterSearchStateHolder,
    required this.createPosterChoseMovieStateHolder,
    required this.createPosterImagesStateHolder,
    required this.createPosterChosenPosterStateHolder,
    required this.createPosterSearchListStateHolder,
  });

  void updateSearch(String value) async {
    createPosterChoseMovieStateHolder.updateValue(null);
    createPosterChosenPosterStateHolder.updateValue(null);
    createPosterSearchStateHolder.updateValue(value);
    createPosterSearchListStateHolder.setValue(
      null,
    );
    createPosterSearchListStateHolder.updateValue(
      await createPosterRepository.getSearchMedia(value),
    );
    createPosterImagesStateHolder.setValue([]);
  }

  void chooseMovie((String, String)? movie) {
    createPosterChoseMovieStateHolder.updateValue(movie);
    createPosterChosenPosterStateHolder.updateValue(null);
  }

  void choosePoster((int, String)? poster) {
    createPosterChosenPosterStateHolder.updateValue(poster);
  }
}
