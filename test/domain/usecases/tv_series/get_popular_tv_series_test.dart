import 'package:dartz/dartz.dart';
import 'package:ditonton/domain/usecases/tv_series/get_popular_tv_series.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../dummy_data/tv_series/dummy_objects.dart';
import '../../../helpers/test_helper.mocks.dart';

void main() {
  late GetPopularTvSeries usecase;
  late MockTvSeriesRepository mockTvSeriesRpository;

  setUp(() {
    mockTvSeriesRpository = MockTvSeriesRepository();
    usecase = GetPopularTvSeries(mockTvSeriesRpository);
  });

  group('GetPopularTvSeries Tests', () {
    group('execute', () {
      test(
        'should get list of TvSeries from the repository when execute function is called',
        () async {
          // arrange
          when(
            mockTvSeriesRpository.getPopularTvSeries(),
          ).thenAnswer((_) async => Right(tEmptyTvSeriesList));
          // act
          final result = await usecase.execute();
          // assert
          expect(result, Right(tEmptyTvSeriesList));
        },
      );
    });
  });
}
