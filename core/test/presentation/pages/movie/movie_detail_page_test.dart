import 'package:core/presentation/bloc/movie/movie_detail_bloc.dart';
import 'package:core/presentation/bloc/movie/movie_detail_event.dart';
import 'package:core/presentation/bloc/movie/movie_detail_state.dart';
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
      when(mockMovieDetailBloc.state).thenReturn(MovieDetailLoading());
      await tester.pumpWidget(makeTestableWidget(const MovieDetailPage(id: 1)));
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

      await tester.pumpWidget(makeTestableWidget(const MovieDetailPage(id: 1)));
      await tester.pump(const Duration(seconds: 1));
      expect(find.text('title'), findsOneWidget);
      expect(find.text('overview'), findsOneWidget);
      expect(find.byType(FilledButton), findsOneWidget);
    });

    testWidgets('Displays error message when state is MovieDetailError', (
      WidgetTester tester,
    ) async {
      when(
        mockMovieDetailBloc.state,
      ).thenReturn(MovieDetailError('Error Message'));
      await tester.pumpWidget(makeTestableWidget(const MovieDetailPage(id: 1)));
      await tester.pump();

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

        await tester.pumpWidget(
          makeTestableWidget(const MovieDetailPage(id: 1)),
        );
        await tester.pump(const Duration(seconds: 1));
        final watchlistButton = find.byType(FilledButton);
        expect(watchlistButton, findsOneWidget);
        await tester.tap(watchlistButton);
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

        await tester.pumpWidget(
          makeTestableWidget(const MovieDetailPage(id: 1)),
        );
        await tester.pump(const Duration(seconds: 1));
        final watchlistButton = find.byType(FilledButton);
        expect(watchlistButton, findsOneWidget);
        await tester.tap(watchlistButton);
        verify(
          mockMovieDetailBloc.add(RemoveFromWatchlist(tMovieDetail)),
        ).called(1);
      },
    );
  });
}
