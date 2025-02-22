import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/movie/movie.dart';
import 'package:ditonton/domain/usecases/movie/search_movies.dart';
import 'package:ditonton/domain/usecases/tv_series/search_tv_series.dart';
import 'package:ditonton/presentation/provider/search_notifier.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import 'search_notifier_test.mocks.dart';

@GenerateMocks([SearchMovies, SearchTvSeries])
void main() {
  late SearchNotifier provider;
  late MockSearchMovies mockSearchMovies;
  late MockSearchTvSeries mockSearchTvSeries;
  late int listenerCallCount;

  setUp(() {
    listenerCallCount = 0;
    mockSearchMovies = MockSearchMovies();
    mockSearchTvSeries = MockSearchTvSeries();
    provider = SearchNotifier(
      searchMovies: mockSearchMovies,
      searchTvSeries: mockSearchTvSeries,
    )..addListener(() {
        listenerCallCount += 1;
      });
  });

  group('search movies', () {
    test('should change state to loading when usecase is called', () async {
      // arrange
      when(mockSearchMovies.execute(testQuery))
          .thenAnswer((_) async => Right(testMovieList));
      when(mockSearchTvSeries.execute(testQuery))
          .thenAnswer((_) async => Right(testTvSeriesList));
      // act
      provider.fetchSearchResults(testQuery);
      // assert
      expect(provider.state, RequestState.Loading);
    });

    test('should update search result data when data is gotten successfully',
        () async {
      // arrange
      when(mockSearchMovies.execute(testQuery))
          .thenAnswer((_) async => Right(testMovieList));
      when(mockSearchTvSeries.execute(testQuery))
          .thenAnswer((_) async => Right(testTvSeriesList));
      // act
      await provider.fetchSearchResults(testQuery);
      // assert
      expect(provider.state, RequestState.Loaded);
      expect(provider.movieSearchResult, testMovieList);
      expect(provider.tvSeriesSearchResult, testTvSeriesList);
      expect(listenerCallCount, 2);
    });

    test('should return error when data is unsuccessful', () async {
      // arrange
      when(mockSearchMovies.execute(testQuery))
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      when(mockSearchTvSeries.execute(testQuery))
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      // act
      await provider.fetchSearchResults(testQuery);
      // assert
      expect(provider.state, RequestState.Error);
      expect(provider.message, 'Server Failure');
      expect(listenerCallCount, 2);
    });
  });
}
