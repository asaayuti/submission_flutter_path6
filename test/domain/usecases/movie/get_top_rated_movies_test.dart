import 'package:dartz/dartz.dart';
import 'package:ditonton/domain/usecases/movie/get_top_rated_movies.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../dummy_data/movie/dummy_objects.dart';
import '../../../helpers/test_helper.mocks.dart';

void main() {
  late GetTopRatedMovies usecase;
  late MockMovieRepository mockMovieRepository;

  setUp(() {
    mockMovieRepository = MockMovieRepository();
    usecase = GetTopRatedMovies(mockMovieRepository);
  });

  test('should get list of movies from repository', () async {
    // arrange
    when(
      mockMovieRepository.getTopRatedMovies(),
    ).thenAnswer((_) async => Right(tEmptyMovieList));
    // act
    final result = await usecase.execute();
    // assert
    expect(result, Right(tEmptyMovieList));
  });
}
