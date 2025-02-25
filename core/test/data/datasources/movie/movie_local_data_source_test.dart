import 'package:core/data/datasources/movie/movie_local_data_source.dart';
import 'package:core/utils/exception.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../dummy_data/movie/dummy_objects.dart';
import '../../../helpers/test_helper.mocks.dart';

void main() {
  late MovieLocalDataSourceImpl dataSource;
  late MockDatabaseHelper mockDatabaseHelper;

  setUp(() {
    mockDatabaseHelper = MockDatabaseHelper();
    dataSource = MovieLocalDataSourceImpl(databaseHelper: mockDatabaseHelper);
  });

  group('save watchlist', () {
    test(
      'should return success message when insert to database is success',
      () async {
        // arrange
        when(
          mockDatabaseHelper.insertWatchlist(tMovieTable),
        ).thenAnswer((_) async => 1);
        // act
        final result = await dataSource.insertWatchlist(tMovieTable);
        // assert
        expect(result, 'Added to Watchlist');
      },
    );

    test(
      'should throw DatabaseException when insert to database is failed',
      () async {
        // arrange
        when(
          mockDatabaseHelper.insertWatchlist(tMovieTable),
        ).thenThrow(Exception());
        // act
        final call = dataSource.insertWatchlist(tMovieTable);
        // assert
        expect(() => call, throwsA(isA<DatabaseException>()));
      },
    );
  });

  group('remove watchlist', () {
    test(
      'should return success message when remove from database is success',
      () async {
        // arrange
        when(
          mockDatabaseHelper.removeWatchlist(tMovieTable),
        ).thenAnswer((_) async => 1);
        // act
        final result = await dataSource.removeWatchlist(tMovieTable);
        // assert
        expect(result, 'Removed from Watchlist');
      },
    );

    test(
      'should throw DatabaseException when remove from database is failed',
      () async {
        // arrange
        when(
          mockDatabaseHelper.removeWatchlist(tMovieTable),
        ).thenThrow(Exception());
        // act
        final call = dataSource.removeWatchlist(tMovieTable);
        // assert
        expect(() => call, throwsA(isA<DatabaseException>()));
      },
    );
  });

  group('Get Movie Detail By Id', () {
    test('should return Movie Detail Table when data is found', () async {
      // arrange
      when(
        mockDatabaseHelper.getMovieById(tMovieId),
      ).thenAnswer((_) async => tMovieMap);
      // act
      final result = await dataSource.getMovieById(tMovieId);
      // assert
      expect(result, tMovieTable);
    });

    test('should return null when data is not found', () async {
      // arrange
      when(
        mockDatabaseHelper.getMovieById(tMovieId),
      ).thenAnswer((_) async => null);
      // act
      final result = await dataSource.getMovieById(tMovieId);
      // assert
      expect(result, null);
    });
  });

  group('get watchlist movies', () {
    test('should return list of MovieTable from database', () async {
      // arrange
      when(
        mockDatabaseHelper.getWatchlistMovies(),
      ).thenAnswer((_) async => [tMovieMap]);
      // act
      final result = await dataSource.getWatchlistMovies();
      // assert
      expect(result, [tMovieTable]);
    });
  });
}
