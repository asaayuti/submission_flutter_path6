import 'package:dartz/dartz.dart';
import 'package:core/utils/failure.dart';
import '../../entities/tv_series/tv_series.dart';
import '../../repositories/tv_series_repository.dart';

class GetWatchlistTvs {
  final TvSeriesRepository repository;

  GetWatchlistTvs(this.repository);

  Future<Either<Failure, List<TvSeries>>> execute() {
    return repository.getWatchlistTvSeries();
  }
}
