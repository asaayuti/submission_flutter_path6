import 'dart:convert';

import 'package:core/utils/constants.dart';
import 'package:core/utils/ssl_client_provider.dart';

import '../../models/movie/movie_detail_model.dart';
import '../../models/movie/movie_model.dart';
import '../../models/movie/movie_response.dart';
import 'package:core/utils/exception.dart';
import 'package:http/http.dart' as http;

abstract class MovieRemoteDataSource {
  Future<List<MovieModel>> getNowPlayingMovies();
  Future<List<MovieModel>> getPopularMovies();
  Future<List<MovieModel>> getTopRatedMovies();
  Future<MovieDetailResponse> getMovieDetail(int id);
  Future<List<MovieModel>> getMovieRecommendations(int id);
  Future<List<MovieModel>> searchMovies(String query);
}

class MovieRemoteDataSourceImpl implements MovieRemoteDataSource {
  http.Client client;
  final SslClientProvider sslClientProvider;

  MovieRemoteDataSourceImpl({
    required this.client,
    required this.sslClientProvider,
  });

  @override
  Future<List<MovieModel>> getNowPlayingMovies() async {
    client = await sslClientProvider.getSSLPinningClient();
    final response = await client.get(
      Uri.parse('$baseUrl/movie/now_playing?$apiKey'),
    );

    if (response.statusCode == 200) {
      return MovieResponse.fromJson(json.decode(response.body)).movieList;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<MovieDetailResponse> getMovieDetail(int id) async {
    client = await sslClientProvider.getSSLPinningClient();
    final response = await client.get(Uri.parse('$baseUrl/movie/$id?$apiKey'));

    if (response.statusCode == 200) {
      return MovieDetailResponse.fromJson(json.decode(response.body));
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<MovieModel>> getMovieRecommendations(int id) async {
    client = await sslClientProvider.getSSLPinningClient();
    final response = await client.get(
      Uri.parse('$baseUrl/movie/$id/recommendations?$apiKey'),
    );

    if (response.statusCode == 200) {
      return MovieResponse.fromJson(json.decode(response.body)).movieList;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<MovieModel>> getPopularMovies() async {
    client = await sslClientProvider.getSSLPinningClient();
    final response = await client.get(
      Uri.parse('$baseUrl/movie/popular?$apiKey'),
    );

    if (response.statusCode == 200) {
      return MovieResponse.fromJson(json.decode(response.body)).movieList;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<MovieModel>> getTopRatedMovies() async {
    client = await sslClientProvider.getSSLPinningClient();
    final response = await client.get(
      Uri.parse('$baseUrl/movie/top_rated?$apiKey'),
    );

    if (response.statusCode == 200) {
      return MovieResponse.fromJson(json.decode(response.body)).movieList;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<MovieModel>> searchMovies(String query) async {
    client = await sslClientProvider.getSSLPinningClient();
    final response = await client.get(
      Uri.parse('$baseUrl/search/movie?$apiKey&query=$query'),
    );

    if (response.statusCode == 200) {
      return MovieResponse.fromJson(json.decode(response.body)).movieList;
    } else {
      throw ServerException();
    }
  }
}
