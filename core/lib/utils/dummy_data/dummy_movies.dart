import 'package:core/data/models/genre_model.dart';
import 'package:core/data/models/movie/movie_detail_model.dart';
import 'package:core/data/models/movie/movie_model.dart';
import 'package:core/data/models/movie/movie_table.dart';
import 'package:core/domain/entities/genre.dart';
import 'package:core/domain/entities/movie/movie.dart';
import 'package:core/domain/entities/movie/movie_detail.dart';

final tMovieModel = MovieModel(
  adult: false,
  backdropPath: '/muth4OYamXf41G2evdrLEg8d3om.jpg',
  genreIds: [14, 28],
  id: 557,
  originalTitle: 'Spider-Man',
  overview:
      'After being bitten by a genetically altered spider, nerdy high school student Peter Parker is endowed with amazing powers to become the Amazing superhero known as Spider-Man.',
  popularity: 60.441,
  posterPath: '/rweIrveL43TaxUN0akQEaAXL6x0.jpg',
  releaseDate: '2002-05-01',
  title: 'Spider-Man',
  video: false,
  voteAverage: 7.2,
  voteCount: 13507,
);

final tMovie = Movie(
  adult: false,
  backdropPath: '/muth4OYamXf41G2evdrLEg8d3om.jpg',
  genreIds: [14, 28],
  id: 557,
  originalTitle: 'Spider-Man',
  overview:
      'After being bitten by a genetically altered spider, nerdy high school student Peter Parker is endowed with amazing powers to become the Amazing superhero known as Spider-Man.',
  popularity: 60.441,
  posterPath: '/rweIrveL43TaxUN0akQEaAXL6x0.jpg',
  releaseDate: '2002-05-01',
  title: 'Spider-Man',
  video: false,
  voteAverage: 7.2,
  voteCount: 13507,
);

final tMovieModelList = <MovieModel>[tMovieModel];
final tMovieList = <Movie>[tMovie];

final tQuery = 'spiderman';
final tMovieId = 1;

final tEmptyMovieList = <Movie>[];
final tEmptyMovieModelList = <MovieModel>[];

final tMovieDetailResponse = MovieDetailResponse(
  adult: false,
  backdropPath: 'backdropPath',
  budget: 100,
  genres: [GenreModel(id: 1, name: 'Action')],
  homepage: "https://google.com",
  id: 1,
  imdbId: 'imdb1',
  originalLanguage: 'en',
  originalTitle: 'originalTitle',
  overview: 'overview',
  popularity: 1,
  posterPath: 'posterPath',
  releaseDate: 'releaseDate',
  revenue: 12000,
  runtime: 120,
  status: 'Status',
  tagline: 'Tagline',
  title: 'title',
  video: false,
  voteAverage: 1,
  voteCount: 1,
);

final tMovieDetail = MovieDetail(
  adult: false,
  backdropPath: 'backdropPath',
  genres: [Genre(id: 1, name: 'Action')],
  id: 1,
  originalTitle: 'originalTitle',
  overview: 'overview',
  posterPath: 'posterPath',
  releaseDate: 'releaseDate',
  runtime: 120,
  title: 'title',
  voteAverage: 1,
  voteCount: 1,
);

final tWatchlistMovie = Movie.watchlist(
  id: 1,
  title: 'title',
  posterPath: 'posterPath',
  overview: 'overview',
);

final tMovieTable = MovieTable(
  id: 1,
  title: 'title',
  posterPath: 'posterPath',
  overview: 'overview',
);

final tMovieMap = {
  'id': 1,
  'overview': 'overview',
  'posterPath': 'posterPath',
  'title': 'title',
};
