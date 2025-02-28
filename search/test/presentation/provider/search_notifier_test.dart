import 'package:core/utils/failure.dart';
import 'package:core/utils/state_enum.dart';
import 'package:dartz/dartz.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:search/domain/usecase/search_movies.dart';
import 'package:search/domain/usecase/search_tv_series.dart';
import 'package:search/presentation/provider/search_notifier.dart';

import '../../../../core/test/dummy_data/movie/dummy_objects.dart';
import '../../../../core/test/dummy_data/tv_series/dummy_objects.dart';
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
      when(
        mockSearchMovies.execute(tQuery),
      ).thenAnswer((_) async => Right(tMovieList));
      when(
        mockSearchTvSeries.execute(tQuery),
      ).thenAnswer((_) async => Right(tTvSeriesList));
      // act
      provider.fetchSearchResults(tQuery);
      // assert
      expect(provider.state, RequestState.loading);
    });

    test(
      'should update search result data when data is gotten successfully',
      () async {
        // arrange
        when(
          mockSearchMovies.execute(tQuery),
        ).thenAnswer((_) async => Right(tMovieList));
        when(
          mockSearchTvSeries.execute(tQuery),
        ).thenAnswer((_) async => Right(tTvSeriesList));
        // act
        await provider.fetchSearchResults(tQuery);
        // assert
        expect(provider.state, RequestState.loaded);
        expect(provider.movieSearchResult, tMovieList);
        expect(provider.tvSeriesSearchResult, tTvSeriesList);
        expect(listenerCallCount, 2);
      },
    );

    test('should return error when data is unsuccessful', () async {
      // arrange
      when(
        mockSearchMovies.execute(tQuery),
      ).thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      when(
        mockSearchTvSeries.execute(tQuery),
      ).thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      // act
      await provider.fetchSearchResults(tQuery);
      // assert
      expect(provider.state, RequestState.error);
      expect(provider.message, 'Server Failure');
      expect(listenerCallCount, 2);
    });
  });
}
