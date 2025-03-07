import 'package:movies/data/models/genre_model.dart';
import 'package:movies/domain/entities/genre.dart';
import 'package:tv_series/data/models/tv_series_detail_model.dart';
import 'package:tv_series/data/models/tv_series_model.dart';
import 'package:tv_series/data/models/tv_series_table.dart';
import 'package:tv_series/domain/entities/tv_series.dart';
import 'package:tv_series/domain/entities/tv_series_detail.dart';

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
  popularity: 14.278,
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
  popularity: 14.278,
  posterPath: "/peN9aqevr0edVoctVKGZDWFdTRl.jpg",
  firstAirDate: "1994-11-19",
  name: "Spider-Man",
  voteAverage: 8.3,
  voteCount: 1037,
);

final tTvSeriesModelList = <TvSeriesModel>[tTvSeriesModel];
final tTvSeriesList = <TvSeries>[tTvSeries];

final tTvSeriesId = 1;
final tTvSeriesQuery = 'spiderman';

final tEmptyTvSeriesList = <TvSeries>[];
final tEmptyTvSeriesModelList = <TvSeriesModel>[];

final tTvSeriesDetailResponse = TvSeriesDetailResponse(
  adult: false,
  backdropPath: "/path_to_backdrop.jpg",
  episodeRunTime: [42],
  firstAirDate: "2021-09-17",
  genres: [
    GenreModel(id: 18, name: "Drama"),
    GenreModel(id: 9648, name: "Mystery"),
  ],
  homepage: "https://www.example.com",
  id: 1,
  inProduction: true,
  languages: ["en", "es"],
  lastAirDate: "2023-06-12",
  name: "Sample TV Series",
  numberOfEpisodes: 50,
  numberOfSeasons: 5,
  originCountry: ["US"],
  originalLanguage: "en",
  originalName: "Sample TV Series Original",
  overview: "This is a sample TV series overview.",
  popularity: 150.5,
  posterPath: "/path_to_poster.jpg",
  status: "Ended",
  tagline: "An amazing journey awaits!",
  type: "Scripted",
  voteAverage: 8.5,
  voteCount: 1500,
);

final tTvSeriesDetail = TvSeriesDetail(
  adult: false,
  backdropPath: "/path_to_backdrop.jpg",
  episodeRunTime: [42],
  firstAirDate: "2021-09-17",
  genres: [Genre(id: 18, name: "Drama"), Genre(id: 9648, name: "Mystery")],
  id: 1,
  name: "Sample TV Series",
  originalName: "Sample TV Series Original",
  overview: "This is a sample TV series overview.",
  posterPath: "/path_to_poster.jpg",
  voteAverage: 8.5,
  voteCount: 1500,
);

final tTvSeriesTable = TvSeriesTable(
  id: 1,
  name: 'Sample TV Series',
  posterPath: '/path_to_poster.jpg',
  overview: 'This is a sample TV series overview.',
);

final tTvSeriesMap = {
  'id': 1,
  'overview': 'This is a sample TV series overview.',
  'posterPath': '/path_to_poster.jpg',
  'name': 'Sample TV Series',
};

final tWatchlistTvSeries = TvSeries.watchlist(
  id: 1,
  name: 'Sample TV Series',
  posterPath: '/path_to_poster.jpg',
  overview: 'This is a sample TV series overview.',
);
