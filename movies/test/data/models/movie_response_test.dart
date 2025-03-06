import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';

import 'package:movies/data/models/movie_model.dart';
import 'package:movies/data/models/movie_response.dart';
import 'package:movies/dummy_data/dummy_movie_objects.dart';
import '../../json_reader.dart';

void main() {
  final tMovieResponseModel = MovieResponse(
    movieList: <MovieModel>[tMovieModel],
  );
  group('fromJson', () {
    test('should return a valid model from JSON', () async {
      // arrange
      final Map<String, dynamic> jsonMap = json.decode(
        readJson('dummy_data/now_playing.json'),
      );
      // act
      final result = MovieResponse.fromJson(jsonMap);
      // assert
      expect(result, tMovieResponseModel);
    });
  });

  group('toJson', () {
    test('should return a JSON map containing proper data', () async {
      // arrange

      // act
      final result = tMovieResponseModel.toJson();
      // assert
      final expectedJsonMap = {
        "results": [
          {
            "adult": false,
            "backdrop_path": "/muth4OYamXf41G2evdrLEg8d3om.jpg",
            "genre_ids": [14, 28],
            "id": 557,
            "original_title": "Spider-Man",
            "overview":
                "After being bitten by a genetically altered spider, nerdy high school student Peter Parker is endowed with amazing powers to become the Amazing superhero known as Spider-Man.",
            "popularity": 60.441,
            "poster_path": "/rweIrveL43TaxUN0akQEaAXL6x0.jpg",
            "release_date": "2002-05-01",
            "title": "Spider-Man",
            "video": false,
            "vote_average": 7.2,
            "vote_count": 13507,
          },
        ],
      };

      expect(result, expectedJsonMap);
    });
  });
}
