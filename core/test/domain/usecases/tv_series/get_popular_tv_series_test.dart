import 'package:dartz/dartz.dart';
import 'package:core/domain/usecases/tv_series/get_popular_tvs.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:core/utils/dummy_tv_series.dart';
import '../../../helpers/test_helper.mocks.dart';

void main() {
  late GetPopularTvs usecase;
  late MockTvSeriesRepository mockTvSeriesRpository;

  setUp(() {
    mockTvSeriesRpository = MockTvSeriesRepository();
    usecase = GetPopularTvs(mockTvSeriesRpository);
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
