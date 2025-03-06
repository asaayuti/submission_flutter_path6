import 'package:bloc_test/bloc_test.dart';
import 'package:movies/domain/usecases/get_movie_detail.dart';
import 'package:movies/domain/usecases/get_movie_recommendations.dart';
import 'package:movies/domain/usecases/get_watchlist_status.dart';
import 'package:movies/domain/usecases/remove_watchlist.dart';
import 'package:movies/domain/usecases/save_watchlist.dart';
import 'package:movies/presentation/bloc/movie_detail_bloc.dart';
import 'package:movies/presentation/bloc/movie_detail_event.dart';
import 'package:movies/presentation/bloc/movie_detail_state.dart';
import 'package:core/utils/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:movies/dummy_data/dummy_movie_objects.dart';

@GenerateMocks([
  GetMovieDetail,
  GetMovieRecommendations,
  GetWatchlistStatus,
  SaveWatchlist,
  RemoveWatchlist,
])
import 'movie_detail_bloc_test.mocks.dart';

void main() {
  late MovieDetailBloc bloc;
  late MockGetMovieDetail mockGetMovieDetail;
  late MockGetMovieRecommendations mockGetMovieRecommendations;
  late MockGetWatchlistStatus mockGetWatchListStatus;
  late MockSaveWatchlist mockSaveWatchlist;
  late MockRemoveWatchlist mockRemoveWatchlist;

  setUp(() {
    mockGetMovieDetail = MockGetMovieDetail();
    mockGetMovieRecommendations = MockGetMovieRecommendations();
    mockGetWatchListStatus = MockGetWatchlistStatus();
    mockSaveWatchlist = MockSaveWatchlist();
    mockRemoveWatchlist = MockRemoveWatchlist();

    bloc = MovieDetailBloc(
      getMovieDetail: mockGetMovieDetail,
      getMovieRecommendations: mockGetMovieRecommendations,
      getWatchListStatus: mockGetWatchListStatus,
      saveWatchlist: mockSaveWatchlist,
      removeWatchlist: mockRemoveWatchlist,
    );
  });

  group('FetchMovieDetail', () {
    blocTest<MovieDetailBloc, MovieDetailState>(
      'emits [MovieDetailLoading, MovieDetailLoaded] when data is fetched successfully',
      build: () {
        when(
          mockGetMovieDetail.execute(tMovieId),
        ).thenAnswer((_) async => Right(tMovieDetail));
        when(
          mockGetMovieRecommendations.execute(tMovieId),
        ).thenAnswer((_) async => Right(tMovieList));
        when(
          mockGetWatchListStatus.execute(tMovieId),
        ).thenAnswer((_) async => true);
        return bloc;
      },
      act: (bloc) => bloc.add(FetchMovieDetail(tMovieId)),
      expect:
          () => [
            MovieDetailLoading(),
            MovieDetailHasData(
              movie: tMovieDetail,
              recommendations: tMovieList,
              isAddedToWatchlist: true,
            ),
          ],
    );

    blocTest<MovieDetailBloc, MovieDetailState>(
      'emits [MovieDetailLoading, MovieDetailError] when getMovieDetail fails',
      build: () {
        when(
          mockGetMovieDetail.execute(tMovieId),
        ).thenAnswer((_) async => Left(ServerFailure('Server Failure')));
        when(
          mockGetMovieRecommendations.execute(tMovieId),
        ).thenAnswer((_) async => Right(tMovieList));
        when(
          mockGetWatchListStatus.execute(tMovieId),
        ).thenAnswer((_) async => true);
        return bloc;
      },
      act: (bloc) => bloc.add(FetchMovieDetail(tMovieId)),
      expect: () => [MovieDetailLoading(), MovieDetailError('Server Failure')],
    );
  });

  group('AddWatchlist', () {
    blocTest<MovieDetailBloc, MovieDetailState>(
      'emits updated state with watchlistMessage when AddWatchlist is added',
      build: () {
        when(
          mockSaveWatchlist.execute(tMovieDetail),
        ).thenAnswer((_) async => Right("Added to Watchlist"));
        when(
          mockGetWatchListStatus.execute(tMovieId),
        ).thenAnswer((_) async => true);
        return bloc;
      },
      seed:
          () => MovieDetailHasData(
            movie: tMovieDetail,
            recommendations: tMovieList,
            isAddedToWatchlist: false,
          ),
      act: (bloc) => bloc.add(AddWatchlist(tMovieDetail)),
      expect:
          () => [
            MovieDetailHasData(
              movie: tMovieDetail,
              recommendations: tMovieList,
              isAddedToWatchlist: true,
              watchlistMessage: "Added to Watchlist",
            ),
          ],
    );
  });

  group('RemoveFromWatchlist', () {
    blocTest<MovieDetailBloc, MovieDetailState>(
      'emits updated state with watchlistMessage when RemoveFromWatchlist is added',
      build: () {
        when(
          mockRemoveWatchlist.execute(tMovieDetail),
        ).thenAnswer((_) async => Right("Removed from Watchlist"));
        when(
          mockGetWatchListStatus.execute(tMovieId),
        ).thenAnswer((_) async => false);
        return bloc;
      },
      seed:
          () => MovieDetailHasData(
            movie: tMovieDetail,
            recommendations: tMovieList,
            isAddedToWatchlist: true,
          ),
      act: (bloc) => bloc.add(RemoveFromWatchlist(tMovieDetail)),
      expect:
          () => [
            MovieDetailHasData(
              movie: tMovieDetail,
              recommendations: tMovieList,
              isAddedToWatchlist: false,
              watchlistMessage: "Removed from Watchlist",
            ),
          ],
    );
  });

  group('LoadWatchlistStatus', () {
    blocTest<MovieDetailBloc, MovieDetailState>(
      'emits updated state with new watchlist status when LoadWatchlistStatus is added',
      build: () {
        when(
          mockGetWatchListStatus.execute(tMovieId),
        ).thenAnswer((_) async => false);
        return bloc;
      },
      seed:
          () => MovieDetailHasData(
            movie: tMovieDetail,
            recommendations: tMovieList,
            isAddedToWatchlist: true,
          ),
      act: (bloc) => bloc.add(LoadWatchlistStatus(tMovieId)),
      expect:
          () => [
            MovieDetailHasData(
              movie: tMovieDetail,
              recommendations: tMovieList,
              isAddedToWatchlist: false,
              watchlistMessage: '',
            ),
          ],
    );

    blocTest<MovieDetailBloc, MovieDetailState>(
      'does nothing when LoadWatchlistStatus is added in a non-loaded state',
      build: () => bloc,
      seed: () => MovieDetailEmpty(),
      act: (bloc) => bloc.add(LoadWatchlistStatus(tMovieId)),
      expect: () => [],
    );
  });
}
