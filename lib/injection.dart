import 'package:core/data/datasources/db/database_helper.dart';
import 'package:movies/data/datasources/movie_local_data_source.dart';
import 'package:movies/data/datasources/movie_remote_data_source.dart';
import 'package:tv_series/data/datasources/tv_series_local_data_source.dart';
import 'package:tv_series/data/datasources/tv_series_remote_data_source.dart';
import 'package:movies/data/repositories/movie_repository_impl.dart';
import 'package:tv_series/data/repositories/tv_series_repository_impl.dart';
import 'package:movies/domain/repositories/movie_repository.dart';
import 'package:tv_series/domain/repositories/tv_series_repository.dart';
import 'package:movies/domain/usecases/get_movie_detail.dart';
import 'package:movies/domain/usecases/get_movie_recommendations.dart';
import 'package:movies/domain/usecases/get_now_playing_movies.dart';
import 'package:movies/domain/usecases/get_popular_movies.dart';
import 'package:movies/domain/usecases/get_top_rated_movies.dart';
import 'package:movies/domain/usecases/get_watchlist_movies.dart';
import 'package:movies/domain/usecases/get_watchlist_status.dart';
import 'package:movies/domain/usecases/remove_watchlist.dart';
import 'package:movies/domain/usecases/save_watchlist.dart';
import 'package:tv_series/domain/usecases/get_now_playing_tvs.dart';
import 'package:tv_series/domain/usecases/get_popular_tvs.dart';
import 'package:tv_series/domain/usecases/get_top_rated_tvs.dart';
import 'package:tv_series/domain/usecases/get_tv_detail.dart';
import 'package:tv_series/domain/usecases/get_tv_recommendations.dart';
import 'package:tv_series/domain/usecases/get_watchlist_status_tv_series.dart';
import 'package:tv_series/domain/usecases/get_watchlist_tv_series.dart';
import 'package:tv_series/domain/usecases/remove_watchlist_tv.dart';

import 'package:tv_series/domain/usecases/save_watchlist_tv_series.dart';
import 'package:movies/presentation/bloc/movie_detail_bloc.dart';
import 'package:movies/presentation/bloc/now_playing_movies_bloc.dart';
import 'package:movies/presentation/bloc/popular_movies_bloc.dart';
import 'package:movies/presentation/bloc/top_rated_movies_bloc.dart';
import 'package:movies/presentation/bloc/watchlist_movie_bloc.dart';
import 'package:tv_series/presentation/bloc/now_playing_tvs_bloc.dart';
import 'package:tv_series/presentation/bloc/popular_tvs_bloc.dart';
import 'package:tv_series/presentation/bloc/top_rated_tvs_bloc.dart';
import 'package:tv_series/presentation/bloc/tv_detail_bloc.dart';
import 'package:tv_series/presentation/bloc/watchlist_tv_bloc.dart';
import 'package:core/utils/ssl_client_provider.dart';
import 'package:http/http.dart' as http;
import 'package:get_it/get_it.dart';
import 'package:search/domain/usecase/search_movies.dart';
import 'package:search/domain/usecase/search_tv_series.dart';
import 'package:search/presentation/bloc/search_bloc.dart';

final locator = GetIt.instance;

void init() {
  // bloc
  locator.registerFactory(() => SearchBloc(locator(), locator()));
  // movie
  locator.registerFactory(
    () => MovieDetailBloc(
      getMovieDetail: locator(),
      getMovieRecommendations: locator(),
      getWatchListStatus: locator(),
      saveWatchlist: locator(),
      removeWatchlist: locator(),
    ),
  );
  locator.registerFactory(() => NowPlayingMoviesBloc(locator()));
  locator.registerFactory(() => PopularMoviesBloc(locator()));
  locator.registerFactory(() => TopRatedMoviesBloc(locator()));
  locator.registerFactory(() => WatchlistMovieBloc(locator()));
  // tv series
  locator.registerFactory(
    () => TvDetailBloc(
      getTvDetail: locator(),
      getTvRecommendations: locator(),
      getWatchListStatus: locator(),
      saveWatchlist: locator(),
      removeWatchlist: locator(),
    ),
  );
  locator.registerFactory(() => NowPlayingTvsBloc(locator()));
  locator.registerFactory(() => PopularTvsBloc(locator()));
  locator.registerFactory(() => TopRatedTvsBloc(locator()));
  locator.registerFactory(() => WatchlistTvBloc(locator()));

  // use case
  locator.registerLazySingleton(() => GetNowPlayingMovies(locator()));
  locator.registerLazySingleton(() => GetPopularMovies(locator()));
  locator.registerLazySingleton(() => GetTopRatedMovies(locator()));
  locator.registerLazySingleton(() => GetMovieDetail(locator()));
  locator.registerLazySingleton(() => GetMovieRecommendations(locator()));
  locator.registerLazySingleton(() => SearchMovies(locator()));
  locator.registerLazySingleton(() => GetWatchlistStatus(locator()));
  locator.registerLazySingleton(() => SaveWatchlist(locator()));
  locator.registerLazySingleton(() => RemoveWatchlist(locator()));
  locator.registerLazySingleton(() => GetWatchlistMovies(locator()));
  // tv series
  locator.registerLazySingleton(() => GetNowPlayingTvs(locator()));
  locator.registerLazySingleton(() => GetPopularTvs(locator()));
  locator.registerLazySingleton(() => GetTopRatedTvs(locator()));
  locator.registerLazySingleton(() => GetTvDetail(locator()));
  locator.registerLazySingleton(() => GetTvRecommendations(locator()));
  locator.registerLazySingleton(() => SearchTvSeries(locator()));
  locator.registerLazySingleton(() => GetWatchlistStatusTv(locator()));
  locator.registerLazySingleton(() => SaveWatchlistTv(locator()));
  locator.registerLazySingleton(() => RemoveWatchlistTv(locator()));
  locator.registerLazySingleton(() => GetWatchlistTvs(locator()));

  // repository
  locator.registerLazySingleton<MovieRepository>(
    () => MovieRepositoryImpl(
      remoteDataSource: locator(),
      localDataSource: locator(),
    ),
  );
  locator.registerLazySingleton<TvSeriesRepository>(
    () => TvSeriesRepositoryImpl(
      remoteDataSource: locator(),
      localDataSource: locator(),
    ),
  );

  // data sources
  locator.registerLazySingleton<MovieRemoteDataSource>(
    () => MovieRemoteDataSourceImpl(
      client: locator(),
      sslClientProvider: locator(),
    ),
  );
  locator.registerLazySingleton<MovieLocalDataSource>(
    () => MovieLocalDataSourceImpl(databaseHelper: locator()),
  );
  locator.registerLazySingleton<TvSeriesRemoteDataSource>(
    () => TvSeriesRemoteDataSourceImpl(
      client: locator(),
      sslClientProvider: locator(),
    ),
  );
  locator.registerLazySingleton<TvSeriesLocalDataSource>(
    () => TvSeriesLocalDataSourceImpl(databaseHelper: locator()),
  );

  // helper
  locator.registerLazySingleton<DatabaseHelper>(() => DatabaseHelper());

  // external
  locator.registerLazySingleton(() => http.Client());
  locator.registerLazySingleton(() => SslClientProvider());
}
