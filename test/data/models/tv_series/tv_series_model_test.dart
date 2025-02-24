import 'package:flutter_test/flutter_test.dart';

import '../../../dummy_data/tv_series/dummy_objects.dart';

void main() {
  test('should be a subclass of TvSeries entity', () async {
    final result = tTvSeriesModel.toEntity();
    expect(result, tTvSeries);
  });
}
