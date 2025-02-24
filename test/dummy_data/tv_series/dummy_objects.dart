import 'package:ditonton/data/models/genre_model.dart';
import 'package:ditonton/data/models/tv_series/tv_series_detail_model.dart';
import 'package:ditonton/data/models/tv_series/tv_series_model.dart';
import 'package:ditonton/data/models/tv_series/tv_series_table.dart';
import 'package:ditonton/domain/entities/genre.dart';
import 'package:ditonton/domain/entities/tv_series/tv_series.dart';
import 'package:ditonton/domain/entities/tv_series/tv_series_detail.dart';

final tTvSeriesModel = TvSeriesModel(
  adult: false,
  backdropPath: "/lN09YohDmsqyljNzykQxV0quvK.jpg",
  genreIds: [16, 10759],
  id: 888,
  originCountry: ["US"],
  originalLanguage: "en",
  originalName: "Spider-Man",
  overview:
      "Bitten by a neogenetic spider, Peter Parker develops spider-like superpowers. He uses these to fight crime while trying to balance it with the struggles of his personal life.",
  popularity: 39.66,
  posterPath: "/peN9aqevr0edVoctVKGZDWFdTRl.jpg",
  firstAirDate: "1994-11-19",
  name: "Spider-Man",
  voteAverage: 8.3,
  voteCount: 1037,
);

final tTvSeries = TvSeries(
  adult: false,
  backdropPath: "/lN09YohDmsqyljNzykQxV0quvK.jpg",
  genreIds: [16, 10759],
  id: 888,
  originCountry: ["US"],
  originalLanguage: "en",
  originalName: "Spider-Man",
  overview:
      "Bitten by a neogenetic spider, Peter Parker develops spider-like superpowers. He uses these to fight crime while trying to balance it with the struggles of his personal life.",
  popularity: 39.66,
  posterPath: "/peN9aqevr0edVoctVKGZDWFdTRl.jpg",
  firstAirDate: "1994-11-19",
  name: "Spider-Man",
  voteAverage: 8.3,
  voteCount: 1037,
);

final tTvSeriesModelList = <TvSeriesModel>[tTvSeriesModel];
final tTvSeriesList = <TvSeries>[tTvSeries];

final tTvSeriesId = 1;

final tEmptyTvSeriesList = <TvSeriesModel>[];

final tTvSeriesDetailResponse = TvSeriesDetailResponse(
  adult: false,
  backdropPath: "/lN09YohDmsqyljNzykQxV0quvK.jpg",
  episodeRunTime: [22],
  firstAirDate: "1994-11-19",
  genres: [
    GenreModel(id: 16, name: "Animation"),
    GenreModel(id: 10759, name: "Action & Adventure"),
  ],
  homepage: "",
  id: 888,
  inProduction: false,
  languages: ["en"],
  lastAirDate: "1998-01-31",
  name: "Spider-Man",
  numberOfEpisodes: 65,
  numberOfSeasons: 5,
  originCountry: ["US"],
  originalLanguage: "en",
  originalName: "Spider-Man",
  overview:
      "Bitten by a neogenetic spider, Peter Parker develops spider-like superpowers. He uses these to fight crime while trying to balance it with the struggles of his personal life.",
  popularity: 14.278,
  posterPath: "/peN9aqevr0edVoctVKGZDWFdTRl.jpg",
  status: "Canceled",
  tagline: "With great power comes great responsibility",
  type: "Scripted",
  voteAverage: 8.3,
  voteCount: 1037,
);

final tTvSeriesDetail = TvSeriesDetail(
  adult: false,
  backdropPath: "/lN09YohDmsqyljNzykQxV0quvK.jpg",
  episodeRunTime: [22],
  firstAirDate: "1994-11-19",
  genres: [
    Genre(id: 16, name: "Animation"),
    Genre(id: 10759, name: "Action & Adventure"),
  ],
  id: 888,
  name: "Spider-Man",
  originalName: "Spider-Man",
  overview:
      "Bitten by a neogenetic spider, Peter Parker develops spider-like superpowers. He uses these to fight crime while trying to balance it with the struggles of his personal life.",
  posterPath: "/peN9aqevr0edVoctVKGZDWFdTRl.jpg",
  voteAverage: 8.3,
  voteCount: 1037,
);

final testTvSeriesTable = TvSeriesTable(
  id: 1,
  name: 'name',
  posterPath: 'posterPath',
  overview: 'overview',
);

final testTvSeriesMap = {
  'id': 1,
  'overview': 'overview',
  'posterPath': 'posterPath',
  'name': 'name',
};

final testTvSeriesDetail = TvSeriesDetail(
  adult: false,
  backdropPath: 'backdropPath',
  genres: [Genre(id: 1, name: 'Action')],
  id: 1,
  originalName: 'originalTitle',
  overview: 'overview',
  posterPath: 'posterPath',
  firstAirDate: 'firstAirDate',
  episodeRunTime: [120],
  name: 'name',
  voteAverage: 1,
  voteCount: 1,
);

final testWatchlistTvSeries = TvSeries.watchlist(
  id: 1,
  name: 'name',
  posterPath: 'posterPath',
  overview: 'overview',
);

final testTvSeries = TvSeries(
  adult: false,
  backdropPath: '/muth4OYamXf41G2evdrLEg8d3om.jpg',
  genreIds: [14, 28],
  id: 557,
  originalName: 'Spider-Man',
  overview:
      'After being bitten by a genetically altered spider, nerdy high school student Peter Parker is endowed with amazing powers to become the Amazing superhero known as Spider-Man.',
  popularity: 60.441,
  posterPath: '/rweIrveL43TaxUN0akQEaAXL6x0.jpg',
  firstAirDate: 'firstAirDate',
  name: 'Spider-Man',
  originCountry: ["CO"],
  originalLanguage: "es",
  voteAverage: 7.2,
  voteCount: 13507,
);

final testTvSeriesList = [testTvSeries];
