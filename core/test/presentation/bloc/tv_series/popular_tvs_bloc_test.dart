import 'package:bloc_test/bloc_test.dart';
import 'package:core/domain/usecases/tv_series/get_popular_tvs.dart';
import 'package:core/presentation/bloc/tv_series/popular_tvs_bloc.dart';
import 'package:core/utils/dummy_tv_series.dart';
import 'package:core/utils/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'popular_tvs_bloc_test.mocks.dart';

@GenerateMocks([GetPopularTvs])
void main() {
  late PopularTvsBloc popularTvsBloc;
  late MockGetPopularTvs mockGetPopularTvs;

  setUp(() {
    mockGetPopularTvs = MockGetPopularTvs();
    popularTvsBloc = PopularTvsBloc(mockGetPopularTvs);
  });

  test('initial state should be empty', () {
    expect(popularTvsBloc.state, equals(PopularTvsEmpty()));
  });

  blocTest<PopularTvsBloc, PopularTvsState>(
    'Should emits [Loading, HasData] when data is gotten successfully.',
    build: () {
      when(
        mockGetPopularTvs.execute(),
      ).thenAnswer((_) async => Right(tTvSeriesList));
      return popularTvsBloc;
    },
    act: (bloc) => bloc.add(FetchPopularTvs()),
    expect: () => [PopularTvsLoading(), PopularTvsHasData(tTvSeriesList)],
    verify: (bloc) {
      verify(mockGetPopularTvs.execute());
    },
  );

  blocTest<PopularTvsBloc, PopularTvsState>(
    'Should emits [Loading, Error] when data is failed to get.',
    build: () {
      when(
        mockGetPopularTvs.execute(),
      ).thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      return popularTvsBloc;
    },
    act: (bloc) => bloc.add(FetchPopularTvs()),
    expect: () => [PopularTvsLoading(), PopularTvsError('Server Failure')],
    verify: (bloc) {
      verify(mockGetPopularTvs.execute());
    },
  );
}
