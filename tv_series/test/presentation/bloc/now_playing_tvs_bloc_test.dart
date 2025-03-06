import 'package:bloc_test/bloc_test.dart';
import 'package:tv_series/domain/usecases/get_now_playing_tvs.dart';
import 'package:tv_series/presentation/bloc/now_playing_tvs_bloc.dart';
import 'package:tv_series/dummy_data/dummy_tv_objects.dart';
import 'package:core/utils/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'now_playing_tvs_bloc_test.mocks.dart';

@GenerateMocks([GetNowPlayingTvs])
void main() {
  late NowPlayingTvsBloc bloc;
  late MockGetNowPlayingTvs mockGetNowPlayingTvs;

  setUp(() {
    mockGetNowPlayingTvs = MockGetNowPlayingTvs();
    bloc = NowPlayingTvsBloc(mockGetNowPlayingTvs);
  });

  test('initial state is NowPlayingTvsInitial', () {
    expect(bloc.state, equals(NowPlayingTvsEmpty()));
  });

  blocTest<NowPlayingTvsBloc, NowPlayingTvsState>(
    'emits [Loading, HasData] when FetchNowPlayingTvs() is success.',
    build: () {
      when(
        mockGetNowPlayingTvs.execute(),
      ).thenAnswer((_) async => Right(tTvSeriesList));
      return bloc;
    },
    act: (bloc) => bloc.add(FetchNowPlayingTvs()),
    expect: () => [NowPlayingTvsLoading(), NowPlayingTvsHasData(tTvSeriesList)],
    verify: (_) {
      verify(mockGetNowPlayingTvs.execute());
    },
  );

  blocTest<NowPlayingTvsBloc, NowPlayingTvsState>(
    'emits [Loading, Error] when FetchNowPlayingTvs() is failed.',
    build: () {
      when(
        mockGetNowPlayingTvs.execute(),
      ).thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      return bloc;
    },
    act: (bloc) => bloc.add(FetchNowPlayingTvs()),
    expect:
        () => [NowPlayingTvsLoading(), NowPlayingTvsError('Server Failure')],
    verify: (_) {
      verify(mockGetNowPlayingTvs.execute());
    },
  );
}
