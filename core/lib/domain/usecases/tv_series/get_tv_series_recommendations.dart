import 'package:dartz/dartz.dart';
import 'package:core/utils/failure.dart';
import '../../entities/tv_series/tv_series.dart';
import '../../repositories/tv_series_repository.dart';

class GetTvSeriesRecommendations {
  final TvSeriesRepository repository;

  GetTvSeriesRecommendations(this.repository);

  Future<Either<Failure, List<TvSeries>>> execute(id) {
    return repository.getTvSeriesRecommendations(id);
  }
}
