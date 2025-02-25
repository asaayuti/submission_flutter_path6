import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:core/utils/exception.dart';
import 'package:core/utils/failure.dart';
import '../datasources/tv_series/tv_series_local_data_source.dart';
import '../datasources/tv_series/tv_series_remote_data_source.dart';
import '../models/tv_series/tv_series_table.dart';
import '../../domain/entities/tv_series/tv_series.dart';
import '../../domain/entities/tv_series/tv_series_detail.dart';
import '../../domain/repositories/tv_series_repository.dart';

class TvSeriesRepositoryImpl implements TvSeriesRepository {
  final TvSeriesRemoteDataSource remoteDataSource;
  final TvSeriesLocalDataSource localDataSource;

  TvSeriesRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  Future<Either<Failure, T>> handleRemoteRequest<T>(
    Future<T> Function() request,
  ) async {
    try {
      final result = await request();
      return Right(result);
    } on ServerException {
      return Left(ServerFailure('Failed to fetch data from server'));
    } on SocketException {
      return Left(ConnectionFailure('Failed to connect to the network'));
    }
  }

  Future<Either<Failure, String>> handleLocalRequest(
    Future<String> Function() request,
  ) async {
    try {
      final result = await request();
      return Right(result);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<TvSeries>>> getNowPlayingTvSeries() async =>
      handleRemoteRequest(
        () async =>
            (await remoteDataSource.getNowPlayingTvSeries())
                .map((model) => model.toEntity())
                .toList(),
      );

  @override
  Future<Either<Failure, List<TvSeries>>> getPopularTvSeries() async =>
      handleRemoteRequest(
        () async =>
            (await remoteDataSource.getPopularTvSeries())
                .map((model) => model.toEntity())
                .toList(),
      );

  @override
  Future<Either<Failure, List<TvSeries>>> getTopRatedTvSeries() async =>
      handleRemoteRequest(
        () async =>
            (await remoteDataSource.getTopRatedTvSeries())
                .map((model) => model.toEntity())
                .toList(),
      );

  @override
  Future<Either<Failure, TvSeriesDetail>> getTvSeriesDetail(int id) async =>
      handleRemoteRequest(
        () async => (await remoteDataSource.getTvSeriesDetail(id)).toEntity(),
      );

  @override
  Future<Either<Failure, List<TvSeries>>> getTvSeriesRecommendations(
    int id,
  ) async => handleRemoteRequest(
    () async =>
        (await remoteDataSource.getTvSeriesRecommendations(
          id,
        )).map((model) => model.toEntity()).toList(),
  );

  @override
  Future<Either<Failure, List<TvSeries>>> getWatchlistTvSeries() async {
    final result = await localDataSource.getWatchlistTvSeries();
    return Right(result.map((data) => data.toEntity()).toList());
  }

  @override
  Future<bool> isAddedToWatchlist(int id) async =>
      (await localDataSource.getTvSeriesById(id)) != null;

  @override
  Future<Either<Failure, String>> removeWatchlist(
    TvSeriesDetail tvSeries,
  ) async => handleLocalRequest(
    () => localDataSource.removeWatchlist(TvSeriesTable.fromEntity(tvSeries)),
  );

  @override
  Future<Either<Failure, String>> saveWatchlist(
    TvSeriesDetail tvSeries,
  ) async => handleLocalRequest(
    () => localDataSource.insertWatchlist(TvSeriesTable.fromEntity(tvSeries)),
  );

  @override
  Future<Either<Failure, List<TvSeries>>> searchTvSeries(String query) async =>
      handleRemoteRequest(
        () async =>
            (await remoteDataSource.searchTvSeries(
              query,
            )).map((model) => model.toEntity()).toList(),
      );
}
