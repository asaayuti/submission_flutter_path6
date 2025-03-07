import 'package:bloc_test/bloc_test.dart';
import 'package:tv_series/domain/usecases/get_watchlist_tv_series.dart';
import 'package:tv_series/presentation/bloc/watchlist_tv_bloc.dart';
import 'package:tv_series/dummy_data/dummy_tv_objects.dart';
import 'package:core/utils/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'watchlist_tv_bloc_test.mocks.dart';

@GenerateMocks([GetWatchlistTvs])
void main() {
  late WatchlistTvBloc bloc;
  late MockGetWatchlistTvs mockGetWatchlistTvs;

  setUp(() {
    mockGetWatchlistTvs = MockGetWatchlistTvs();
    bloc = WatchlistTvBloc(mockGetWatchlistTvs);
  });

  test('initial state should be empty', () {
    expect(bloc.state, WatchlistTvEmpty());
  });

  blocTest<WatchlistTvBloc, WatchlistTvState>(
    'emits [WatchlistTvLoading(), WatchlistTvsLoaded()] when FetchWatchlistTvs() is success.',
    build: () {
      when(
        mockGetWatchlistTvs.execute(),
      ).thenAnswer((_) async => Right(tTvSeriesList));
      return bloc;
    },
    act: (bloc) => bloc.add(FetchWatchlistTvs()),
    expect: () => [WatchlistTvLoading(), WatchlistTvLoaded(tTvSeriesList)],
    verify: (_) {
      verify(mockGetWatchlistTvs.execute());
    },
  );

  blocTest<WatchlistTvBloc, WatchlistTvState>(
    'emits [WatchlistTvLoading(), WatchlistTvError()] when FetchWatchlistTvs() is unsuccessful.',
    build: () {
      when(
        mockGetWatchlistTvs.execute(),
      ).thenAnswer((_) async => Left(DatabaseFailure('Can\'t get data')));
      return bloc;
    },
    act: (bloc) => bloc.add(FetchWatchlistTvs()),
    expect: () => [WatchlistTvLoading(), WatchlistTvError('Can\'t get data')],
    verify: (_) {
      verify(mockGetWatchlistTvs.execute());
    },
  );
}
