import 'package:core/data/datasources/db/database_helper.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:movies/data/models/movie_table.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:tv_series/data/models/tv_series_table.dart';

import 'database_helper_test.mocks.dart';

@GenerateMocks([DatabaseHelper])
void main() {
  late MockDatabaseHelper databaseHelper;

  setUpAll(() {
    sqfliteFfiInit();
  });

  setUp(() {
    databaseHelper = MockDatabaseHelper();
  });

  group('Movie Test', () {
    final testMovie = MovieTable(
      id: 1,
      title: "Test Movie",
      overview: "Overview",
      posterPath: "/path.jpg",
    );

    test('insert movie to watchlist', () async {
      when(databaseHelper.insertWatchlist(any)).thenAnswer((_) async => 1);

      final result = await databaseHelper.insertWatchlist(testMovie);

      expect(result, 1);
      verify(databaseHelper.insertWatchlist(testMovie)).called(1);
    });

    test('remove movie from watchlist', () async {
      when(databaseHelper.removeWatchlist(any)).thenAnswer((_) async => 1);

      final result = await databaseHelper.removeWatchlist(testMovie);

      expect(result, 1);
      verify(databaseHelper.removeWatchlist(testMovie)).called(1);
    });

    test('get movie by id', () async {
      when(
        databaseHelper.getMovieById(any),
      ).thenAnswer((_) async => testMovie.toJson());

      final movie = await databaseHelper.getMovieById(1);

      expect(movie, isNotNull);
      expect(movie!['title'], "Test Movie");
      verify(databaseHelper.getMovieById(1)).called(1);
    });

    test('get watchlist movies', () async {
      when(
        databaseHelper.getWatchlistMovies(),
      ).thenAnswer((_) async => [testMovie.toJson()]);

      final result = await databaseHelper.getWatchlistMovies();

      expect(result, isNotEmpty);
      expect(result.length, 1);
      verify(databaseHelper.getWatchlistMovies()).called(1);
    });
  });

  group('TV Series Test', () {
    final testTvSeries = TvSeriesTable(
      id: 100,
      name: "Test TV Series",
      overview: "TV Series Overview",
      posterPath: "/tv_series_path.jpg",
    );

    test('insert TV series to watchlist', () async {
      when(
        databaseHelper.insertWatchlistTvSeries(any),
      ).thenAnswer((_) async => 1);

      final result = await databaseHelper.insertWatchlistTvSeries(testTvSeries);

      expect(result, 1);
      verify(databaseHelper.insertWatchlistTvSeries(testTvSeries)).called(1);
    });

    test('remove TV series from watchlist', () async {
      when(
        databaseHelper.removeWatchlistTvSeries(any),
      ).thenAnswer((_) async => 1);

      final result = await databaseHelper.removeWatchlistTvSeries(testTvSeries);

      expect(result, 1);
      verify(databaseHelper.removeWatchlistTvSeries(testTvSeries)).called(1);
    });

    test('get TV series by id', () async {
      when(
        databaseHelper.getTvSeriesById(any),
      ).thenAnswer((_) async => testTvSeries.toJson());

      final tvSeries = await databaseHelper.getTvSeriesById(100);

      expect(tvSeries, isNotNull);
      expect(tvSeries!['name'], "Test TV Series");
      verify(databaseHelper.getTvSeriesById(100)).called(1);
    });

    test('get watchlist TV series', () async {
      when(
        databaseHelper.getWatchlistTvSeries(),
      ).thenAnswer((_) async => [testTvSeries.toJson()]);

      final result = await databaseHelper.getWatchlistTvSeries();

      expect(result, isNotEmpty);
      expect(result.length, 1);
      verify(databaseHelper.getWatchlistTvSeries()).called(1);
    });
  });
}
