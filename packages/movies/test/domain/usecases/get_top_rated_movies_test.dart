import 'package:dartz/dartz.dart';
import 'package:movies/domain/usecases/get_top_rated_movies.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:movies/dummy_data/dummy_movie_objects.dart';

import '../../helpers/test_helper.mocks.dart';

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
