import 'package:dartz/dartz.dart';
import 'package:core/utils/failure.dart';
import '../../entities/tv_series/tv_series_detail.dart';
import '../../repositories/tv_series_repository.dart';

class RemoveWatchlistTv {
  final TvSeriesRepository repository;

  RemoveWatchlistTv(this.repository);

  Future<Either<Failure, String>> execute(TvSeriesDetail movie) {
    return repository.removeWatchlist(movie);
  }
}
