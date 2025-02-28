import 'package:core/domain/usecases/tv_series/get_tv_series_detail.dart';
import 'package:core/domain/usecases/tv_series/get_tv_series_recommendations.dart';
import 'package:core/domain/usecases/tv_series/get_watchlist_status_tv_series.dart';
import 'package:core/domain/usecases/tv_series/remove_watchlist_tv_series.dart';
import 'package:core/domain/usecases/tv_series/save_watchlist_tv_series.dart';
import 'package:core/presentation/provider/tv_series/tv_series_detail_notifier.dart';
import 'package:core/utils/failure.dart';
import 'package:core/utils/state_enum.dart';
import 'package:dartz/dartz.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:core/utils/dummy_data/movies/dummy_objects.dart';
import 'package:core/utils/dummy_data/tv_series/dummy_objects.dart';
import 'tv_series_detail_notifier_test.mocks.dart';

@GenerateMocks([
  GetTvSeriesDetail,
  GetTvSeriesRecommendations,
  GetWatchlistStatusTvSeries,
  SaveWatchlistTvSeries,
  RemoveWatchlistTvSeries,
])
void main() {
  late TvSeriesDetailNotifier provider;
  late MockGetTvSeriesDetail mockGetTvSeriesDetail;
  late MockGetTvSeriesRecommendations mockGetTvSeriesRecommendations;
  late MockGetWatchlistStatusTvSeries mockGetWatchlistStatus;
  late MockSaveWatchlistTvSeries mockSaveWatchlist;
  late MockRemoveWatchlistTvSeries mockRemoveWatchlist;
  late int listenerCallCount;

  setUp(() {
    listenerCallCount = 0;
    mockGetTvSeriesDetail = MockGetTvSeriesDetail();
    mockGetTvSeriesRecommendations = MockGetTvSeriesRecommendations();
    mockGetWatchlistStatus = MockGetWatchlistStatusTvSeries();
    mockSaveWatchlist = MockSaveWatchlistTvSeries();
    mockRemoveWatchlist = MockRemoveWatchlistTvSeries();
    provider = TvSeriesDetailNotifier(
      getTvSeriesDetail: mockGetTvSeriesDetail,
      getTvSeriesRecommendations: mockGetTvSeriesRecommendations,
      getWatchListStatus: mockGetWatchlistStatus,
      saveWatchlist: mockSaveWatchlist,
      removeWatchlist: mockRemoveWatchlist,
    )..addListener(() {
      listenerCallCount += 1;
    });
  });

  void arrangeUsecase() {
    when(
      mockGetTvSeriesDetail.execute(tMovieId),
    ).thenAnswer((_) async => Right(tTvSeriesDetail));
    when(
      mockGetTvSeriesRecommendations.execute(tMovieId),
    ).thenAnswer((_) async => Right(tTvSeriesList));
  }

  group('Get TvSeries Detail', () {
    test('should get data from the usecase', () async {
      // arrange
      arrangeUsecase();
      // act
      await provider.fetchTvSeriesDetail(tMovieId);
      // assert
      verify(mockGetTvSeriesDetail.execute(tMovieId));
      verify(mockGetTvSeriesRecommendations.execute(tMovieId));
    });

    test('should change state to Loading when usecase is called', () {
      // arrange
      arrangeUsecase();
      // act
      provider.fetchTvSeriesDetail(tMovieId);
      // assert
      expect(provider.tvSeriesState, RequestState.loading);
      expect(listenerCallCount, 1);
    });

    test('should change tvSeries when data is gotten successfully', () async {
      // arrange
      arrangeUsecase();
      // act
      await provider.fetchTvSeriesDetail(tMovieId);
      // assert
      expect(provider.tvSeriesState, RequestState.loaded);
      expect(provider.tvSeries, tTvSeriesDetail);
      expect(listenerCallCount, 3);
    });

    test(
      'should change recommendation tvSeriess when data is gotten successfully',
      () async {
        // arrange
        arrangeUsecase();
        // act
        await provider.fetchTvSeriesDetail(tMovieId);
        // assert
        expect(provider.tvSeriesState, RequestState.loaded);
        expect(provider.tvSeriesRecommendations, tTvSeriesList);
      },
    );
  });

  group('Get TvSeries Recommendations', () {
    test('should get data from the usecase', () async {
      // arrange
      arrangeUsecase();
      // act
      await provider.fetchTvSeriesDetail(tMovieId);
      // assert
      verify(mockGetTvSeriesRecommendations.execute(tMovieId));
      expect(provider.tvSeriesRecommendations, tTvSeriesList);
    });

    test(
      'should update recommendation state when data is gotten successfully',
      () async {
        // arrange
        arrangeUsecase();
        // act
        await provider.fetchTvSeriesDetail(tMovieId);
        // assert
        expect(provider.recommendationState, RequestState.loaded);
        expect(provider.tvSeriesRecommendations, tTvSeriesList);
      },
    );

    test('should update error message when request in successful', () async {
      // arrange
      when(
        mockGetTvSeriesDetail.execute(tMovieId),
      ).thenAnswer((_) async => Right(tTvSeriesDetail));
      when(
        mockGetTvSeriesRecommendations.execute(tMovieId),
      ).thenAnswer((_) async => Left(ServerFailure('Failed')));
      // act
      await provider.fetchTvSeriesDetail(tMovieId);
      // assert
      expect(provider.recommendationState, RequestState.error);
      expect(provider.message, 'Failed');
    });
  });

  group('Watchlist', () {
    test('should get the watchlist status', () async {
      // arrange
      when(mockGetWatchlistStatus.execute(1)).thenAnswer((_) async => true);
      // act
      await provider.loadWatchlistStatus(1);
      // assert
      expect(provider.isAddedToWatchlist, true);
    });

    test('should execute save watchlist when function called', () async {
      // arrange
      when(
        mockSaveWatchlist.execute(tTvSeriesDetail),
      ).thenAnswer((_) async => Right('Success'));
      when(
        mockGetWatchlistStatus.execute(tTvSeriesDetail.id),
      ).thenAnswer((_) async => true);
      // act
      await provider.addWatchlist(tTvSeriesDetail);
      // assert
      verify(mockSaveWatchlist.execute(tTvSeriesDetail));
    });

    test('should execute remove watchlist when function called', () async {
      // arrange
      when(
        mockRemoveWatchlist.execute(tTvSeriesDetail),
      ).thenAnswer((_) async => Right('Removed'));
      when(
        mockGetWatchlistStatus.execute(tTvSeriesDetail.id),
      ).thenAnswer((_) async => false);
      // act
      await provider.removeFromWatchlist(tTvSeriesDetail);
      // assert
      verify(mockRemoveWatchlist.execute(tTvSeriesDetail));
    });

    test('should update watchlist status when add watchlist success', () async {
      // arrange
      when(
        mockSaveWatchlist.execute(tTvSeriesDetail),
      ).thenAnswer((_) async => Right('Added to Watchlist'));
      when(
        mockGetWatchlistStatus.execute(tTvSeriesDetail.id),
      ).thenAnswer((_) async => true);
      // act
      await provider.addWatchlist(tTvSeriesDetail);
      // assert
      verify(mockGetWatchlistStatus.execute(tTvSeriesDetail.id));
      expect(provider.isAddedToWatchlist, true);
      expect(provider.watchlistMessage, 'Added to Watchlist');
      expect(listenerCallCount, 1);
    });

    test('should update watchlist message when add watchlist failed', () async {
      // arrange
      when(
        mockSaveWatchlist.execute(tTvSeriesDetail),
      ).thenAnswer((_) async => Left(DatabaseFailure('Failed')));
      when(
        mockGetWatchlistStatus.execute(tTvSeriesDetail.id),
      ).thenAnswer((_) async => false);
      // act
      await provider.addWatchlist(tTvSeriesDetail);
      // assert
      expect(provider.watchlistMessage, 'Failed');
      expect(listenerCallCount, 1);
    });
  });

  group('on Error', () {
    test('should return error when data is unsuccessful', () async {
      // arrange
      when(
        mockGetTvSeriesDetail.execute(tMovieId),
      ).thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      when(
        mockGetTvSeriesRecommendations.execute(tMovieId),
      ).thenAnswer((_) async => Right(tTvSeriesList));
      // act
      await provider.fetchTvSeriesDetail(tMovieId);
      // assert
      expect(provider.tvSeriesState, RequestState.error);
      expect(provider.message, 'Server Failure');
      expect(listenerCallCount, 2);
    });
  });
}
