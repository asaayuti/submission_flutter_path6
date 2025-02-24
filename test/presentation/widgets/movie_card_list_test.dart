import 'package:cached_network_image/cached_network_image.dart';
import 'package:ditonton/presentation/widgets/movie_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/movie/dummy_objects.dart';

class MockNavigatorObserver extends Mock implements NavigatorObserver {}

void main() {
  late MockNavigatorObserver mockNavigatorObserver;

  setUp(() {
    mockNavigatorObserver = MockNavigatorObserver();
  });

  testWidgets('MovieCard should display correct movie information', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(home: Scaffold(body: MovieCard(tMovie))),
    );

    expect(find.text('Spider-Man'), findsOneWidget);
    expect(
      find.text(
        'After being bitten by a genetically altered spider, nerdy high school student Peter Parker is endowed with amazing powers to become the Amazing superhero known as Spider-Man.',
      ),
      findsOneWidget,
    );
    expect(find.byType(CachedNetworkImage), findsOneWidget);
  });

  testWidgets('Tapping on MovieCard should navigate to MovieDetailPage', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        navigatorObservers: [mockNavigatorObserver],
        routes: {
          '/detail': (context) => Scaffold(body: Text('Movie Detail Page')),
        },
        home: Scaffold(body: MovieCard(tMovie)),
      ),
    );

    await tester.tap(find.byType(InkWell));
    await tester.pumpAndSettle();

    expect(find.text('Movie Detail Page'), findsOneWidget);
  });
}
