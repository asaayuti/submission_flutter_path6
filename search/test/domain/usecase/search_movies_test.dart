import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:movies/domain/repositories/movie_repository.dart';
import 'package:movies/dummy_data/dummy_movie_objects.dart';
import 'package:search/domain/usecase/search_movies.dart';

import 'search_movies_test.mocks.dart';

@GenerateMocks([MovieRepository])
void main() {
  late SearchMovies usecase;
  late MockMovieRepository mockMovieRepository;

  setUp(() {
    mockMovieRepository = MockMovieRepository();
    usecase = SearchMovies(mockMovieRepository);
  });

  test('should get list of movies from the repository', () async {
    // arrange
    when(
      mockMovieRepository.searchMovies(tQuery),
    ).thenAnswer((_) async => Right(tEmptyMovieList));
    // act
    final result = await usecase.execute(tQuery);
    // assert
    expect(result, Right(tEmptyMovieList));
  });
}
