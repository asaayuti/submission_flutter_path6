import 'dart:io';

import 'package:core/data/repositories/tv_series_repository_impl.dart';
import 'package:core/utils/exception.dart';
import 'package:core/utils/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:core/utils/dummy_data/movies/dummy_objects.dart';
import 'package:core/utils/dummy_data/tv_series/dummy_objects.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late TvSeriesRepositoryImpl repository;
  late MockTvSeriesRemoteDataSource mockRemoteDataSource;
  late MockTvSeriesLocalDataSource mockLocalDataSource;

  setUp(() {
    mockRemoteDataSource = MockTvSeriesRemoteDataSource();
    mockLocalDataSource = MockTvSeriesLocalDataSource();
    repository = TvSeriesRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
    );
  });

  group('Now Playing Tv Series', () {
    test(
      'should return remote data when the call to remote data source is successful',
      () async {
        // arrange
        when(
          mockRemoteDataSource.getNowPlayingTvSeries(),
        ).thenAnswer((_) async => tTvSeriesModelList);
        // act
        final result = await repository.getNowPlayingTvSeries();
        // assert
        verify(mockRemoteDataSource.getNowPlayingTvSeries());
        /* workaround to test List in Right. Issue: https://github.com/spebbe/dartz/issues/80 */
        final resultList = result.getOrElse(() => []);
        expect(resultList, tTvSeriesList);
      },
    );

    test(
      'should return server failure when the call to remote data source is unsuccessful',
      () async {
        // arrange
        when(
          mockRemoteDataSource.getNowPlayingTvSeries(),
        ).thenThrow(ServerException());
        // act
        final result = await repository.getNowPlayingTvSeries();
        // assert
        verify(mockRemoteDataSource.getNowPlayingTvSeries());
        expect(
          result,
          equals(Left(ServerFailure('Failed to fetch data from server'))),
        );
      },
    );

    test(
      'should return connection failure when the device is not connected to internet',
      () async {
        // arrange
        when(
          mockRemoteDataSource.getNowPlayingTvSeries(),
        ).thenThrow(SocketException('Failed to connect to the network'));
        // act
        final result = await repository.getNowPlayingTvSeries();
        // assert
        verify(mockRemoteDataSource.getNowPlayingTvSeries());
        expect(
          result,
          equals(Left(ConnectionFailure('Failed to connect to the network'))),
        );
      },
    );
  });

  group('Popular TvSeries', () {
    test(
      'should return movie list when call to data source is success',
      () async {
        // arrange
        when(
          mockRemoteDataSource.getPopularTvSeries(),
        ).thenAnswer((_) async => tTvSeriesModelList);
        // act
        final result = await repository.getPopularTvSeries();
        // assert
        /* workaround to test List in Right. Issue: https://github.com/spebbe/dartz/issues/80 */
        final resultList = result.getOrElse(() => []);
        expect(resultList, tTvSeriesList);
      },
    );

    test(
      'should return server failure when call to data source is unsuccessful',
      () async {
        // arrange
        when(
          mockRemoteDataSource.getPopularTvSeries(),
        ).thenThrow(ServerException());
        // act
        final result = await repository.getPopularTvSeries();
        // assert
        expect(result, Left(ServerFailure('Failed to fetch data from server')));
      },
    );

    test(
      'should return connection failure when device is not connected to the internet',
      () async {
        // arrange
        when(
          mockRemoteDataSource.getPopularTvSeries(),
        ).thenThrow(SocketException('Failed to connect to the network'));
        // act
        final result = await repository.getPopularTvSeries();
        // assert
        expect(
          result,
          Left(ConnectionFailure('Failed to connect to the network')),
        );
      },
    );
  });

  group('Top Rated TvSeries', () {
    test(
      'should return movie list when call to data source is successful',
      () async {
        // arrange
        when(
          mockRemoteDataSource.getTopRatedTvSeries(),
        ).thenAnswer((_) async => tTvSeriesModelList);
        // act
        final result = await repository.getTopRatedTvSeries();
        // assert
        /* workaround to test List in Right. Issue: https://github.com/spebbe/dartz/issues/80 */
        final resultList = result.getOrElse(() => []);
        expect(resultList, tTvSeriesList);
      },
    );

    test(
      'should return ServerFailure when call to data source is unsuccessful',
      () async {
        // arrange
        when(
          mockRemoteDataSource.getTopRatedTvSeries(),
        ).thenThrow(ServerException());
        // act
        final result = await repository.getTopRatedTvSeries();
        // assert
        expect(result, Left(ServerFailure('Failed to fetch data from server')));
      },
    );

    test(
      'should return ConnectionFailure when device is not connected to the internet',
      () async {
        // arrange
        when(
          mockRemoteDataSource.getTopRatedTvSeries(),
        ).thenThrow(SocketException('Failed to connect to the network'));
        // act
        final result = await repository.getTopRatedTvSeries();
        // assert
        expect(
          result,
          Left(ConnectionFailure('Failed to connect to the network')),
        );
      },
    );
  });

  group('Get TvSeries Detail', () {
    test(
      'should return TvSeries data when the call to remote data source is successful',
      () async {
        // arrange
        when(
          mockRemoteDataSource.getTvSeriesDetail(tTvSeriesId),
        ).thenAnswer((_) async => tTvSeriesDetailResponse);
        // act
        final result = await repository.getTvSeriesDetail(tTvSeriesId);
        // assert
        verify(mockRemoteDataSource.getTvSeriesDetail(tTvSeriesId));
        expect(result, equals(Right(tTvSeriesDetail)));
      },
    );

    test(
      'should return Server Failure when the call to remote data source is unsuccessful',
      () async {
        // arrange
        when(
          mockRemoteDataSource.getTvSeriesDetail(tTvSeriesId),
        ).thenThrow(ServerException());
        // act
        final result = await repository.getTvSeriesDetail(tTvSeriesId);
        // assert
        verify(mockRemoteDataSource.getTvSeriesDetail(tTvSeriesId));
        expect(
          result,
          equals(Left(ServerFailure('Failed to fetch data from server'))),
        );
      },
    );

    test(
      'should return connection failure when the device is not connected to internet',
      () async {
        // arrange
        when(
          mockRemoteDataSource.getTvSeriesDetail(tTvSeriesId),
        ).thenThrow(SocketException('Failed to connect to the network'));
        // act
        final result = await repository.getTvSeriesDetail(tTvSeriesId);
        // assert
        verify(mockRemoteDataSource.getTvSeriesDetail(tTvSeriesId));
        expect(
          result,
          equals(Left(ConnectionFailure('Failed to connect to the network'))),
        );
      },
    );
  });

  group('Get TvSeries Recommendations', () {
    test('should return data (movie list) when the call is successful', () async {
      // arrange
      when(
        mockRemoteDataSource.getTvSeriesRecommendations(tTvSeriesId),
      ).thenAnswer((_) async => tEmptyTvSeriesModelList);
      // act
      final result = await repository.getTvSeriesRecommendations(tTvSeriesId);
      // assert
      verify(mockRemoteDataSource.getTvSeriesRecommendations(tTvSeriesId));
      /* workaround to test List in Right. Issue: https://github.com/spebbe/dartz/issues/80 */
      final resultList = result.getOrElse(() => []);
      expect(resultList, equals(tEmptyTvSeriesModelList));
    });

    test(
      'should return server failure when call to remote data source is unsuccessful',
      () async {
        // arrange
        when(
          mockRemoteDataSource.getTvSeriesRecommendations(tTvSeriesId),
        ).thenThrow(ServerException());
        // act
        final result = await repository.getTvSeriesRecommendations(tTvSeriesId);
        // assertbuild runner
        verify(mockRemoteDataSource.getTvSeriesRecommendations(tTvSeriesId));
        expect(
          result,
          equals(Left(ServerFailure('Failed to fetch data from server'))),
        );
      },
    );

    test(
      'should return connection failure when the device is not connected to the internet',
      () async {
        // arrange
        when(
          mockRemoteDataSource.getTvSeriesRecommendations(tTvSeriesId),
        ).thenThrow(SocketException('Failed to connect to the network'));
        // act
        final result = await repository.getTvSeriesRecommendations(tTvSeriesId);
        // assert
        verify(mockRemoteDataSource.getTvSeriesRecommendations(tTvSeriesId));
        expect(
          result,
          equals(Left(ConnectionFailure('Failed to connect to the network'))),
        );
      },
    );
  });

  group('Seach TvSeries', () {
    test(
      'should return movie list when call to data source is successful',
      () async {
        // arrange
        when(
          mockRemoteDataSource.searchTvSeries(tQuery),
        ).thenAnswer((_) async => tTvSeriesModelList);
        // act
        final result = await repository.searchTvSeries(tQuery);
        // assert
        /* workaround to test List in Right. Issue: https://github.com/spebbe/dartz/issues/80 */
        final resultList = result.getOrElse(() => []);
        expect(resultList, tTvSeriesList);
      },
    );

    test(
      'should return ServerFailure when call to data source is unsuccessful',
      () async {
        // arrange
        when(
          mockRemoteDataSource.searchTvSeries(tQuery),
        ).thenThrow(ServerException());
        // act
        final result = await repository.searchTvSeries(tQuery);
        // assert
        expect(result, Left(ServerFailure('Failed to fetch data from server')));
      },
    );

    test(
      'should return ConnectionFailure when device is not connected to the internet',
      () async {
        // arrange
        when(
          mockRemoteDataSource.searchTvSeries(tQuery),
        ).thenThrow(SocketException('Failed to connect to the network'));
        // act
        final result = await repository.searchTvSeries(tQuery);
        // assert
        expect(
          result,
          Left(ConnectionFailure('Failed to connect to the network')),
        );
      },
    );
  });

  group('save watchlist', () {
    test('should return success message when saving successful', () async {
      // arrange
      when(
        mockLocalDataSource.insertWatchlist(tTvSeriesTable),
      ).thenAnswer((_) async => 'Added TV Series to Watchlist');
      // act
      final result = await repository.saveWatchlist(tTvSeriesDetail);
      // assert
      expect(result, Right('Added TV Series to Watchlist'));
    });

    test('should return DatabaseFailure when saving unsuccessful', () async {
      // arrange
      when(
        mockLocalDataSource.insertWatchlist(tTvSeriesTable),
      ).thenThrow(DatabaseException('Failed to TV Series add watchlist'));
      // act
      final result = await repository.saveWatchlist(tTvSeriesDetail);
      // assert
      expect(
        result,
        Left(DatabaseFailure('Failed to TV Series add watchlist')),
      );
    });
  });

  group('remove watchlist', () {
    test('should return success message when remove successful', () async {
      // arrange
      when(
        mockLocalDataSource.removeWatchlist(tTvSeriesTable),
      ).thenAnswer((_) async => 'Removed TV Series from watchlist');
      // act
      final result = await repository.removeWatchlist(tTvSeriesDetail);
      // assert
      expect(result, Right('Removed TV Series from watchlist'));
    });

    test('should return DatabaseFailure when remove unsuccessful', () async {
      // arrange
      when(
        mockLocalDataSource.removeWatchlist(tTvSeriesTable),
      ).thenThrow(DatabaseException('Failed to TV Series remove watchlist'));
      // act
      final result = await repository.removeWatchlist(tTvSeriesDetail);
      // assert
      expect(
        result,
        Left(DatabaseFailure('Failed to TV Series remove watchlist')),
      );
    });
  });

  group('get watchlist status', () {
    test('should return watch status whether data is found', () async {
      // arrange
      when(
        mockLocalDataSource.getTvSeriesById(tTvSeriesId),
      ).thenAnswer((_) async => null);
      // act
      final result = await repository.isAddedToWatchlist(tTvSeriesId);
      // assert
      expect(result, false);
    });
  });

  group('get watchlist tv series', () {
    test('should return list of Tv Series', () async {
      // arrange
      when(
        mockLocalDataSource.getWatchlistTvSeries(),
      ).thenAnswer((_) async => [tTvSeriesTable]);
      // act
      final result = await repository.getWatchlistTvSeries();
      // assert
      final resultList = result.getOrElse(() => []);
      expect(resultList, [tWatchlistTvSeries]);
    });
  });
}
