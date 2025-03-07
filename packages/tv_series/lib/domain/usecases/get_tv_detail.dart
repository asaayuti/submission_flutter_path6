import 'package:dartz/dartz.dart';
import 'package:core/utils/failure.dart';
import '../entities/tv_series_detail.dart';
import '../repositories/tv_series_repository.dart';

class GetTvDetail {
  final TvSeriesRepository repository;

  GetTvDetail(this.repository);

  Future<Either<Failure, TvSeriesDetail>> execute(int id) {
    return repository.getTvSeriesDetail(id);
  }
}
