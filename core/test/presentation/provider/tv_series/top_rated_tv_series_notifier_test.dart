import 'package:core/domain/usecases/tv_series/get_top_rated_tv_series.dart';
import 'package:core/presentation/provider/tv_series/top_rated_tv_series_notifier.dart';
import 'package:core/utils/failure.dart';
import 'package:core/utils/state_enum.dart';
import 'package:dartz/dartz.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../dummy_data/tv_series/dummy_objects.dart';
import 'tv_series_list_notifier_test.mocks.dart';

@GenerateMocks([GetTopRatedTvSeries])
void main() {
  late MockGetTopRatedTvSeries mockGetTopRatedTvSeries;
  late TopRatedTvSeriesNotifier notifier;
  late int listenerCallCount;

  setUp(() {
    listenerCallCount = 0;
    mockGetTopRatedTvSeries = MockGetTopRatedTvSeries();
    notifier = TopRatedTvSeriesNotifier(
      getTopRatedTvSeries: mockGetTopRatedTvSeries,
    )..addListener(() {
      listenerCallCount++;
    });
  });

  test('should change state to loading when usecase is called', () async {
    // arrange
    when(
      mockGetTopRatedTvSeries.execute(),
    ).thenAnswer((_) async => Right(tTvSeriesList));
    // act
    notifier.fetchTopRatedTvSeries();
    // assert
    expect(notifier.state, RequestState.loading);
    expect(listenerCallCount, 1);
  });

  test(
    'should change tvSeries data when data is gotten successfully',
    () async {
      // arrange
      when(
        mockGetTopRatedTvSeries.execute(),
      ).thenAnswer((_) async => Right(tTvSeriesList));
      // act
      await notifier.fetchTopRatedTvSeries();
      // assert
      expect(notifier.state, RequestState.loaded);
      expect(notifier.tvSeries, tTvSeriesList);
      expect(listenerCallCount, 2);
    },
  );

  test('should return error when data is unsuccessful', () async {
    // arrange
    when(
      mockGetTopRatedTvSeries.execute(),
    ).thenAnswer((_) async => Left(ServerFailure('Server Failure')));
    // act
    await notifier.fetchTopRatedTvSeries();
    // assert
    expect(notifier.state, RequestState.error);
    expect(notifier.message, 'Server Failure');
    expect(listenerCallCount, 2);
  });
}
