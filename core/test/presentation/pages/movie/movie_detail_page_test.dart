import 'package:core/presentation/bloc/movie_detail_bloc.dart';
import 'package:core/presentation/bloc/movie_detail_event.dart';
import 'package:core/presentation/bloc/movie_detail_state.dart';
import 'package:core/presentation/pages/movie/movie_detail_page.dart';
import 'package:core/utils/dummy_data/dummy_movies.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'movie_detail_page_test.mocks.dart';

@GenerateNiceMocks([MockSpec<MovieDetailBloc>()])
void main() {
  late MockMovieDetailBloc mockMovieDetailBloc;

  setUp(() {
    mockMovieDetailBloc = MockMovieDetailBloc();
  });

  // Helper function to wrap your widget with MaterialApp and provide the bloc.
  Widget makeTestableWidget(Widget child) {
    return MaterialApp(
      home: BlocProvider<MovieDetailBloc>.value(
        value: mockMovieDetailBloc,
        child: child,
      ),
    );
  }

  group('MovieDetailPage Widget Tests', () {
    testWidgets('Displays loading indicator when state is MovieDetailLoading', (
      WidgetTester tester,
    ) async {
      // Arrange: Stub the bloc state to return loading.
      when(mockMovieDetailBloc.state).thenReturn(MovieDetailLoading());
      await tester.pumpWidget(makeTestableWidget(const MovieDetailPage(id: 1)));
      // Assert: Verify that a CircularProgressIndicator is found.
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('Displays movie details when state is MovieDetailLoaded', (
      WidgetTester tester,
    ) async {
      when(mockMovieDetailBloc.state).thenReturn(
        MovieDetailHasData(
          movie: tMovieDetail,
          recommendations: tMovieList,
          isAddedToWatchlist: false,
          watchlistMessage: '',
        ),
      );

      // Act: Pump the widget.
      await tester.pumpWidget(makeTestableWidget(const MovieDetailPage(id: 1)));
      await tester.pump(
        const Duration(seconds: 1),
      ); // let the widget build and animations settle for 1 second
      // Assert: Verify movie details appear.
      expect(find.text('title'), findsOneWidget);
      expect(find.text('overview'), findsOneWidget);
      // Check that the watchlist button is present.
      expect(find.byType(FilledButton), findsOneWidget);
    });

    testWidgets('Displays error message when state is MovieDetailError', (
      WidgetTester tester,
    ) async {
      // Arrange: Stub the bloc state to return an error.
      when(
        mockMovieDetailBloc.state,
      ).thenReturn(MovieDetailError('Error Message'));
      await tester.pumpWidget(makeTestableWidget(const MovieDetailPage(id: 1)));
      await tester.pump();

      // Assert: Verify that the error message is displayed.
      expect(find.text('Error Message'), findsOneWidget);
    });

    testWidgets(
      'Triggers AddWatchlist event when watchlist button is tapped and movie is not in watchlist',
      (WidgetTester tester) async {
        when(mockMovieDetailBloc.state).thenReturn(
          MovieDetailHasData(
            movie: tMovieDetail,
            recommendations: const [],
            isAddedToWatchlist: false,
            watchlistMessage: '',
          ),
        );

        // Act: Pump the widget and tap the watchlist button.
        await tester.pumpWidget(
          makeTestableWidget(const MovieDetailPage(id: 1)),
        );
        await tester.pump(
          const Duration(seconds: 1),
        ); // let the widget build and animations settle for 1 second
        final watchlistButton = find.byType(FilledButton);
        expect(watchlistButton, findsOneWidget);
        await tester.tap(watchlistButton);
        // Assert: Verify that the AddWatchlist event was added.
        verify(mockMovieDetailBloc.add(AddWatchlist(tMovieDetail))).called(1);
      },
    );

    testWidgets(
      'Triggers RemoveFromWatchlist event when watchlist button is tapped and movie is already in watchlist',
      (WidgetTester tester) async {
        when(mockMovieDetailBloc.state).thenReturn(
          MovieDetailHasData(
            movie: tMovieDetail,
            recommendations: const [],
            isAddedToWatchlist: true,
            watchlistMessage: '',
          ),
        );

        // Act: Pump the widget and tap the watchlist button.
        await tester.pumpWidget(
          makeTestableWidget(const MovieDetailPage(id: 1)),
        );
        await tester.pump(
          const Duration(seconds: 1),
        ); // let the widget build and animations settle for 1 second
        final watchlistButton = find.byType(FilledButton);
        expect(watchlistButton, findsOneWidget);
        await tester.tap(watchlistButton);
        // Assert: Verify that the RemoveFromWatchlist event was added.
        verify(
          mockMovieDetailBloc.add(RemoveFromWatchlist(tMovieDetail)),
        ).called(1);
      },
    );
  });
}
