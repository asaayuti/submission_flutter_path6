import 'package:dartz/dartz.dart';
import 'package:core/utils/failure.dart';
import '../../entities/movie/movie.dart';
import '../../repositories/movie_repository.dart';

class SearchMovies {
  final MovieRepository repository;

  SearchMovies(this.repository);

  Future<Either<Failure, List<Movie>>> execute(String query) {
    return repository.searchMovies(query);
  }
}
