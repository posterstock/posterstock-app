import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:poster_stock/features/create_poster/state_holder/create_poster_chosen_movie_state_holder.dart';
import 'package:poster_stock/features/create_poster/state_holder/create_poster_chosen_poster_state_holder.dart';
import 'package:poster_stock/features/create_poster/state_holder/create_poster_images_state_holder.dart';
import 'package:poster_stock/features/create_poster/state_holder/create_poster_search_state_holder.dart';

final createPosterControllerProvider = Provider<CreatePosterController>(
      (ref) =>
      CreatePosterController(
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
          createPosterChosenPosterStateHolderProvider.notifier,),
      ),
);

class CreatePosterController {
  final CreatePosterSearchStateHolder createPosterSearchStateHolder;
  final CreatePosterChoseMovieStateHolder createPosterChoseMovieStateHolder;
  final CreatePosterImagesStateHolder createPosterImagesStateHolder;
  final CreatePosterChosenPosterStateHolder createPosterChosenPosterStateHolder;

  CreatePosterController({
    required this.createPosterSearchStateHolder,
    required this.createPosterChoseMovieStateHolder,
    required this.createPosterImagesStateHolder,
    required this.createPosterChosenPosterStateHolder,
  });

  void updateSearch(String value) {
    createPosterSearchStateHolder.updateValue(value);
    createPosterImagesStateHolder.setValue([]);
    createPosterChoseMovieStateHolder.updateValue(null);
    createPosterChosenPosterStateHolder.updateValue(null);
  }

  void chooseMovie((String, String)? movie) {
    createPosterChoseMovieStateHolder.updateValue(movie);
    createPosterImagesStateHolder.setValue(
      List.generate(
        15,
            (index) =>
        'https://m.media-amazon.com/images/M/MV5BY2EyYWEwZmQtZWU0Yy00M2Y3LThiZTktOTQxZDUxY2ZjOTYwXkEyXkFqcGdeQXVyMTQxNzMzNDI@._V1_.jpg',
      ),
    );
    createPosterChosenPosterStateHolder.updateValue(null);
  }

  void choosePoster((int, String)? poster) {
    createPosterChosenPosterStateHolder.updateValue(poster);
  }
}
