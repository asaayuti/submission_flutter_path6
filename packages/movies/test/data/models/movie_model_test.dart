import 'package:flutter_test/flutter_test.dart';
import 'package:movies/dummy_data/dummy_movie_objects.dart';

void main() {
  test('should be a subclass of Movie entity', () async {
    final result = tMovieModel.toEntity();
    expect(result, tMovie);
  });
}
