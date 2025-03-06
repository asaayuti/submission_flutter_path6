import 'package:core/domain/entities/tv_series/tv_series_detail.dart';
import 'package:equatable/equatable.dart';

abstract class TvDetailEvent extends Equatable {
  const TvDetailEvent();

  @override
  List<Object?> get props => [];
}

class FetchTvDetail extends TvDetailEvent {
  final int id;

  const FetchTvDetail(this.id);

  @override
  List<Object?> get props => [id];
}

class AddWatchlist extends TvDetailEvent {
  final TvSeriesDetail tvSeries;

  const AddWatchlist(this.tvSeries);

  @override
  List<Object?> get props => [tvSeries];
}

class RemoveFromWatchlist extends TvDetailEvent {
  final TvSeriesDetail tvSeries;

  const RemoveFromWatchlist(this.tvSeries);

  @override
  List<Object?> get props => [tvSeries];
}

class LoadWatchlistStatus extends TvDetailEvent {
  final int id;

  const LoadWatchlistStatus(this.id);

  @override
  List<Object?> get props => [id];
}
