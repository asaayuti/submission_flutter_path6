import 'package:movies/domain/usecases/remove_watchlist.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:movies/dummy_data/dummy_movie_objects.dart';

import '../../helpers/test_helper.mocks.dart';

void main() {
  late RemoveWatchlist usecase;
  late MockMovieRepository mockMovieRepository;

  setUp(() {
    mockMovieRepository = MockMovieRepository();
    usecase = RemoveWatchlist(mockMovieRepository);
  });

  test('should remove watchlist movie from repository', () async {
    // arrange
    when(
      mockMovieRepository.removeWatchlist(tMovieDetail),
    ).thenAnswer((_) async => Right('Removed from watchlist'));
    // act
    final result = await usecase.execute(tMovieDetail);
    // assert
    verify(mockMovieRepository.removeWatchlist(tMovieDetail));
    expect(result, Right('Removed from watchlist'));
  });
}
