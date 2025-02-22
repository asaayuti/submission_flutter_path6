import 'dart:convert';

import 'package:ditonton/common/constants.dart';
import 'package:ditonton/data/datasources/tv_series/tv_series_remote_data_source.dart';
import 'package:ditonton/common/exception.dart';
import 'package:ditonton/data/models/tv_series/tv_series_detail_model.dart';
import 'package:ditonton/data/models/tv_series/tv_series_response.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';

import '../../../json_reader.dart';
import '../../../helpers/test_helper.mocks.dart';

void main() {
  late TvSeriesRemoteDataSourceImpl dataSource;
  late MockHttpClient mockHttpClient;

  setUp(() {
    mockHttpClient = MockHttpClient();
    dataSource = TvSeriesRemoteDataSourceImpl(client: mockHttpClient);
  });

  group('get Now Playing TvSeries', () {
    final endpoint = '$baseUrl/tv/on_the_air?$apiKey';
    final jsonPath = 'dummy_data/tv_series/now_playing.json';
    final tTvSeriesList =
        TvSeriesResponse.fromJson(json.decode(readJson(jsonPath))).tvSeriesList;

    test(
      'should return list of TvSeries Model when the response code is 200',
      () async {
        // arrange
        when(
          mockHttpClient.get(Uri.parse(endpoint)),
        ).thenAnswer((_) async => http.Response(readJson(jsonPath), 200));
        // act
        final result = await dataSource.getNowPlayingTvSeries();
        // assert
        expect(result, equals(tTvSeriesList));
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
          () async => await dataSource.getNowPlayingTvSeries(),
          throwsA(isA<ServerException>()),
        );
      },
    );
  });

  group('get Popular TvSeries', () {
    final endpoint = '$baseUrl/tv/popular?$apiKey';
    final jsonPath = 'dummy_data/tv_series/popular.json';
    final tTvSeriesList =
        TvSeriesResponse.fromJson(json.decode(readJson(jsonPath))).tvSeriesList;

    test(
      'should return list of tvSeriess when response is success (200)',
      () async {
        // arrange
        when(
          mockHttpClient.get(Uri.parse(endpoint)),
        ).thenAnswer((_) async => http.Response(readJson(jsonPath), 200));
        // act
        final result = await dataSource.getPopularTvSeries();
        // assert
        expect(result, tTvSeriesList);
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
          () async => await dataSource.getPopularTvSeries(),
          throwsA(isA<ServerException>()),
        );
      },
    );
  });

  group('get Top Rated TvSeries', () {
    final endpoint = '$baseUrl/tv/top_rated?$apiKey';
    final jsonPath = 'dummy_data/tv_series/top_rated.json';
    final tTvSeriesList =
        TvSeriesResponse.fromJson(json.decode(readJson(jsonPath))).tvSeriesList;

    test('should return list of tvSeriess when response code is 200', () async {
      // arrange
      when(
        mockHttpClient.get(Uri.parse(endpoint)),
      ).thenAnswer((_) async => http.Response(readJson(jsonPath), 200));
      // act
      final result = await dataSource.getTopRatedTvSeries();
      // assert
      expect(result, tTvSeriesList);
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
          () async => await dataSource.getTopRatedTvSeries(),
          throwsA(isA<ServerException>()),
        );
      },
    );
  });

  group('get tvSeries detail', () {
    final tId = 1;
    final endpoint = '$baseUrl/tv/$tId?$apiKey';
    final jsonPath = 'dummy_data/tv_series/tv_series_detail.json';
    final tTvSeriesDetail = TvSeriesDetailResponse.fromJson(
      json.decode(readJson(jsonPath)),
    );

    test(
      'should return tvSeries detail when the response code is 200',
      () async {
        // arrange
        when(
          mockHttpClient.get(Uri.parse(endpoint)),
        ).thenAnswer((_) async => http.Response(readJson(jsonPath), 200));
        // act
        final result = await dataSource.getTvSeriesDetail(tId);
        // assert
        expect(result, equals(tTvSeriesDetail));
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
          () async => await dataSource.getTvSeriesDetail(tId),
          throwsA(isA<ServerException>()),
        );
      },
    );
  });

  group('get tvSeries recommendations', () {
    final tId = 1;
    final endpoint = '$baseUrl/tv/$tId/recommendations?$apiKey';
    final jsonPath = 'dummy_data/tv_series/tv_series_recommendations.json';
    final tTvSeriesList =
        TvSeriesResponse.fromJson(json.decode(readJson(jsonPath))).tvSeriesList;

    test(
      'should return list of TvSeries Model when the response code is 200',
      () async {
        // arrange
        when(
          mockHttpClient.get(Uri.parse(endpoint)),
        ).thenAnswer((_) async => http.Response(readJson(jsonPath), 200));
        // act
        final result = await dataSource.getTvSeriesRecommendations(tId);
        // assert
        expect(result, equals(tTvSeriesList));
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
          () async => await dataSource.getTvSeriesRecommendations(tId),
          throwsA(isA<ServerException>()),
        );
      },
    );
  });

  group('search tvSeriess', () {
    final tQuery = 'Spiderman';
    final endpoint = '$baseUrl/search/tv?$apiKey&query=$tQuery';
    final jsonPath = 'dummy_data/tv_series/search_spiderman_tv_series.json';
    final tSearchResult =
        TvSeriesResponse.fromJson(json.decode(readJson(jsonPath))).tvSeriesList;

    test('should return list of tvSeriess when response code is 200', () async {
      // arrange
      when(
        mockHttpClient.get(Uri.parse(endpoint)),
      ).thenAnswer((_) async => http.Response(readJson(jsonPath), 200));
      // act
      final result = await dataSource.searchTvSeries(tQuery);
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
          () async => await dataSource.searchTvSeries(tQuery),
          throwsA(isA<ServerException>()),
        );
      },
    );
  });
}
