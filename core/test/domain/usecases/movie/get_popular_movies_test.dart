import 'package:core/domain/usecases/movie/get_popular_movies.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:core/utils/dummy_data/dummy_movies.dart';
import '../../../helpers/test_helper.mocks.dart';

void main() {
  late GetPopularMovies usecase;
  late MockMovieRepository mockMovieRpository;

  setUp(() {
    mockMovieRpository = MockMovieRepository();
    usecase = GetPopularMovies(mockMovieRpository);
  });

  group('GetPopularMovies Tests', () {
    group('execute', () {
      test(
        'should get list of movies from the repository when execute function is called',
        () async {
          // arrange
          when(
            mockMovieRpository.getPopularMovies(),
          ).thenAnswer((_) async => Right(tEmptyMovieList));
          // act
          final result = await usecase.execute();
          // assert
          expect(result, Right(tEmptyMovieList));
        },
      );
    });
  });
}
