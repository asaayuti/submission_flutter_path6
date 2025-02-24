import 'package:flutter_test/flutter_test.dart';

import '../../dummy_data/movie/dummy_objects.dart';

void main() {
  test('should be a subclass of Movie entity', () async {
    final result = tMovieModel.toEntity();
    expect(result, tMovie);
  });
}
