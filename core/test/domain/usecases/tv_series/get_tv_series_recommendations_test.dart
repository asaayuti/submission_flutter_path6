import 'package:dartz/dartz.dart';
import 'package:core/domain/usecases/tv_series/get_tv_series_recommendations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:core/utils/dummy_data/dummy_tv_series.dart';
import '../../../helpers/test_helper.mocks.dart';

void main() {
  late GetTvSeriesRecommendations usecase;
  late MockTvSeriesRepository mockTvSeriesRepository;

  setUp(() {
    mockTvSeriesRepository = MockTvSeriesRepository();
    usecase = GetTvSeriesRecommendations(mockTvSeriesRepository);
  });

  test(
    'should get list of movie recommendations from the repository',
    () async {
      // arrange
      when(
        mockTvSeriesRepository.getTvSeriesRecommendations(tTvSeriesId),
      ).thenAnswer((_) async => Right(tEmptyTvSeriesList));
      // act
      final result = await usecase.execute(tTvSeriesId);
      // assert
      expect(result, Right(tEmptyTvSeriesList));
    },
  );
}
