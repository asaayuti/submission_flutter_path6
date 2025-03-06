import 'package:dartz/dartz.dart';
import 'package:core/utils/failure.dart';
import '../../entities/tv_series/tv_series.dart';
import '../../repositories/tv_series_repository.dart';

class GetNowPlayingTvs {
  final TvSeriesRepository repository;

  GetNowPlayingTvs(this.repository);

  Future<Either<Failure, List<TvSeries>>> execute() {
    return repository.getNowPlayingTvSeries();
  }
}
