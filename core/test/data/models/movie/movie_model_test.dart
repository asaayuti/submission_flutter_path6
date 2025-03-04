import 'package:flutter_test/flutter_test.dart';

import 'package:core/utils/dummy_data/dummy_movies.dart';

void main() {
  test('should be a subclass of Movie entity', () async {
    final result = tMovieModel.toEntity();
    expect(result, tMovie);
  });
}
