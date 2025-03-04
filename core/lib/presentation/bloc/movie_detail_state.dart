import 'package:equatable/equatable.dart';
import '../../../domain/entities/movie/movie.dart';
import '../../../domain/entities/movie/movie_detail.dart';

abstract class MovieDetailState extends Equatable {
  const MovieDetailState();

  @override
  List<Object?> get props => [];
}

class MovieDetailEmpty extends MovieDetailState {}

class MovieDetailLoading extends MovieDetailState {}

class MovieDetailHasData extends MovieDetailState {
  final MovieDetail movie;
  final List<Movie> recommendations;
  final bool isAddedToWatchlist;
  final String watchlistMessage;

  const MovieDetailHasData({
    required this.movie,
    required this.recommendations,
    required this.isAddedToWatchlist,
    this.watchlistMessage = '',
  });

  MovieDetailHasData copyWith({
    MovieDetail? movie,
    List<Movie>? recommendations,
    bool? isAddedToWatchlist,
    String? watchlistMessage,
  }) {
    return MovieDetailHasData(
      movie: movie ?? this.movie,
      recommendations: recommendations ?? this.recommendations,
      isAddedToWatchlist: isAddedToWatchlist ?? this.isAddedToWatchlist,
      watchlistMessage: watchlistMessage ?? this.watchlistMessage,
    );
  }

  @override
  List<Object?> get props => [
    movie,
    recommendations,
    isAddedToWatchlist,
    watchlistMessage,
  ];
}

class MovieDetailError extends MovieDetailState {
  final String message;

  const MovieDetailError(this.message);

  @override
  List<Object?> get props => [message];
}
