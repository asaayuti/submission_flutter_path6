import 'package:dartz/dartz.dart';
import 'package:core/domain/usecases/tv_series/get_now_playing_tv_series.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:core/utils/dummy_data/dummy_tv_series.dart';
import '../../../helpers/test_helper.mocks.dart';

void main() {
  late GetNowPlayingTvSeries usecase;
  late MockTvSeriesRepository mockTvSeriesRepository;

  setUp(() {
    mockTvSeriesRepository = MockTvSeriesRepository();
    usecase = GetNowPlayingTvSeries(mockTvSeriesRepository);
  });

  test('should get list of TvSeries from the repository', () async {
    // arrange
    when(
      mockTvSeriesRepository.getNowPlayingTvSeries(),
    ).thenAnswer((_) async => Right(tEmptyTvSeriesList));
    // act
    final result = await usecase.execute();
    // assert
    expect(result, Right(tEmptyTvSeriesList));
  });
}
