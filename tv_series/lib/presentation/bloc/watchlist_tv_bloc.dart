import 'package:tv_series/domain/entities/tv_series.dart';
import 'package:tv_series/domain/usecases/get_watchlist_tv_series.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'watchlist_tv_event.dart';
part 'watchlist_tv_state.dart';

class WatchlistTvBloc extends Bloc<WatchlistTvEvent, WatchlistTvState> {
  final GetWatchlistTvs getWatchlistTvs;
  WatchlistTvBloc(this.getWatchlistTvs) : super(WatchlistTvEmpty()) {
    on<FetchWatchlistTvs>((event, emit) async {
      emit(WatchlistTvLoading());
      final result = await getWatchlistTvs.execute();
      result.fold(
        (failure) => emit(WatchlistTvError(failure.message)),
        (moviesData) => emit(WatchlistTvLoaded(moviesData)),
      );
    });
  }
}
