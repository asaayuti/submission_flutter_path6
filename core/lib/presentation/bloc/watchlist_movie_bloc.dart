import 'package:core/domain/entities/movie/movie.dart';
import 'package:core/domain/usecases/movie/get_watchlist_movies.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'watchlist_movie_event.dart';
part 'watchlist_movie_state.dart';

class WatchlistMovieBloc
    extends Bloc<WatchlistMovieEvent, WatchlistMovieState> {
  final GetWatchlistMovies getWatchlistMovies;
  WatchlistMovieBloc(this.getWatchlistMovies) : super(WatchlistMovieEmpty()) {
    on<FetchWatchlistMovies>((event, emit) async {
      emit(WatchlistMovieLoading());
      final result = await getWatchlistMovies.execute();
      result.fold(
        (failure) => emit(WatchlistMovieError(failure.message)),
        (moviesData) => emit(WatchlistMovieLoaded(moviesData)),
      );
    });
  }
}
