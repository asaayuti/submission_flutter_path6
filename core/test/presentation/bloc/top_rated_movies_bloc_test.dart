import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:core/domain/usecases/movie/get_top_rated_movies.dart';
import 'package:core/presentation/bloc/top_rated_movies_bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'top_rated_movies_bloc_test.mocks.dart';

@GenerateMocks([GetTopRatedMovies])
void main() {
  late TopRatedMoviesBloc bloc;
  late MockGetTopRatedMovies mockGetTopRatedMovies;

  setUp(() {
    mockGetTopRatedMovies = MockGetTopRatedMovies();
    bloc = TopRatedMoviesBloc(mockGetTopRatedMovies);
  });

  test('initial state should be TopRatedMoviesInitial', () {
    expect(bloc.state, equals(TopRatedMoviesInitial()));
  });

  blocTest<TopRatedMoviesBloc, TopRatedMoviesState>(
    'emits [TopRatedMoviesLoading, TopRatedMoviesError] when FetchTopRatedMovies() is success.',
    build: () {
      when(
        mockGetTopRatedMovies.execute(),
      ).thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      return bloc;
    },
    act: (bloc) => bloc.add(FetchTopRatedMovies()),
    expect:
        () => [TopRatedMoviesLoading(), TopRatedMoviesError('Server Failure')],
    verify: (_) {
      verify(mockGetTopRatedMovies.execute());
    },
  );

  blocTest<TopRatedMoviesBloc, TopRatedMoviesState>(
    'emits [TopRatedMoviesLoading, TopRatedMoviesError] when FetchTopRatedMovies() is failure.',
    build: () {
      when(
        mockGetTopRatedMovies.execute(),
      ).thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      return bloc;
    },
    act: (bloc) => bloc.add(FetchTopRatedMovies()),
    expect:
        () => [TopRatedMoviesLoading(), TopRatedMoviesError('Server Failure')],
    verify: (_) {
      verify(mockGetTopRatedMovies.execute());
    },
  );
}
