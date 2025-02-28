import 'package:core/domain/usecases/movie/get_movie_recommendations.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:core/utils/dummy_data/movies/dummy_objects.dart';
import '../../../helpers/test_helper.mocks.dart';

void main() {
  late GetMovieRecommendations usecase;
  late MockMovieRepository mockMovieRepository;

  setUp(() {
    mockMovieRepository = MockMovieRepository();
    usecase = GetMovieRecommendations(mockMovieRepository);
  });

  test(
    'should get list of movie recommendations from the repository',
    () async {
      // arrange
      when(
        mockMovieRepository.getMovieRecommendations(tMovieId),
      ).thenAnswer((_) async => Right(tEmptyMovieList));
      // act
      final result = await usecase.execute(tMovieId);
      // assert
      expect(result, Right(tEmptyMovieList));
    },
  );
}
