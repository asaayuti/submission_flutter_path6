import 'package:core/domain/entities/movie/movie.dart';
import 'package:core/domain/usecases/movie/get_popular_movies.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'popular_movies_event.dart';
part 'popular_movies_state.dart';

class PopularMoviesBloc extends Bloc<PopularMoviesEvent, PopularMoviesState> {
  final GetPopularMovies getPopularMovies;

  PopularMoviesBloc(this.getPopularMovies) : super(PopularMoviesEmpty()) {
    on<FetchPopularMovies>((event, emit) async {
      emit(PopularMoviesLoading());
      await getPopularMovies.execute().then((result) {
        result.fold(
          (failure) => emit(PopularMoviesError(failure.message)),
          (movies) => emit(PopularMoviesHasData(movies)),
        );
      });
    });
  }
}
