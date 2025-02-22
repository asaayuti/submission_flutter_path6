import 'package:ditonton/data/datasources/db/database_helper.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ditonton/data/models/movie/movie_table.dart';
import 'package:ditonton/data/models/tv_series/tv_series_table.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  late DatabaseHelper dbHelper;
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;

  setUp(() async {
    dbHelper = DatabaseHelper();
    final db = await dbHelper.database;
    await db!.rawDelete('DELETE FROM watchlist');
    await db.rawDelete('DELETE FROM watchlist_tv_series');
  });

  group('Movie Watchlist Tests', () {
    test('insert and get movie by id', () async {
      final movie = MovieTable(
        id: 1,
        title: 'Test Movie',
        overview: 'Test Overview',
        posterPath: '/test.jpg',
      );
      await dbHelper.insertWatchlist(movie);

      final result = await dbHelper.getMovieById(1);
      expect(result, isNotNull);
      expect(result!['title'], equals('Test Movie'));
    });

    test('remove movie from watchlist', () async {
      final movie = MovieTable(
        id: 2,
        title: 'Test Movie 2',
        overview: 'Test Overview 2',
        posterPath: '/test2.jpg',
      );
      await dbHelper.insertWatchlist(movie);
      await dbHelper.removeWatchlist(movie);

      final result = await dbHelper.getMovieById(2);
      expect(result, isNull);
    });

    test('get watchlist movies list', () async {
      final movie1 = MovieTable(
        id: 3,
        title: 'Movie 3',
        overview: 'Overview 3',
        posterPath: '/3.jpg',
      );
      final movie2 = MovieTable(
        id: 4,
        title: 'Movie 4',
        overview: 'Overview 4',
        posterPath: '/4.jpg',
      );
      await dbHelper.insertWatchlist(movie1);
      await dbHelper.insertWatchlist(movie2);

      final list = await dbHelper.getWatchlistMovies();
      expect(list.where((movie) => movie['id'] == 3).isNotEmpty, isTrue);
      expect(list.where((movie) => movie['id'] == 4).isNotEmpty, isTrue);
    });
  });

  group('TV Series Watchlist Tests', () {
    test('insert and get tv series by id', () async {
      final tvSeries = TvSeriesTable(
        id: 1,
        name: 'Test TV Series',
        overview: 'Test Overview',
        posterPath: '/testtv.jpg',
      );
      await dbHelper.insertWatchlistTvSeries(tvSeries);

      final result = await dbHelper.getTvSeriesById(1);
      expect(result, isNotNull);
      expect(result!['name'], equals('Test TV Series'));
    });

    test('remove tv series from watchlist', () async {
      final tvSeries = TvSeriesTable(
        id: 2,
        name: 'Test TV Series 2',
        overview: 'Test Overview 2',
        posterPath: '/testtv2.jpg',
      );
      await dbHelper.insertWatchlistTvSeries(tvSeries);
      await dbHelper.removeWatchlistTvSeries(tvSeries);

      final result = await dbHelper.getTvSeriesById(2);
      expect(result, isNull);
    });

    test('get watchlist tv series list', () async {
      final tvSeries1 = TvSeriesTable(
        id: 3,
        name: 'TV Series 3',
        overview: 'Overview 3',
        posterPath: '/3.jpg',
      );
      final tvSeries2 = TvSeriesTable(
        id: 4,
        name: 'TV Series 4',
        overview: 'Overview 4',
        posterPath: '/4.jpg',
      );
      await dbHelper.insertWatchlistTvSeries(tvSeries1);
      await dbHelper.insertWatchlistTvSeries(tvSeries2);

      final list = await dbHelper.getWatchlistTvSeries();
      expect(list.where((series) => series['id'] == 3).isNotEmpty, isTrue);
      expect(list.where((series) => series['id'] == 4).isNotEmpty, isTrue);
    });
  });
}
