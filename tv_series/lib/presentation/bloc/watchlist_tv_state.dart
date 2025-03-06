part of 'watchlist_tv_bloc.dart';

sealed class WatchlistTvState extends Equatable {
  const WatchlistTvState();

  @override
  List<Object> get props => [];
}

final class WatchlistTvEmpty extends WatchlistTvState {}

final class WatchlistTvLoading extends WatchlistTvState {}

final class WatchlistTvError extends WatchlistTvState {
  final String message;

  const WatchlistTvError(this.message);

  @override
  List<Object> get props => [message];
}

final class WatchlistTvLoaded extends WatchlistTvState {
  final List<TvSeries> tvs;

  const WatchlistTvLoaded(this.tvs);

  @override
  List<Object> get props => [tvs];
}
