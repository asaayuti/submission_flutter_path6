import 'package:core/domain/entities/tv_series/tv_series.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies/domain/entities/movie.dart';
import 'package:rxdart/rxdart.dart';
import 'package:search/domain/usecase/search_movies.dart';
import 'package:search/domain/usecase/search_tv_series.dart';

part 'search_event.dart';
part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final SearchMovies _searchMovies;
  final SearchTvSeries _searchTvSeries;

  SearchBloc(this._searchMovies, this._searchTvSeries) : super(SearchEmpty()) {
    on<OnQueryChanged>((event, emit) async {
      final query = event.query;
      emit(SearchLoading());

      final movieResult = await _searchMovies.execute(query);
      final tvResult = await _searchTvSeries.execute(query);

      movieResult.fold(
        (failure) => emit(SearchError(failure.message)),
        (movies) => tvResult.fold(
          (failure) => emit(SearchError(failure.message)),
          (tvShows) => emit(SearchHasData(movies, tvShows)),
        ),
      );
    }, transformer: debounce(const Duration(milliseconds: 500)));
  }

  EventTransformer<T> debounce<T>(Duration duration) {
    return (events, mapper) => events.debounceTime(duration).flatMap(mapper);
  }
}
