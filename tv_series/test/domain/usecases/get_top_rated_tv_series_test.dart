import 'package:dartz/dartz.dart';
import 'package:tv_series/domain/usecases/get_top_rated_tvs.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:tv_series/dummy_data/dummy_tv_objects.dart';
import '../../helpers/test_helper.mocks.dart';

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
