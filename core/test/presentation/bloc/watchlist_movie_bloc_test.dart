import 'package:bloc_test/bloc_test.dart';
import 'package:core/domain/usecases/movie/get_watchlist_movies.dart';
import 'package:core/presentation/bloc/watchlist_movie_bloc.dart';
import 'package:core/utils/dummy_data/dummy_movies.dart';
import 'package:core/utils/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'watchlist_movie_bloc_test.mocks.dart';

@GenerateMocks([GetWatchlistMovies])
void main() {
  late WatchlistMovieBloc bloc;
  late MockGetWatchlistMovies mockGetWatchlistMovies;

  setUp(() {
    mockGetWatchlistMovies = MockGetWatchlistMovies();
    bloc = WatchlistMovieBloc(mockGetWatchlistMovies);
  });

  test('initial state should be empty', () {
    expect(bloc.state, WatchlistMovieEmpty());
  });

  blocTest<WatchlistMovieBloc, WatchlistMovieState>(
    'emits [WatchlistMovieLoading(), WatchlistMoviesLoaded()] when FetchWatchlistMovies() is success.',
    build: () {
      when(
        mockGetWatchlistMovies.execute(),
      ).thenAnswer((_) async => Right(tMovieList));
      return bloc;
    },
    act: (bloc) => bloc.add(FetchWatchlistMovies()),
    expect: () => [WatchlistMovieLoading(), WatchlistMovieLoaded(tMovieList)],
    verify: (_) {
      verify(mockGetWatchlistMovies.execute());
    },
  );

  blocTest<WatchlistMovieBloc, WatchlistMovieState>(
    'emits [WatchlistMovieLoading(), WatchlistMovieError()] when FetchWatchlistMovies() is unsuccessful.',
    build: () {
      when(
        mockGetWatchlistMovies.execute(),
      ).thenAnswer((_) async => Left(DatabaseFailure('Can\'t get data')));
      return bloc;
    },
    act: (bloc) => bloc.add(FetchWatchlistMovies()),
    expect:
        () => [WatchlistMovieLoading(), WatchlistMovieError('Can\'t get data')],
    verify: (_) {
      verify(mockGetWatchlistMovies.execute());
    },
  );
}
