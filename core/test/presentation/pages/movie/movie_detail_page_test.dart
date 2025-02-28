import 'package:core/presentation/pages/movie/movie_detail_page.dart';
import 'package:core/presentation/provider/movie/movie_detail_notifier.dart';
import 'package:core/utils/state_enum.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

import 'package:core/utils/dummy_data/movies/dummy_objects.dart';
import 'movie_detail_page_test.mocks.dart';

@GenerateMocks([MovieDetailNotifier])
void main() {
  late MockMovieDetailNotifier mockNotifier;

  setUp(() {
    mockNotifier = MockMovieDetailNotifier();
  });

  Widget makeTestableWidget(Widget child) {
    return ChangeNotifierProvider<MovieDetailNotifier>.value(
      value: mockNotifier,
      child: MaterialApp(home: child),
    );
  }

  group('Movie Detail Page Tests', () {
    testWidgets('Displays loading indicator when loading', (tester) async {
      when(mockNotifier.movieState).thenReturn(RequestState.loading);
      when(mockNotifier.movieRecommendations).thenReturn([]);
      when(mockNotifier.isAddedToWatchlist).thenReturn(false);

      await tester.pumpWidget(makeTestableWidget(MovieDetailPage(id: 1)));
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('Displays movie details when data is loaded', (tester) async {
      when(mockNotifier.movieState).thenReturn(RequestState.loaded);
      when(mockNotifier.movie).thenReturn(tMovieDetail);
      when(mockNotifier.recommendationState).thenReturn(RequestState.loaded);
      when(mockNotifier.movieRecommendations).thenReturn([]);
      when(mockNotifier.isAddedToWatchlist).thenReturn(false);

      await tester.pumpWidget(makeTestableWidget(MovieDetailPage(id: 1)));
      await tester.pump();

      expect(find.text(tMovieDetail.title), findsOneWidget);
      expect(find.text('Overview'), findsOneWidget);
    });

    testWidgets('Displays error message when failed', (tester) async {
      when(mockNotifier.movieState).thenReturn(RequestState.error);
      when(mockNotifier.message).thenReturn('Failed to load');

      await tester.pumpWidget(makeTestableWidget(MovieDetailPage(id: 1)));
      expect(find.text('Failed to load'), findsOneWidget);
    });

    testWidgets('Watchlist button works correctly', (tester) async {
      when(mockNotifier.movieState).thenReturn(RequestState.loaded);
      when(mockNotifier.movie).thenReturn(tMovieDetail);
      when(mockNotifier.recommendationState).thenReturn(RequestState.loaded);
      when(mockNotifier.movieRecommendations).thenReturn([]);
      when(mockNotifier.isAddedToWatchlist).thenReturn(false);
      when(
        mockNotifier.watchlistMessage,
      ).thenReturn(MovieDetailNotifier.watchlistAddSuccessMessage);

      await tester.pumpWidget(makeTestableWidget(MovieDetailPage(id: 1)));
      await tester.pump();
      await tester.tap(find.text('Watchlist'));
      await tester.pump();

      verify(mockNotifier.addWatchlist(tMovieDetail)).called(1);
    });

    testWidgets('Displays recommendations correctly', (tester) async {
      when(mockNotifier.movieState).thenReturn(RequestState.loaded);
      when(mockNotifier.movie).thenReturn(tMovieDetail);
      when(mockNotifier.recommendationState).thenReturn(RequestState.loaded);
      when(mockNotifier.movieRecommendations).thenReturn([tMovie]);
      when(mockNotifier.isAddedToWatchlist).thenReturn(false);

      await tester.pumpWidget(makeTestableWidget(MovieDetailPage(id: 1)));
      await tester.pump();

      expect(find.text('Recommendations'), findsOneWidget);
      expect(find.byType(ListView), findsOneWidget);
    });

    testWidgets('Displays loading indicator when recommendations are loading', (
      tester,
    ) async {
      when(mockNotifier.movieState).thenReturn(RequestState.loaded);
      when(mockNotifier.movie).thenReturn(tMovieDetail);
      when(mockNotifier.recommendationState).thenReturn(RequestState.loading);
      when(mockNotifier.movieRecommendations).thenReturn([]);
      when(mockNotifier.isAddedToWatchlist).thenReturn(false);

      await tester.pumpWidget(makeTestableWidget(MovieDetailPage(id: 1)));
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsWidgets);
    });

    testWidgets('Displays error message when recommendations fail', (
      tester,
    ) async {
      when(mockNotifier.movieState).thenReturn(RequestState.loaded);
      when(mockNotifier.movie).thenReturn(tMovieDetail);
      when(mockNotifier.recommendationState).thenReturn(RequestState.error);
      when(mockNotifier.message).thenReturn('Failed to load recommendations');
      when(mockNotifier.movieRecommendations).thenReturn([]);
      when(mockNotifier.isAddedToWatchlist).thenReturn(false);

      await tester.pumpWidget(makeTestableWidget(MovieDetailPage(id: 1)));
      await tester.pump();

      expect(find.text('Failed to load recommendations'), findsOneWidget);
    });

    testWidgets('Displays genres correctly', (tester) async {
      when(mockNotifier.movieState).thenReturn(RequestState.loaded);
      when(mockNotifier.movie).thenReturn(tMovieDetail);
      when(mockNotifier.recommendationState).thenReturn(RequestState.loaded);
      when(mockNotifier.movieRecommendations).thenReturn([tMovie]);
      when(mockNotifier.isAddedToWatchlist).thenReturn(false);

      await tester.pumpWidget(makeTestableWidget(MovieDetailPage(id: 1)));
      await tester.pump();

      for (var genre in tMovieDetail.genres) {
        expect(find.text(genre.name), findsOneWidget);
      }
    });

    testWidgets('Displays runtime duration correctly', (tester) async {
      when(mockNotifier.movieState).thenReturn(RequestState.loaded);
      when(mockNotifier.movie).thenReturn(tMovieDetail);
      when(mockNotifier.recommendationState).thenReturn(RequestState.loaded);
      when(mockNotifier.movieRecommendations).thenReturn([tMovie]);
      when(mockNotifier.isAddedToWatchlist).thenReturn(false);

      await tester.pumpWidget(makeTestableWidget(MovieDetailPage(id: 1)));
      await tester.pump();

      final expectedRuntime =
          '${tMovieDetail.runtime ~/ 60}h ${tMovieDetail.runtime % 60}m';
      expect(find.text(expectedRuntime), findsOneWidget);
    });
  });
}
