import 'package:dartz/dartz.dart';
import 'package:core/utils/failure.dart';
import '../entities/tv_series.dart';
import '../repositories/tv_series_repository.dart';

class GetPopularTvs {
  final TvSeriesRepository repository;

  GetPopularTvs(this.repository);

  Future<Either<Failure, List<TvSeries>>> execute() {
    return repository.getPopularTvSeries();
  }
}
