import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:search/domain/usecase/search_tv_series.dart';

import '../../../../core/test/dummy_data/movie/dummy_objects.dart';
import '../../../../core/test/dummy_data/tv_series/dummy_objects.dart';
import '../../../../core/test/helpers/test_helper.mocks.dart';

void main() {
  late SearchTvSeries usecase;
  late MockTvSeriesRepository mockTvSeriesRepository;

  setUp(() {
    mockTvSeriesRepository = MockTvSeriesRepository();
    usecase = SearchTvSeries(mockTvSeriesRepository);
  });

  test('should get list of TvSeries from the repository', () async {
    // arrange
    when(
      mockTvSeriesRepository.searchTvSeries(tQuery),
    ).thenAnswer((_) async => Right(tEmptyTvSeriesList));
    // act
    final result = await usecase.execute(tQuery);
    // assert
    expect(result, Right(tEmptyTvSeriesList));
  });
}
