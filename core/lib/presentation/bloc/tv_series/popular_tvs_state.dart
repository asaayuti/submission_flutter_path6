part of 'popular_tvs_bloc.dart';

sealed class PopularTvsState extends Equatable {
  const PopularTvsState();

  @override
  List<Object> get props => [];
}

class PopularTvsEmpty extends PopularTvsState {}

class PopularTvsLoading extends PopularTvsState {}

class PopularTvsHasData extends PopularTvsState {
  final List<TvSeries> tvSeries;

  const PopularTvsHasData(this.tvSeries);

  @override
  List<Object> get props => [tvSeries];
}

class PopularTvsError extends PopularTvsState {
  final String message;

  const PopularTvsError(this.message);

  @override
  List<Object> get props => [message];
}
