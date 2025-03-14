import 'dart:io';

import 'package:core/utils/exception.dart';
import 'package:core/utils/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:movies/data/repositories/movie_repository_impl.dart';
import 'package:movies/dummy_data/dummy_movie_objects.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late MovieRepositoryImpl repository;
  late MockMovieRemoteDataSource mockRemoteDataSource;
  late MockMovieLocalDataSource mockLocalDataSource;

  setUp(() {
    mockRemoteDataSource = MockMovieRemoteDataSource();
    mockLocalDataSource = MockMovieLocalDataSource();
    repository = MovieRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
    );
  });

  group('Now Playing Movies', () {
    test(
      'should return remote data when the call to remote data source is successful',
      () async {
        // arrange
        when(
          mockRemoteDataSource.getNowPlayingMovies(),
        ).thenAnswer((_) async => tMovieModelList);
        // act
        final result = await repository.getNowPlayingMovies();
        // assert
        verify(mockRemoteDataSource.getNowPlayingMovies());
        /* workaround to test List in Right. Issue: https://github.com/spebbe/dartz/issues/80 */
        final resultList = result.getOrElse(() => []);
        expect(resultList, tMovieList);
      },
    );

    test(
      'should return server failure when the call to remote data source is unsuccessful',
      () async {
        // arrange
        when(
          mockRemoteDataSource.getNowPlayingMovies(),
        ).thenThrow(ServerException());
        // act
        final result = await repository.getNowPlayingMovies();
        // assert
        verify(mockRemoteDataSource.getNowPlayingMovies());
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
          mockRemoteDataSource.getNowPlayingMovies(),
        ).thenThrow(SocketException('Failed to connect to the network'));
        // act
        final result = await repository.getNowPlayingMovies();
        // assert
        verify(mockRemoteDataSource.getNowPlayingMovies());
        expect(
          result,
          equals(Left(ConnectionFailure('Failed to connect to the network'))),
        );
      },
    );
  });

  group('Popular Movies', () {
    test(
      'should return movie list when call to data source is success',
      () async {
        // arrange
        when(
          mockRemoteDataSource.getPopularMovies(),
        ).thenAnswer((_) async => tMovieModelList);
        // act
        final result = await repository.getPopularMovies();
        // assert
        /* workaround to test List in Right. Issue: https://github.com/spebbe/dartz/issues/80 */
        final resultList = result.getOrElse(() => []);
        expect(resultList, tMovieList);
      },
    );

    test(
      'should return server failure when call to data source is unsuccessful',
      () async {
        // arrange
        when(
          mockRemoteDataSource.getPopularMovies(),
        ).thenThrow(ServerException());
        // act
        final result = await repository.getPopularMovies();
        // assert
        expect(result, Left(ServerFailure('Failed to fetch data from server')));
      },
    );

    test(
      'should return connection failure when device is not connected to the internet',
      () async {
        // arrange
        when(
          mockRemoteDataSource.getPopularMovies(),
        ).thenThrow(SocketException('Failed to connect to the network'));
        // act
        final result = await repository.getPopularMovies();
        // assert
        expect(
          result,
          Left(ConnectionFailure('Failed to connect to the network')),
        );
      },
    );
  });

  group('Top Rated Movies', () {
    test(
      'should return movie list when call to data source is successful',
      () async {
        // arrange
        when(
          mockRemoteDataSource.getTopRatedMovies(),
        ).thenAnswer((_) async => tMovieModelList);
        // act
        final result = await repository.getTopRatedMovies();
        // assert
        /* workaround to test List in Right. Issue: https://github.com/spebbe/dartz/issues/80 */
        final resultList = result.getOrElse(() => []);
        expect(resultList, tMovieList);
      },
    );

    test(
      'should return ServerFailure when call to data source is unsuccessful',
      () async {
        // arrange
        when(
          mockRemoteDataSource.getTopRatedMovies(),
        ).thenThrow(ServerException());
        // act
        final result = await repository.getTopRatedMovies();
        // assert
        expect(result, Left(ServerFailure('Failed to fetch data from server')));
      },
    );

    test(
      'should return ConnectionFailure when device is not connected to the internet',
      () async {
        // arrange
        when(
          mockRemoteDataSource.getTopRatedMovies(),
        ).thenThrow(SocketException('Failed to connect to the network'));
        // act
        final result = await repository.getTopRatedMovies();
        // assert
        expect(
          result,
          Left(ConnectionFailure('Failed to connect to the network')),
        );
      },
    );
  });

  group('Get Movie Detail', () {
    test(
      'should return Movie data when the call to remote data source is successful',
      () async {
        // arrange
        when(
          mockRemoteDataSource.getMovieDetail(tMovieId),
        ).thenAnswer((_) async => tMovieDetailResponse);
        // act
        final result = await repository.getMovieDetail(tMovieId);
        // assert
        verify(mockRemoteDataSource.getMovieDetail(tMovieId));
        expect(result, equals(Right(tMovieDetail)));
      },
    );

    test(
      'should return Server Failure when the call to remote data source is unsuccessful',
      () async {
        // arrange
        when(
          mockRemoteDataSource.getMovieDetail(tMovieId),
        ).thenThrow(ServerException());
        // act
        final result = await repository.getMovieDetail(tMovieId);
        // assert
        verify(mockRemoteDataSource.getMovieDetail(tMovieId));
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
          mockRemoteDataSource.getMovieDetail(tMovieId),
        ).thenThrow(SocketException('Failed to connect to the network'));
        // act
        final result = await repository.getMovieDetail(tMovieId);
        // assert
        verify(mockRemoteDataSource.getMovieDetail(tMovieId));
        expect(
          result,
          equals(Left(ConnectionFailure('Failed to connect to the network'))),
        );
      },
    );
  });

  group('Get Movie Recommendations', () {
    test('should return data (movie list) when the call is successful', () async {
      // arrange
      when(
        mockRemoteDataSource.getMovieRecommendations(tMovieId),
      ).thenAnswer((_) async => tEmptyMovieModelList);
      // act
      final result = await repository.getMovieRecommendations(tMovieId);
      // assert
      verify(mockRemoteDataSource.getMovieRecommendations(tMovieId));
      /* workaround to test List in Right. Issue: https://github.com/spebbe/dartz/issues/80 */
      final resultList = result.getOrElse(() => []);
      expect(resultList, equals(tEmptyMovieModelList));
    });

    test(
      'should return server failure when call to remote data source is unsuccessful',
      () async {
        // arrange
        when(
          mockRemoteDataSource.getMovieRecommendations(tMovieId),
        ).thenThrow(ServerException());
        // act
        final result = await repository.getMovieRecommendations(tMovieId);
        // assertbuild runner
        verify(mockRemoteDataSource.getMovieRecommendations(tMovieId));
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
          mockRemoteDataSource.getMovieRecommendations(tMovieId),
        ).thenThrow(SocketException('Failed to connect to the network'));
        // act
        final result = await repository.getMovieRecommendations(tMovieId);
        // assert
        verify(mockRemoteDataSource.getMovieRecommendations(tMovieId));
        expect(
          result,
          equals(Left(ConnectionFailure('Failed to connect to the network'))),
        );
      },
    );
  });

  group('Seach Movies', () {
    test(
      'should return movie list when call to data source is successful',
      () async {
        // arrange
        when(
          mockRemoteDataSource.searchMovies(tQuery),
        ).thenAnswer((_) async => tMovieModelList);
        // act
        final result = await repository.searchMovies(tQuery);
        // assert
        /* workaround to test List in Right. Issue: https://github.com/spebbe/dartz/issues/80 */
        final resultList = result.getOrElse(() => []);
        expect(resultList, tMovieList);
      },
    );

    test(
      'should return ServerFailure when call to data source is unsuccessful',
      () async {
        // arrange
        when(
          mockRemoteDataSource.searchMovies(tQuery),
        ).thenThrow(ServerException());
        // act
        final result = await repository.searchMovies(tQuery);
        // assert
        expect(result, Left(ServerFailure('Failed to fetch data from server')));
      },
    );

    test(
      'should return ConnectionFailure when device is not connected to the internet',
      () async {
        // arrange
        when(
          mockRemoteDataSource.searchMovies(tQuery),
        ).thenThrow(SocketException('Failed to connect to the network'));
        // act
        final result = await repository.searchMovies(tQuery);
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
        mockLocalDataSource.insertWatchlist(tMovieTable),
      ).thenAnswer((_) async => 'Added to Watchlist');
      // act
      final result = await repository.saveWatchlist(tMovieDetail);
      // assert
      expect(result, Right('Added to Watchlist'));
    });

    test('should return DatabaseFailure when saving unsuccessful', () async {
      // arrange
      when(
        mockLocalDataSource.insertWatchlist(tMovieTable),
      ).thenThrow(DatabaseException('Failed to add watchlist'));
      // act
      final result = await repository.saveWatchlist(tMovieDetail);
      // assert
      expect(result, Left(DatabaseFailure('Failed to add watchlist')));
    });
  });

  group('remove watchlist', () {
    test('should return success message when remove successful', () async {
      // arrange
      when(
        mockLocalDataSource.removeWatchlist(tMovieTable),
      ).thenAnswer((_) async => 'Removed from watchlist');
      // act
      final result = await repository.removeWatchlist(tMovieDetail);
      // assert
      expect(result, Right('Removed from watchlist'));
    });

    test('should return DatabaseFailure when remove unsuccessful', () async {
      // arrange
      when(
        mockLocalDataSource.removeWatchlist(tMovieTable),
      ).thenThrow(DatabaseException('Failed to remove watchlist'));
      // act
      final result = await repository.removeWatchlist(tMovieDetail);
      // assert
      expect(result, Left(DatabaseFailure('Failed to remove watchlist')));
    });
  });

  group('get watchlist status', () {
    test('should return watch status whether data is found', () async {
      // arrange
      when(
        mockLocalDataSource.getMovieById(tMovieId),
      ).thenAnswer((_) async => null);
      // act
      final result = await repository.isAddedToWatchlist(tMovieId);
      // assert
      expect(result, false);
    });
  });

  group('get watchlist movies', () {
    test('should return list of Movies', () async {
      // arrange
      when(
        mockLocalDataSource.getWatchlistMovies(),
      ).thenAnswer((_) async => [tMovieTable]);
      // act
      final result = await repository.getWatchlistMovies();
      // assert
      final resultList = result.getOrElse(() => []);
      expect(resultList, [tWatchlistMovie]);
    });
  });
}
