import 'package:bloc_test/bloc_test.dart';
import 'package:movies/domain/usecases/get_now_playing_movies.dart';
import 'package:movies/presentation/bloc/now_playing_movies_bloc.dart';
import 'package:core/utils/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:movies/dummy_data/dummy_movie_objects.dart';

import 'now_playing_movies_bloc_test.mocks.dart';

@GenerateMocks([GetNowPlayingMovies])
void main() {
  late NowPlayingMoviesBloc bloc;
  late MockGetNowPlayingMovies mockGetNowPlayingMovies;

  setUp(() {
    mockGetNowPlayingMovies = MockGetNowPlayingMovies();
    bloc = NowPlayingMoviesBloc(mockGetNowPlayingMovies);
  });

  test('initial state is NowPlayingMoviesInitial', () {
    expect(bloc.state, equals(NowPlayingMoviesEmpty()));
  });

  blocTest<NowPlayingMoviesBloc, NowPlayingMoviesState>(
    'emits [Loading, HasData] when FetchNowPlayingMovies() is success.',
    build: () {
      when(
        mockGetNowPlayingMovies.execute(),
      ).thenAnswer((_) async => Right(tMovieList));
      return bloc;
    },
    act: (bloc) => bloc.add(FetchNowPlayingMovies()),
    expect:
        () => [NowPlayingMoviesLoading(), NowPlayingMoviesHasData(tMovieList)],
    verify: (_) {
      verify(mockGetNowPlayingMovies.execute());
    },
  );

  blocTest<NowPlayingMoviesBloc, NowPlayingMoviesState>(
    'emits [Loading, Error] when FetchNowPlayingMovies() is failed.',
    build: () {
      when(
        mockGetNowPlayingMovies.execute(),
      ).thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      return bloc;
    },
    act: (bloc) => bloc.add(FetchNowPlayingMovies()),
    expect:
        () => [
          NowPlayingMoviesLoading(),
          NowPlayingMoviesError('Server Failure'),
        ],
    verify: (_) {
      verify(mockGetNowPlayingMovies.execute());
    },
  );
}
