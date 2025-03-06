part of 'top_rated_tvs_bloc.dart';

sealed class TopRatedTvsEvent extends Equatable {
  const TopRatedTvsEvent();

  @override
  List<Object> get props => [];
}

final class FetchTopRatedTvs extends TopRatedTvsEvent {}
