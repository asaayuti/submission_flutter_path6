import 'package:dartz/dartz.dart';
import 'package:tv_series/domain/usecases/save_watchlist_tv_series.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:tv_series/dummy_data/dummy_tv_objects.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late SaveWatchlistTv usecase;
  late MockTvSeriesRepository mockTvSeriesRepository;

  setUp(() {
    mockTvSeriesRepository = MockTvSeriesRepository();
    usecase = SaveWatchlistTv(mockTvSeriesRepository);
  });

  test('should save tv series to the repository', () async {
    // arrange
    when(
      mockTvSeriesRepository.saveWatchlist(tTvSeriesDetail),
    ).thenAnswer((_) async => Right('Added to Watchlist'));
    // act
    final result = await usecase.execute(tTvSeriesDetail);
    // assert
    verify(mockTvSeriesRepository.saveWatchlist(tTvSeriesDetail));
    expect(result, Right('Added to Watchlist'));
  });
}
