part of 'now_playing_tvs_bloc.dart';

sealed class NowPlayingTvsEvent extends Equatable {
  const NowPlayingTvsEvent();

  @override
  List<Object> get props => [];
}

class FetchNowPlayingTvs extends NowPlayingTvsEvent {}
