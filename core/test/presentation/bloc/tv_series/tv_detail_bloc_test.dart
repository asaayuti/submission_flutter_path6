import 'package:bloc_test/bloc_test.dart';

import 'package:core/domain/usecases/tv_series/get_tv_detail.dart';
import 'package:core/domain/usecases/tv_series/get_tv_recommendations.dart';
import 'package:core/domain/usecases/tv_series/get_watchlist_status_tv_series.dart';
import 'package:core/domain/usecases/tv_series/remove_watchlist_tv.dart';
import 'package:core/domain/usecases/tv_series/save_watchlist_tv_series.dart';
import 'package:core/presentation/bloc/tv_series/tv_detail_bloc.dart';
import 'package:core/presentation/bloc/tv_series/tv_detail_event.dart';
import 'package:core/presentation/bloc/tv_series/tv_detail_state.dart';
import 'package:core/utils/dummy_data/dummy_tv_series.dart';
import 'package:core/utils/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'tv_detail_bloc_test.mocks.dart';

@GenerateMocks([
  GetTvDetail,
  GetTvRecommendations,
  GetWatchlistStatusTv,
  SaveWatchlistTv,
  RemoveWatchlistTv,
])
void main() {
  late TvDetailBloc bloc;
  late MockGetTvDetail mockGetTvDetail;
  late MockGetTvRecommendations mockGetTvRecommendations;
  late MockGetWatchlistStatusTv mockGetWatchListStatus;
  late MockSaveWatchlistTv mockSaveWatchlist;
  late MockRemoveWatchlistTv mockRemoveWatchlist;

  setUp(() {
    mockGetTvDetail = MockGetTvDetail();
    mockGetTvRecommendations = MockGetTvRecommendations();
    mockGetWatchListStatus = MockGetWatchlistStatusTv();
    mockSaveWatchlist = MockSaveWatchlistTv();
    mockRemoveWatchlist = MockRemoveWatchlistTv();

    bloc = TvDetailBloc(
      getTvDetail: mockGetTvDetail,
      getTvRecommendations: mockGetTvRecommendations,
      getWatchListStatus: mockGetWatchListStatus,
      saveWatchlist: mockSaveWatchlist,
      removeWatchlist: mockRemoveWatchlist,
    );
  });

  group('FetchTvDetail', () {
    blocTest<TvDetailBloc, TvDetailState>(
      'emits [TvDetailLoading, TvDetailLoaded] when data is fetched successfully',
      build: () {
        when(
          mockGetTvDetail.execute(tTvId),
        ).thenAnswer((_) async => Right(tTvSeriesDetail));
        when(
          mockGetTvRecommendations.execute(tTvId),
        ).thenAnswer((_) async => Right(tTvSeriesList));
        when(
          mockGetWatchListStatus.execute(tTvId),
        ).thenAnswer((_) async => true);
        return bloc;
      },
      act: (bloc) => bloc.add(FetchTvDetail(tTvId)),
      expect:
          () => [
            TvDetailLoading(),
            TvDetailHasData(
              tvSeries: tTvSeriesDetail,
              recommendations: tTvSeriesList,
              isAddedToWatchlist: true,
            ),
          ],
    );

    blocTest<TvDetailBloc, TvDetailState>(
      'emits [TvDetailLoading, TvDetailError] when getTvDetail fails',
      build: () {
        when(
          mockGetTvDetail.execute(tTvId),
        ).thenAnswer((_) async => Left(ServerFailure('Server Failure')));
        when(
          mockGetTvRecommendations.execute(tTvId),
        ).thenAnswer((_) async => Right(tTvSeriesList));
        when(
          mockGetWatchListStatus.execute(tTvId),
        ).thenAnswer((_) async => true);
        return bloc;
      },
      act: (bloc) => bloc.add(FetchTvDetail(tTvId)),
      expect: () => [TvDetailLoading(), TvDetailError('Server Failure')],
    );
  });

  group('AddWatchlist', () {
    blocTest<TvDetailBloc, TvDetailState>(
      'emits updated state with watchlistMessage when AddWatchlist is added',
      build: () {
        when(
          mockSaveWatchlist.execute(tTvSeriesDetail),
        ).thenAnswer((_) async => Right("Added to Watchlist"));
        when(
          mockGetWatchListStatus.execute(tTvId),
        ).thenAnswer((_) async => true);
        return bloc;
      },
      seed:
          () => TvDetailHasData(
            tvSeries: tTvSeriesDetail,
            recommendations: tTvSeriesList,
            isAddedToWatchlist: false,
          ),
      act: (bloc) => bloc.add(AddWatchlist(tTvSeriesDetail)),
      expect:
          () => [
            TvDetailHasData(
              tvSeries: tTvSeriesDetail,
              recommendations: tTvSeriesList,
              isAddedToWatchlist: true,
              watchlistMessage: "Added to Watchlist",
            ),
          ],
    );
  });

  group('RemoveFromWatchlist', () {
    blocTest<TvDetailBloc, TvDetailState>(
      'emits updated state with watchlistMessage when RemoveFromWatchlist is added',
      build: () {
        when(
          mockRemoveWatchlist.execute(tTvSeriesDetail),
        ).thenAnswer((_) async => Right("Removed from Watchlist"));
        when(
          mockGetWatchListStatus.execute(tTvId),
        ).thenAnswer((_) async => false);
        return bloc;
      },
      seed:
          () => TvDetailHasData(
            tvSeries: tTvSeriesDetail,
            recommendations: tTvSeriesList,
            isAddedToWatchlist: true,
          ),
      act: (bloc) => bloc.add(RemoveFromWatchlist(tTvSeriesDetail)),
      expect:
          () => [
            TvDetailHasData(
              tvSeries: tTvSeriesDetail,
              recommendations: tTvSeriesList,
              isAddedToWatchlist: false,
              watchlistMessage: "Removed from Watchlist",
            ),
          ],
    );
  });

  group('LoadWatchlistStatus', () {
    blocTest<TvDetailBloc, TvDetailState>(
      'emits updated state with new watchlist status when LoadWatchlistStatus is added',
      build: () {
        when(
          mockGetWatchListStatus.execute(tTvId),
        ).thenAnswer((_) async => false);
        return bloc;
      },
      seed:
          () => TvDetailHasData(
            tvSeries: tTvSeriesDetail,
            recommendations: tTvSeriesList,
            isAddedToWatchlist: true,
          ),
      act: (bloc) => bloc.add(LoadWatchlistStatus(tTvId)),
      expect:
          () => [
            TvDetailHasData(
              tvSeries: tTvSeriesDetail,
              recommendations: tTvSeriesList,
              isAddedToWatchlist: false,
              watchlistMessage: '',
            ),
          ],
    );

    blocTest<TvDetailBloc, TvDetailState>(
      'does nothing when LoadWatchlistStatus is added in a non-loaded state',
      build: () => bloc,
      seed: () => TvDetailEmpty(),
      act: (bloc) => bloc.add(LoadWatchlistStatus(tTvId)),
      expect: () => [],
    );
  });
}
