import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:movies/domain/usecases/get_now_playing_movies.dart';
import 'package:movies/dummy_data/dummy_movie_objects.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late GetNowPlayingMovies usecase;
  late MockMovieRepository mockMovieRepository;

  setUp(() {
    mockMovieRepository = MockMovieRepository();
    usecase = GetNowPlayingMovies(mockMovieRepository);
  });

  test('should get list of movies from the repository', () async {
    // arrange
    when(
      mockMovieRepository.getNowPlayingMovies(),
    ).thenAnswer((_) async => Right(tEmptyMovieList));
    // act
    final result = await usecase.execute();
    // assert
    expect(result, Right(tEmptyMovieList));
  });
}
