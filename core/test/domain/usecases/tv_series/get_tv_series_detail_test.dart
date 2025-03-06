import 'package:dartz/dartz.dart';
import 'package:core/domain/usecases/tv_series/get_tv_detail.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:core/utils/dummy_tv_series.dart';
import '../../../helpers/test_helper.mocks.dart';

void main() {
  late GetTvDetail usecase;
  late MockTvSeriesRepository mockTvSeriesRepository;

  setUp(() {
    mockTvSeriesRepository = MockTvSeriesRepository();
    usecase = GetTvDetail(mockTvSeriesRepository);
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
