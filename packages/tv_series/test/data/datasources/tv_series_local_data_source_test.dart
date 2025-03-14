import 'package:tv_series/data/datasources/tv_series_local_data_source.dart';
import 'package:tv_series/dummy_data/dummy_tv_objects.dart';
import 'package:core/utils/exception.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../helpers/test_helper.mocks.dart';

void main() {
  late TvSeriesLocalDataSourceImpl dataSource;
  late MockDatabaseHelper mockDatabaseHelper;

  setUp(() {
    mockDatabaseHelper = MockDatabaseHelper();
    dataSource = TvSeriesLocalDataSourceImpl(
      databaseHelper: mockDatabaseHelper,
    );
  });

  group('save watchlist', () {
    test(
      'should return success message when insert to database is success',
      () async {
        // arrange
        when(
          mockDatabaseHelper.insertWatchlistTvSeries(tTvSeriesTable),
        ).thenAnswer((_) async => 1);
        // act
        final result = await dataSource.insertWatchlist(tTvSeriesTable);
        // assert
        expect(result, 'Added TV Series to Watchlist');
      },
    );

    test(
      'should throw DatabaseException when insert to database is failed',
      () async {
        // arrange
        when(
          mockDatabaseHelper.insertWatchlistTvSeries(tTvSeriesTable),
        ).thenThrow(Exception());
        // act
        final call = dataSource.insertWatchlist(tTvSeriesTable);
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
          mockDatabaseHelper.removeWatchlistTvSeries(tTvSeriesTable),
        ).thenAnswer((_) async => 1);
        // act
        final result = await dataSource.removeWatchlist(tTvSeriesTable);
        // assert
        expect(result, 'Removed TV Series from Watchlist');
      },
    );

    test(
      'should throw DatabaseException when remove from database is failed',
      () async {
        // arrange
        when(
          mockDatabaseHelper.removeWatchlistTvSeries(tTvSeriesTable),
        ).thenThrow(Exception());
        // act
        final call = dataSource.removeWatchlist(tTvSeriesTable);
        // assert
        expect(() => call, throwsA(isA<DatabaseException>()));
      },
    );
  });

  group('Get Tv Series Detail By Id', () {
    test('should return Tv Series Detail Table when data is found', () async {
      // arrange
      when(
        mockDatabaseHelper.getTvSeriesById(tTvSeriesId),
      ).thenAnswer((_) async => tTvSeriesMap);
      // act
      final result = await dataSource.getTvSeriesById(tTvSeriesId);
      // assert
      expect(result, tTvSeriesTable);
    });

    test('should return null when data is not found', () async {
      // arrange
      when(
        mockDatabaseHelper.getTvSeriesById(tTvSeriesId),
      ).thenAnswer((_) async => null);
      // act
      final result = await dataSource.getTvSeriesById(tTvSeriesId);
      // assert
      expect(result, null);
    });
  });

  group('get watchlist tv series', () {
    test('should return list of TvSeriesTable from database', () async {
      // arrange
      when(
        mockDatabaseHelper.getWatchlistTvSeries(),
      ).thenAnswer((_) async => [tTvSeriesMap]);
      // act
      final result = await dataSource.getWatchlistTvSeries();
      // assert
      expect(result, [tTvSeriesTable]);
    });
  });
}
