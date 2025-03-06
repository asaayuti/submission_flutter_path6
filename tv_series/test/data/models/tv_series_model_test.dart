import 'package:tv_series/dummy_data/dummy_tv_objects.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('should be a subclass of TvSeries entity', () async {
    final result = tTvSeriesModel.toEntity();
    expect(result, tTvSeries);
  });
}
