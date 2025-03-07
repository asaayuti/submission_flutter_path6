import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:tv_series/domain/usecases/get_top_rated_tvs.dart';
import 'package:tv_series/presentation/bloc/top_rated_tvs_bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'top_rated_tvs_bloc_test.mocks.dart';

@GenerateMocks([GetTopRatedTvs])
void main() {
  late TopRatedTvsBloc bloc;
  late MockGetTopRatedTvs mockGetTopRatedTvs;

  setUp(() {
    mockGetTopRatedTvs = MockGetTopRatedTvs();
    bloc = TopRatedTvsBloc(mockGetTopRatedTvs);
  });

  test('initial state should be TopRatedTvsInitial', () {
    expect(bloc.state, equals(TopRatedTvsInitial()));
  });

  blocTest<TopRatedTvsBloc, TopRatedTvsState>(
    'emits [TopRatedTvsLoading, TopRatedTvsError] when FetchTopRatedTvs() is success.',
    build: () {
      when(
        mockGetTopRatedTvs.execute(),
      ).thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      return bloc;
    },
    act: (bloc) => bloc.add(FetchTopRatedTvs()),
    expect: () => [TopRatedTvsLoading(), TopRatedTvsError('Server Failure')],
    verify: (_) {
      verify(mockGetTopRatedTvs.execute());
    },
  );

  blocTest<TopRatedTvsBloc, TopRatedTvsState>(
    'emits [TopRatedTvsLoading, TopRatedTvsError] when FetchTopRatedTvs() is failure.',
    build: () {
      when(
        mockGetTopRatedTvs.execute(),
      ).thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      return bloc;
    },
    act: (bloc) => bloc.add(FetchTopRatedTvs()),
    expect: () => [TopRatedTvsLoading(), TopRatedTvsError('Server Failure')],
    verify: (_) {
      verify(mockGetTopRatedTvs.execute());
    },
  );
}
