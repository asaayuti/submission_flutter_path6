import 'package:core/presentation/bloc/tv_series/tv_detail_bloc.dart';
import 'package:core/presentation/bloc/tv_series/tv_detail_event.dart';
import 'package:core/presentation/bloc/tv_series/tv_detail_state.dart';
import 'package:core/presentation/pages/tv_series/tv_detail_page.dart';
import 'package:core/utils/dummy_tv_series.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'tv_detail_page_test.mocks.dart';

@GenerateNiceMocks([MockSpec<TvDetailBloc>()])
void main() {
  late MockTvDetailBloc mockTvDetailBloc;

  setUp(() {
    mockTvDetailBloc = MockTvDetailBloc();
  });

  Widget makeTestableWidget(Widget child) {
    return MaterialApp(
      home: BlocProvider<TvDetailBloc>.value(
        value: mockTvDetailBloc,
        child: child,
      ),
    );
  }

  group('TvDetailPage Widget Tests', () {
    testWidgets('Displays loading indicator when state is TvDetailLoading', (
      WidgetTester tester,
    ) async {
      when(mockTvDetailBloc.state).thenReturn(TvDetailLoading());
      await tester.pumpWidget(makeTestableWidget(const TvDetailPage(id: 1)));
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('Displays tv details when state is TvDetailLoaded', (
      WidgetTester tester,
    ) async {
      when(mockTvDetailBloc.state).thenReturn(
        TvDetailHasData(
          tvSeries: tTvSeriesDetail,
          recommendations: tTvSeriesList,
          isAddedToWatchlist: false,
          watchlistMessage: '',
        ),
      );

      await tester.pumpWidget(makeTestableWidget(const TvDetailPage(id: 1)));
      await tester.pump(const Duration(seconds: 1));
      expect(find.text('Sample TV Series'), findsOneWidget);
      expect(find.text('This is a sample TV series overview.'), findsOneWidget);
      expect(find.byType(FilledButton), findsOneWidget);
    });

    testWidgets('Displays error message when state is TvDetailError', (
      WidgetTester tester,
    ) async {
      when(mockTvDetailBloc.state).thenReturn(TvDetailError('Error Message'));
      await tester.pumpWidget(makeTestableWidget(const TvDetailPage(id: 1)));
      await tester.pump();

      expect(find.text('Error Message'), findsOneWidget);
    });

    testWidgets(
      'Triggers AddWatchlist event when watchlist button is tapped and tv is not in watchlist',
      (WidgetTester tester) async {
        when(mockTvDetailBloc.state).thenReturn(
          TvDetailHasData(
            tvSeries: tTvSeriesDetail,
            recommendations: const [],
            isAddedToWatchlist: false,
            watchlistMessage: '',
          ),
        );

        await tester.pumpWidget(makeTestableWidget(const TvDetailPage(id: 1)));
        await tester.pump(const Duration(seconds: 1));
        final watchlistButton = find.byType(FilledButton);
        expect(watchlistButton, findsOneWidget);
        await tester.tap(watchlistButton);
        verify(mockTvDetailBloc.add(AddWatchlist(tTvSeriesDetail))).called(1);
      },
    );

    testWidgets(
      'Triggers RemoveFromWatchlist event when watchlist button is tapped and tv is already in watchlist',
      (WidgetTester tester) async {
        when(mockTvDetailBloc.state).thenReturn(
          TvDetailHasData(
            tvSeries: tTvSeriesDetail,
            recommendations: const [],
            isAddedToWatchlist: true,
            watchlistMessage: '',
          ),
        );

        await tester.pumpWidget(makeTestableWidget(const TvDetailPage(id: 1)));
        await tester.pump(const Duration(seconds: 1));
        final watchlistButton = find.byType(FilledButton);
        expect(watchlistButton, findsOneWidget);
        await tester.tap(watchlistButton);
        verify(
          mockTvDetailBloc.add(RemoveFromWatchlist(tTvSeriesDetail)),
        ).called(1);
      },
    );
  });
}
