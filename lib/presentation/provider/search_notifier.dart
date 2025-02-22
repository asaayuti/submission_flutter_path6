import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/movie/movie.dart';
import 'package:ditonton/domain/entities/tv_series/tv_series.dart';
import 'package:ditonton/domain/usecases/movie/search_movies.dart';
import 'package:ditonton/domain/usecases/tv_series/search_tv_series.dart';
import 'package:flutter/foundation.dart';

class SearchNotifier extends ChangeNotifier {
  final SearchMovies searchMovies;
  final SearchTvSeries searchTvSeries;

  SearchNotifier({required this.searchMovies, required this.searchTvSeries});

  RequestState _state = RequestState.Empty;
  RequestState get state => _state;

  List<Movie> _movieSearchResult = [];
  List<Movie> get movieSearchResult => _movieSearchResult;

  List<TvSeries> _tvSeriesSearchResult = [];
  List<TvSeries> get tvSeriesSearchResult => _tvSeriesSearchResult;

  String _message = '';
  String get message => _message;

  Future<void> fetchSearchResults(String query) async {
    _state = RequestState.Loading;
    notifyListeners();

    final movieResult = await searchMovies.execute(query);
    final tvSeriesResult = await searchTvSeries.execute(query);

    bool hasError = false;
    String errorMsg = '';

    movieResult.fold(
      (failure) {
        hasError = true;
        errorMsg = failure.message;
      },
      (data) {
        _movieSearchResult = data;
      },
    );

    tvSeriesResult.fold(
      (failure) {
        hasError = true;
        errorMsg = failure.message;
      },
      (data) {
        _tvSeriesSearchResult = data;
      },
    );

    if (hasError) {
      _state = RequestState.Error;
      _message = errorMsg;
    } else {
      _state = RequestState.Loaded;
    }
    notifyListeners();
  }
}
