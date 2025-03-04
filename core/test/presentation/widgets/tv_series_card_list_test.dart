import 'package:cached_network_image/cached_network_image.dart';
import 'package:core/presentation/widgets/tv_series_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:core/utils/dummy_data/dummy_tv_series.dart';

class MockNavigatorObserver extends Mock implements NavigatorObserver {}

void main() {
  late MockNavigatorObserver mockNavigatorObserver;

  setUp(() {
    mockNavigatorObserver = MockNavigatorObserver();
  });

  testWidgets('TvSeriesCard should display correct movie information', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(home: Scaffold(body: TvSeriesCard(tTvSeries))),
    );

    expect(find.text('Spider-Man'), findsOneWidget);
    expect(
      find.text(
        'Bitten by a neogenetic spider, Peter Parker develops spider-like superpowers. He uses these to fight crime while trying to balance it with the struggles of his personal life.',
      ),
      findsOneWidget,
    );
    expect(find.byType(CachedNetworkImage), findsOneWidget);
  });

  testWidgets('Tapping on TvSeriesCard should navigate to TvSeriesDetailPage', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        navigatorObservers: [mockNavigatorObserver],
        routes: {
          '/detail-tv-series':
              (context) => Scaffold(body: Text('Tv Series Detail Page')),
        },
        home: Scaffold(body: TvSeriesCard(tTvSeries)),
      ),
    );

    await tester.tap(find.byType(InkWell));
    await tester.pumpAndSettle();

    expect(find.text('Tv Series Detail Page'), findsOneWidget);
  });
}
