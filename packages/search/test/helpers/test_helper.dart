import 'package:mockito/annotations.dart';
import 'package:movies/domain/repositories/movie_repository.dart';
import 'package:tv_series/domain/repositories/tv_series_repository.dart';

@GenerateMocks([MovieRepository, TvSeriesRepository])
void main() {}
