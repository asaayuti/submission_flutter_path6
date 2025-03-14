import 'dart:convert';

import 'package:core/utils/constants.dart';
import 'package:core/utils/exception.dart';
import 'package:core/utils/json_reader.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';

import 'package:movies/data/datasources/movie_remote_data_source.dart';
import 'package:movies/data/models/movie_detail_model.dart';
import 'package:movies/data/models/movie_response.dart';
import 'package:movies/dummy_data/dummy_movie_objects.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late MovieRemoteDataSourceImpl dataSource;
  late MockHttpClient mockHttpClient;
  late MockSslClientProvider mockSslClientProvider;

  setUp(() {
    mockHttpClient = MockHttpClient();
    mockSslClientProvider = MockSslClientProvider();
    when(
      mockSslClientProvider.getSSLPinningClient(),
    ).thenAnswer((_) async => mockHttpClient);
    dataSource = MovieRemoteDataSourceImpl(
      client: mockHttpClient,
      sslClientProvider: mockSslClientProvider,
    );
  });

  group('get Now Playing Movies', () {
    final endpoint = '$baseUrl/movie/now_playing?$apiKey';
    final jsonPath = 'dummy_data/now_playing.json';
    final tMovieList =
        MovieResponse.fromJson(json.decode(readJson(jsonPath))).movieList;

    test(
      'should return list of Movie Model when the response code is 200',
      () async {
        // arrange
        when(
          mockHttpClient.get(Uri.parse(endpoint)),
        ).thenAnswer((_) async => http.Response(readJson(jsonPath), 200));
        // act
        final result = await dataSource.getNowPlayingMovies();
        // assert
        expect(result, equals(tMovieList));
      },
    );

    test(
      'should throw a ServerException when the response code is 404 or other',
      () async {
        // arrange
        when(
          mockHttpClient.get(Uri.parse(endpoint)),
        ).thenAnswer((_) async => http.Response('Not Found', 404));
        // act & assert
        expect(
          () async => await dataSource.getNowPlayingMovies(),
          throwsA(isA<ServerException>()),
        );
      },
    );
  });

  group('get Popular Movies', () {
    final endpoint = '$baseUrl/movie/popular?$apiKey';
    final jsonPath = 'dummy_data/popular.json';
    final tMovieList =
        MovieResponse.fromJson(json.decode(readJson(jsonPath))).movieList;

    test(
      'should return list of movies when response is success (200)',
      () async {
        // arrange
        when(
          mockHttpClient.get(Uri.parse(endpoint)),
        ).thenAnswer((_) async => http.Response(readJson(jsonPath), 200));
        // act
        final result = await dataSource.getPopularMovies();
        // assert
        expect(result, tMovieList);
      },
    );

    test(
      'should throw a ServerException when the response code is 404 or other',
      () async {
        // arrange
        when(
          mockHttpClient.get(Uri.parse(endpoint)),
        ).thenAnswer((_) async => http.Response('Not Found', 404));
        // act & assert
        expect(
          () async => await dataSource.getPopularMovies(),
          throwsA(isA<ServerException>()),
        );
      },
    );
  });

  group('get Top Rated Movies', () {
    final endpoint = '$baseUrl/movie/top_rated?$apiKey';
    final jsonPath = 'dummy_data/top_rated.json';
    final tMovieList =
        MovieResponse.fromJson(json.decode(readJson(jsonPath))).movieList;

    test('should return list of movies when response code is 200', () async {
      // arrange
      when(
        mockHttpClient.get(Uri.parse(endpoint)),
      ).thenAnswer((_) async => http.Response(readJson(jsonPath), 200));
      // act
      final result = await dataSource.getTopRatedMovies();
      // assert
      expect(result, tMovieList);
    });

    test(
      'should throw ServerException when response code is other than 200',
      () async {
        // arrange
        when(
          mockHttpClient.get(Uri.parse(endpoint)),
        ).thenAnswer((_) async => http.Response('Not Found', 404));
        // act & assert
        expect(
          () async => await dataSource.getTopRatedMovies(),
          throwsA(isA<ServerException>()),
        );
      },
    );
  });

  group('get movie detail', () {
    final endpoint = '$baseUrl/movie/$tMovieId?$apiKey';
    final jsonPath = 'dummy_data/movie_detail.json';
    final tMovieDetail = MovieDetailResponse.fromJson(
      json.decode(readJson(jsonPath)),
    );

    test('should return movie detail when the response code is 200', () async {
      // arrange
      when(
        mockHttpClient.get(Uri.parse(endpoint)),
      ).thenAnswer((_) async => http.Response(readJson(jsonPath), 200));
      // act
      final result = await dataSource.getMovieDetail(tMovieId);
      // assert
      expect(result, equals(tMovieDetail));
    });

    test(
      'should throw Server Exception when the response code is 404 or other',
      () async {
        // arrange
        when(
          mockHttpClient.get(Uri.parse(endpoint)),
        ).thenAnswer((_) async => http.Response('Not Found', 404));
        // act & assert
        expect(
          () async => await dataSource.getMovieDetail(tMovieId),
          throwsA(isA<ServerException>()),
        );
      },
    );
  });

  group('get movie recommendations', () {
    final endpoint = '$baseUrl/movie/$tMovieId/recommendations?$apiKey';
    final jsonPath = 'dummy_data/movie_recommendations.json';
    final tMovieList =
        MovieResponse.fromJson(json.decode(readJson(jsonPath))).movieList;

    test(
      'should return list of Movie Model when the response code is 200',
      () async {
        // arrange
        when(
          mockHttpClient.get(Uri.parse(endpoint)),
        ).thenAnswer((_) async => http.Response(readJson(jsonPath), 200));
        // act
        final result = await dataSource.getMovieRecommendations(tMovieId);
        // assert
        expect(result, equals(tMovieList));
      },
    );

    test(
      'should throw Server Exception when the response code is 404 or other',
      () async {
        // arrange
        when(
          mockHttpClient.get(Uri.parse(endpoint)),
        ).thenAnswer((_) async => http.Response('Not Found', 404));
        // act & assert
        expect(
          () async => await dataSource.getMovieRecommendations(tMovieId),
          throwsA(isA<ServerException>()),
        );
      },
    );
  });

  group('search movies', () {
    final endpoint = '$baseUrl/search/movie?$apiKey&query=$tQuery';
    final jsonPath = 'dummy_data/search_spiderman_movie.json';
    final tSearchResult =
        MovieResponse.fromJson(json.decode(readJson(jsonPath))).movieList;

    test('should return list of movies when response code is 200', () async {
      // arrange
      when(
        mockHttpClient.get(Uri.parse(endpoint)),
      ).thenAnswer((_) async => http.Response(readJson(jsonPath), 200));
      // act
      final result = await dataSource.searchMovies(tQuery);
      // assert
      expect(result, tSearchResult);
    });

    test(
      'should throw ServerException when response code is other than 200',
      () async {
        // arrange
        when(
          mockHttpClient.get(Uri.parse(endpoint)),
        ).thenAnswer((_) async => http.Response('Not Found', 404));
        // act & assert
        expect(
          () async => await dataSource.searchMovies(tQuery),
          throwsA(isA<ServerException>()),
        );
      },
    );
  });
}
