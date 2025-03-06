import 'package:core/domain/usecases/tv_series/get_tv_detail.dart';
import 'package:core/domain/usecases/tv_series/get_tv_recommendations.dart';
import 'package:core/domain/usecases/tv_series/get_watchlist_status_tv_series.dart';
import 'package:core/domain/usecases/tv_series/remove_watchlist_tv.dart';
import 'package:core/domain/usecases/tv_series/save_watchlist_tv_series.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'tv_detail_event.dart';
import 'tv_detail_state.dart';

class TvDetailBloc extends Bloc<TvDetailEvent, TvDetailState> {
  final GetTvDetail getTvDetail;
  final GetTvRecommendations getTvRecommendations;
  final GetWatchlistStatusTv getWatchListStatus;
  final SaveWatchlistTv saveWatchlist;
  final RemoveWatchlistTv removeWatchlist;

  TvDetailBloc({
    required this.getTvDetail,
    required this.getTvRecommendations,
    required this.getWatchListStatus,
    required this.saveWatchlist,
    required this.removeWatchlist,
  }) : super(TvDetailEmpty()) {
    on<FetchTvDetail>(_onFetchTvDetail);
    on<AddWatchlist>(_onAddWatchlist);
    on<RemoveFromWatchlist>(_onRemoveFromWatchlist);
    on<LoadWatchlistStatus>(_onLoadWatchlistStatus);
  }

  Future<void> _onFetchTvDetail(
    FetchTvDetail event,
    Emitter<TvDetailState> emit,
  ) async {
    emit(TvDetailLoading());
    final detailResult = await getTvDetail.execute(event.id);
    final recommendationResult = await getTvRecommendations.execute(event.id);
    final isAdded = await getWatchListStatus.execute(event.id);

    detailResult.fold(
      (failure) => emit(TvDetailError(failure.message)),
      (tvSeries) => recommendationResult.fold(
        (failure) => emit(TvDetailError(failure.message)),
        (recoTvs) => emit(
          TvDetailHasData(
            tvSeries: tvSeries,
            recommendations: recoTvs,
            isAddedToWatchlist: isAdded,
          ),
        ),
      ),
    );
  }

  Future<void> _onAddWatchlist(
    AddWatchlist event,
    Emitter<TvDetailState> emit,
  ) async {
    if (state is TvDetailHasData) {
      final currentState = state as TvDetailHasData;
      final result = await saveWatchlist.execute(event.tvSeries);
      String msg = '';
      result.fold(
        (failure) => msg = failure.message,
        (successMessage) => msg = successMessage,
      );
      final isAdded = await getWatchListStatus.execute(event.tvSeries.id);
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
    Emitter<TvDetailState> emit,
  ) async {
    if (state is TvDetailHasData) {
      final currentState = state as TvDetailHasData;
      final result = await removeWatchlist.execute(event.tvSeries);
      String msg = '';
      result.fold(
        (failure) => msg = failure.message,
        (successMessage) => msg = successMessage,
      );
      final isAdded = await getWatchListStatus.execute(event.tvSeries.id);
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
    Emitter<TvDetailState> emit,
  ) async {
    if (state is TvDetailHasData) {
      final currentState = state as TvDetailHasData;
      final isAdded = await getWatchListStatus.execute(event.id);
      emit(currentState.copyWith(isAddedToWatchlist: isAdded));
    }
  }
}
