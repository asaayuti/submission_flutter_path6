import 'package:about/about_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('AboutPage displays correct content', (
    WidgetTester tester,
  ) async {
    // Build AboutPage inside a MaterialApp.
    await tester.pumpWidget(MaterialApp(home: AboutPage()));

    // Verify that the text is displayed.
    expect(
      find.textContaining('Ditonton merupakan sebuah aplikasi katalog film'),
      findsOneWidget,
    );

    // Verify that the Image.asset widget is present.
    expect(find.byType(Image), findsOneWidget);

    // Verify that the IconButton with the back arrow is present.
    expect(find.byIcon(Icons.arrow_back), findsOneWidget);
  });

  testWidgets('AboutPage back button pops the page', (
    WidgetTester tester,
  ) async {
    // Create a simple app with a button that navigates to AboutPage.
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) {
              return ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => AboutPage()),
                  );
                },
                child: const Text('Go to About'),
              );
            },
          ),
        ),
      ),
    );

    // Tap the button to push AboutPage.
    await tester.tap(find.text('Go to About'));
    await tester.pumpAndSettle();

    // Confirm that AboutPage is displayed.
    expect(find.byType(AboutPage), findsOneWidget);

    // Tap the back button.
    await tester.tap(find.byIcon(Icons.arrow_back));
    await tester.pumpAndSettle();

    // Verify that AboutPage has been popped.
    expect(find.byType(AboutPage), findsNothing);
  });
}
