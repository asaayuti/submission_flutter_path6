import 'package:dartz/dartz.dart';
import 'package:core/domain/usecases/tv_series/get_top_rated_tvs.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:core/utils/dummy_tv_series.dart';
import '../../../helpers/test_helper.mocks.dart';

void main() {
  late GetTopRatedTvs usecase;
  late MockTvSeriesRepository mockTvSeriesRepository;

  setUp(() {
    mockTvSeriesRepository = MockTvSeriesRepository();
    usecase = GetTopRatedTvs(mockTvSeriesRepository);
  });

  test('should get list of TvSeries from repository', () async {
    // arrange
    when(
      mockTvSeriesRepository.getTopRatedTvSeries(),
    ).thenAnswer((_) async => Right(tEmptyTvSeriesList));
    // act
    final result = await usecase.execute();
    // assert
    expect(result, Right(tEmptyTvSeriesList));
  });
}
