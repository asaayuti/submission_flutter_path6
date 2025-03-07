import 'package:dartz/dartz.dart';
import 'package:tv_series/domain/usecases/get_tv_recommendations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:tv_series/dummy_data/dummy_tv_objects.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late GetTvRecommendations usecase;
  late MockTvSeriesRepository mockTvSeriesRepository;

  setUp(() {
    mockTvSeriesRepository = MockTvSeriesRepository();
    usecase = GetTvRecommendations(mockTvSeriesRepository);
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
