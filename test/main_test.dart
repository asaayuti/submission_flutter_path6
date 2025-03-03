import 'package:about/about_page.dart';
import 'package:core/presentation/pages/home_page.dart';
import 'package:ditonton/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ditonton/injection.dart' as di;

void main() {
  setUpAll(() {
    di.init(); // Initialize dependency injection
  });

  testWidgets('MyApp should render HomePage', (WidgetTester tester) async {
    await tester.pumpWidget(MyApp());

    // Check if HomePage is present in the widget tree
    expect(find.byType(HomePage), findsOneWidget);
  });

  testWidgets('Navigating to About Page', (WidgetTester tester) async {
    await tester.pumpWidget(MyApp());

    // Ensure HomePage is displayed
    expect(find.byType(HomePage), findsOneWidget);

    // Open the drawer
    await tester.tap(find.byIcon(Icons.menu));
    await tester.pumpAndSettle(); // Wait for the drawer to fully open

    // Find and tap the About option
    final aboutMenuItem = find.text('About');
    expect(aboutMenuItem, findsOneWidget);

    await tester.tap(aboutMenuItem);
    await tester.pumpAndSettle(); // Wait for navigation

    // Check if the About Page is displayed
    expect(find.byType(AboutPage), findsOneWidget);
  });
}
