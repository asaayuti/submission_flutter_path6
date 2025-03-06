import '../repositories/tv_series_repository.dart';

class GetWatchlistStatusTv {
  final TvSeriesRepository repository;

  GetWatchlistStatusTv(this.repository);

  Future<bool> execute(int id) async {
    return repository.isAddedToWatchlist(id);
  }
}
