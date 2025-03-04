import 'package:core/domain/usecases/movie/save_watchlist.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:core/utils/dummy_data/dummy_movies.dart';
import '../../../helpers/test_helper.mocks.dart';

void main() {
  late SaveWatchlist usecase;
  late MockMovieRepository mockMovieRepository;

  setUp(() {
    mockMovieRepository = MockMovieRepository();
    usecase = SaveWatchlist(mockMovieRepository);
  });

  test('should save movie to the repository', () async {
    // arrange
    when(
      mockMovieRepository.saveWatchlist(tMovieDetail),
    ).thenAnswer((_) async => Right('Added to Watchlist'));
    // act
    final result = await usecase.execute(tMovieDetail);
    // assert
    verify(mockMovieRepository.saveWatchlist(tMovieDetail));
    expect(result, Right('Added to Watchlist'));
  });
}
