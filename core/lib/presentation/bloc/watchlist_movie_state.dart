part of 'watchlist_movie_bloc.dart';

sealed class WatchlistMovieState extends Equatable {
  const WatchlistMovieState();

  @override
  List<Object> get props => [];
}

final class WatchlistMovieEmpty extends WatchlistMovieState {}

final class WatchlistMovieLoading extends WatchlistMovieState {}

final class WatchlistMovieError extends WatchlistMovieState {
  final String message;

  const WatchlistMovieError(this.message);

  @override
  List<Object> get props => [message];
}

final class WatchlistMovieLoaded extends WatchlistMovieState {
  final List<Movie> movies;

  const WatchlistMovieLoaded(this.movies);

  @override
  List<Object> get props => [movies];
}
