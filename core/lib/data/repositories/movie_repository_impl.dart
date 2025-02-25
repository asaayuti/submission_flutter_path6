import 'dart:io';

import 'package:dartz/dartz.dart';
import '../datasources/movie/movie_local_data_source.dart';
import '../datasources/movie/movie_remote_data_source.dart';
import '../models/movie/movie_table.dart';
import '../../domain/entities/movie/movie.dart';
import '../../domain/entities/movie/movie_detail.dart';
import '../../domain/repositories/movie_repository.dart';
import 'package:core/utils/exception.dart';
import 'package:core/utils/failure.dart';

class MovieRepositoryImpl implements MovieRepository {
  final MovieRemoteDataSource remoteDataSource;
  final MovieLocalDataSource localDataSource;

  MovieRepositoryImpl({
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
  Future<Either<Failure, List<Movie>>> getNowPlayingMovies() async =>
      handleRemoteRequest(
        () async =>
            (await remoteDataSource.getNowPlayingMovies())
                .map((model) => model.toEntity())
                .toList(),
      );

  @override
  Future<Either<Failure, MovieDetail>> getMovieDetail(int id) async =>
      handleRemoteRequest(
        () async => (await remoteDataSource.getMovieDetail(id)).toEntity(),
      );

  @override
  Future<Either<Failure, List<Movie>>> getMovieRecommendations(int id) async =>
      handleRemoteRequest(
        () async =>
            (await remoteDataSource.getMovieRecommendations(
              id,
            )).map((model) => model.toEntity()).toList(),
      );

  @override
  Future<Either<Failure, List<Movie>>> getPopularMovies() async =>
      handleRemoteRequest(
        () async =>
            (await remoteDataSource.getPopularMovies())
                .map((model) => model.toEntity())
                .toList(),
      );

  @override
  Future<Either<Failure, List<Movie>>> getTopRatedMovies() async =>
      handleRemoteRequest(
        () async =>
            (await remoteDataSource.getTopRatedMovies())
                .map((model) => model.toEntity())
                .toList(),
      );

  @override
  Future<Either<Failure, List<Movie>>> searchMovies(String query) async =>
      handleRemoteRequest(
        () async =>
            (await remoteDataSource.searchMovies(
              query,
            )).map((model) => model.toEntity()).toList(),
      );

  @override
  Future<Either<Failure, String>> saveWatchlist(MovieDetail movie) async =>
      handleLocalRequest(
        () => localDataSource.insertWatchlist(MovieTable.fromEntity(movie)),
      );

  @override
  Future<Either<Failure, String>> removeWatchlist(MovieDetail movie) async =>
      handleLocalRequest(
        () => localDataSource.removeWatchlist(MovieTable.fromEntity(movie)),
      );

  @override
  Future<bool> isAddedToWatchlist(int id) async =>
      (await localDataSource.getMovieById(id)) != null;

  @override
  Future<Either<Failure, List<Movie>>> getWatchlistMovies() async {
    final result = await localDataSource.getWatchlistMovies();
    return Right(result.map((data) => data.toEntity()).toList());
  }
}
