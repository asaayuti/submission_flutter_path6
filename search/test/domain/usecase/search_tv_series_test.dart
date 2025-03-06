import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:search/domain/usecase/search_tv_series.dart';
import 'package:tv_series/dummy_data/dummy_tv_objects.dart';

import '../../helpers/test_helper.mocks.dart';

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
      mockTvSeriesRepository.searchTvSeries(tTvSeriesQuery),
    ).thenAnswer((_) async => Right(tEmptyTvSeriesList));
    // act
    final result = await usecase.execute(tTvSeriesQuery);
    // assert
    expect(result, Right(tEmptyTvSeriesList));
  });
}
