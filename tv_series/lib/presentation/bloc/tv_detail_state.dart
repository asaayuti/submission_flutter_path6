import 'package:tv_series/domain/entities/tv_series.dart';
import 'package:tv_series/domain/entities/tv_series_detail.dart';
import 'package:equatable/equatable.dart';

abstract class TvDetailState extends Equatable {
  const TvDetailState();

  @override
  List<Object?> get props => [];
}

class TvDetailEmpty extends TvDetailState {}

class TvDetailLoading extends TvDetailState {}

class TvDetailHasData extends TvDetailState {
  final TvSeriesDetail tvSeries;
  final List<TvSeries> recommendations;
  final bool isAddedToWatchlist;
  final String watchlistMessage;

  const TvDetailHasData({
    required this.tvSeries,
    required this.recommendations,
    required this.isAddedToWatchlist,
    this.watchlistMessage = '',
  });

  TvDetailHasData copyWith({
    TvSeriesDetail? tvSeries,
    List<TvSeries>? recommendations,
    bool? isAddedToWatchlist,
    String? watchlistMessage,
  }) {
    return TvDetailHasData(
      tvSeries: tvSeries ?? this.tvSeries,
      recommendations: recommendations ?? this.recommendations,
      isAddedToWatchlist: isAddedToWatchlist ?? this.isAddedToWatchlist,
      watchlistMessage: watchlistMessage ?? this.watchlistMessage,
    );
  }

  @override
  List<Object?> get props => [
    tvSeries,
    recommendations,
    isAddedToWatchlist,
    watchlistMessage,
  ];
}

class TvDetailError extends TvDetailState {
  final String message;

  const TvDetailError(this.message);

  @override
  List<Object?> get props => [message];
}
