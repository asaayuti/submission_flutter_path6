part of 'now_playing_tvs_bloc.dart';

sealed class NowPlayingTvsState extends Equatable {
  const NowPlayingTvsState();

  @override
  List<Object> get props => [];
}

class NowPlayingTvsEmpty extends NowPlayingTvsState {}

class NowPlayingTvsLoading extends NowPlayingTvsState {}

class NowPlayingTvsHasData extends NowPlayingTvsState {
  final List<TvSeries> tvSeries;

  const NowPlayingTvsHasData(this.tvSeries);

  @override
  List<Object> get props => [tvSeries];
}

class NowPlayingTvsError extends NowPlayingTvsState {
  final String message;

  const NowPlayingTvsError(this.message);

  @override
  List<Object> get props => [message];
}
