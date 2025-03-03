import 'package:flutter_test/flutter_test.dart';

import 'package:core/utils/dummy_data/movies/dummy_objects.dart';

void main() {
  test('should be a subclass of Movie entity', () async {
    final result = tMovieModel.toEntity();
    expect(result, tMovie);
  });
}
