import 'package:dartz/dartz.dart';
import 'package:ditonton/domain/usecases/tv_series/get_tv_series_detail.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../dummy_data/tv_series/dummy_objects.dart';
import '../../../helpers/test_helper.mocks.dart';

void main() {
  late GetTvSeriesDetail usecase;
  late MockTvSeriesRepository mockTvSeriesRepository;

  setUp(() {
    mockTvSeriesRepository = MockTvSeriesRepository();
    usecase = GetTvSeriesDetail(mockTvSeriesRepository);
  });

  test('should get movie detail from the repository', () async {
    // arrange
    when(
      mockTvSeriesRepository.getTvSeriesDetail(tTvSeriesId),
    ).thenAnswer((_) async => Right(tTvSeriesDetail));
    // act
    final result = await usecase.execute(tTvSeriesId);
    // assert
    expect(result, Right(tTvSeriesDetail));
  });
}
