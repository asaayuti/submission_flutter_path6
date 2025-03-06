import 'dart:convert';

import 'package:core/data/models/tv_series/tv_series_model.dart';
import 'package:core/data/models/tv_series/tv_series_response.dart';
import 'package:core/utils/dummy_tv_series.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../json_reader.dart';

void main() {
  final tTvSeriesResponseModel = TvSeriesResponse(
    tvSeriesList: <TvSeriesModel>[tTvSeriesModel],
  );
  group('fromJson', () {
    test('should return a valid model from JSON', () async {
      // arrange
      final Map<String, dynamic> jsonMap = json.decode(
        readJson('dummy_data/tv_series/now_playing.json'),
      );
      // act
      final result = TvSeriesResponse.fromJson(jsonMap);
      // assert
      expect(result, tTvSeriesResponseModel);
    });
  });

  group('toJson', () {
    test('should return a JSON map containing proper data', () async {
      // arrange

      // act
      final result = tTvSeriesResponseModel.toJson();
      // assert
      final expectedJsonMap = {
        "results": [
          {
            "adult": false,
            "backdrop_path": "/lN09YohDmsqyljNzykQxV0quvK.jpg",
            "genre_ids": [16, 10759],
            "id": 888,
            "origin_country": ["US"],
            "original_language": "en",
            "original_name": "Spider-Man",
            "overview":
                "Bitten by a neogenetic spider, Peter Parker develops spider-like superpowers. He uses these to fight crime while trying to balance it with the struggles of his personal life.",
            "popularity": 14.278,
            "poster_path": "/peN9aqevr0edVoctVKGZDWFdTRl.jpg",
            "first_air_date": "1994-11-19",
            "name": "Spider-Man",
            "vote_average": 8.3,
            "vote_count": 1037,
          },
        ],
      };

      expect(result, expectedJsonMap);
    });
  });
}
