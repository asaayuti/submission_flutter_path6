import 'package:core/domain/usecases/tv_series/get_watchlist_tv_series.dart';
import 'package:core/presentation/provider/tv_series/watchlist_tv_series_notifier.dart';
import 'package:core/utils/failure.dart';
import 'package:core/utils/state_enum.dart';
import 'package:dartz/dartz.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:core/utils/dummy_data/dummy_tv_series.dart';
import 'watchlist_tv_series_notifier_test.mocks.dart';

@GenerateMocks([GetWatchlistTvSeries])
void main() {
  late WatchlistTvSeriesNotifier provider;
  late MockGetWatchlistTvSeries mockGetWatchlistTvSeries;
  late int listenerCallCount;

  setUp(() {
    listenerCallCount = 0;
    mockGetWatchlistTvSeries = MockGetWatchlistTvSeries();
    provider = WatchlistTvSeriesNotifier(
      getWatchlistTvSeries: mockGetWatchlistTvSeries,
    )..addListener(() {
      listenerCallCount += 1;
    });
  });

  test(
    'should change tv series data when data is gotten successfully',
    () async {
      // arrange
      when(
        mockGetWatchlistTvSeries.execute(),
      ).thenAnswer((_) async => Right([tWatchlistTvSeries]));
      // act
      await provider.fetchWatchlistTvSeries();
      // assert
      expect(provider.watchlistState, RequestState.loaded);
      expect(provider.watchlistTvSeries, [tWatchlistTvSeries]);
      expect(listenerCallCount, 2);
    },
  );

  test('should return error when data is unsuccessful', () async {
    // arrange
    when(
      mockGetWatchlistTvSeries.execute(),
    ).thenAnswer((_) async => Left(DatabaseFailure("Can't get data")));
    // act
    await provider.fetchWatchlistTvSeries();
    // assert
    expect(provider.watchlistState, RequestState.error);
    expect(provider.message, "Can't get data");
    expect(listenerCallCount, 2);
  });
}
