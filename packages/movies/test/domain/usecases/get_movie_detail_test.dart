import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:movies/domain/usecases/get_movie_detail.dart';
import 'package:movies/dummy_data/dummy_movie_objects.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late GetMovieDetail usecase;
  late MockMovieRepository mockMovieRepository;

  setUp(() {
    mockMovieRepository = MockMovieRepository();
    usecase = GetMovieDetail(mockMovieRepository);
  });

  test('should get movie detail from the repository', () async {
    // arrange
    when(
      mockMovieRepository.getMovieDetail(tMovieId),
    ).thenAnswer((_) async => Right(tMovieDetail));
    // act
    final result = await usecase.execute(tMovieId);
    // assert
    expect(result, Right(tMovieDetail));
  });
}
