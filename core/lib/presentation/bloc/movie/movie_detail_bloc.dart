import 'package:flutter_bloc/flutter_bloc.dart';

import 'movie_detail_event.dart';
import 'movie_detail_state.dart';
import '../../../../domain/usecases/movie/get_movie_detail.dart';
import '../../../../domain/usecases/movie/get_movie_recommendations.dart';
import '../../../../domain/usecases/movie/get_watchlist_status.dart';
import '../../../../domain/usecases/movie/save_watchlist.dart';
import '../../../../domain/usecases/movie/remove_watchlist.dart';

class MovieDetailBloc extends Bloc<MovieDetailEvent, MovieDetailState> {
  final GetMovieDetail getMovieDetail;
  final GetMovieRecommendations getMovieRecommendations;
  final GetWatchlistStatus getWatchListStatus;
  final SaveWatchlist saveWatchlist;
  final RemoveWatchlist removeWatchlist;

  MovieDetailBloc({
    required this.getMovieDetail,
    required this.getMovieRecommendations,
    required this.getWatchListStatus,
    required this.saveWatchlist,
    required this.removeWatchlist,
  }) : super(MovieDetailEmpty()) {
    on<FetchMovieDetail>(_onFetchMovieDetail);
    on<AddWatchlist>(_onAddWatchlist);
    on<RemoveFromWatchlist>(_onRemoveFromWatchlist);
    on<LoadWatchlistStatus>(_onLoadWatchlistStatus);
  }

  Future<void> _onFetchMovieDetail(
    FetchMovieDetail event,
    Emitter<MovieDetailState> emit,
  ) async {
    emit(MovieDetailLoading());
    final detailResult = await getMovieDetail.execute(event.id);
    final recommendationResult = await getMovieRecommendations.execute(
      event.id,
    );
    final isAdded = await getWatchListStatus.execute(event.id);

    detailResult.fold(
      (failure) => emit(MovieDetailError(failure.message)),
      (movie) => recommendationResult.fold(
        (failure) => emit(MovieDetailError(failure.message)),
        (recoMovies) => emit(
          MovieDetailHasData(
            movie: movie,
            recommendations: recoMovies,
            isAddedToWatchlist: isAdded,
          ),
        ),
      ),
    );
  }

  Future<void> _onAddWatchlist(
    AddWatchlist event,
    Emitter<MovieDetailState> emit,
  ) async {
    if (state is MovieDetailHasData) {
      final currentState = state as MovieDetailHasData;
      final result = await saveWatchlist.execute(event.movie);
      String msg = '';
      result.fold(
        (failure) => msg = failure.message,
        (successMessage) => msg = successMessage,
      );
      final isAdded = await getWatchListStatus.execute(event.movie.id);
      emit(
        currentState.copyWith(
          isAddedToWatchlist: isAdded,
          watchlistMessage: msg,
        ),
      );
    }
  }

  Future<void> _onRemoveFromWatchlist(
    RemoveFromWatchlist event,
    Emitter<MovieDetailState> emit,
  ) async {
    if (state is MovieDetailHasData) {
      final currentState = state as MovieDetailHasData;
      final result = await removeWatchlist.execute(event.movie);
      String msg = '';
      result.fold(
        (failure) => msg = failure.message,
        (successMessage) => msg = successMessage,
      );
      final isAdded = await getWatchListStatus.execute(event.movie.id);
      emit(
        currentState.copyWith(
          isAddedToWatchlist: isAdded,
          watchlistMessage: msg,
        ),
      );
    }
  }

  Future<void> _onLoadWatchlistStatus(
    LoadWatchlistStatus event,
    Emitter<MovieDetailState> emit,
  ) async {
    if (state is MovieDetailHasData) {
      final currentState = state as MovieDetailHasData;
      final isAdded = await getWatchListStatus.execute(event.id);
      emit(currentState.copyWith(isAddedToWatchlist: isAdded));
    }
  }
}
