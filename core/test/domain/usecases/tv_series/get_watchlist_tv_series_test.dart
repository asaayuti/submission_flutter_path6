import 'package:core/domain/usecases/tv_series/get_watchlist_tv_series.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:core/utils/dummy_data/dummy_tv_series.dart';
import '../../../helpers/test_helper.mocks.dart';

void main() {
  late GetWatchlistTvs usecase;
  late MockTvSeriesRepository mockTvSeriesRepository;

  setUp(() {
    mockTvSeriesRepository = MockTvSeriesRepository();
    usecase = GetWatchlistTvs(mockTvSeriesRepository);
  });

  test('should get list of tv series from repository', () async {
    // arrange
    when(
      mockTvSeriesRepository.getWatchlistTvSeries(),
    ).thenAnswer((_) async => Right(tTvSeriesList));
    // act
    final result = await usecase.execute();
    // assert
    expect(result, Right(tTvSeriesList));
  });
}
