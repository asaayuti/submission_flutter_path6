import 'package:bloc_test/bloc_test.dart';
import 'package:core/domain/usecases/tv_series/get_now_playing_tvs.dart';
import 'package:core/presentation/bloc/tv_series/now_playing_tvs_bloc.dart';
import 'package:core/utils/dummy_tv_series.dart';
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
