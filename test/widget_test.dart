import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:github_portfolio_app/main.dart';

void main() {
  testWidgets('App launches correctly', (WidgetTester tester) async {
    // Build our app
    await tester.pumpWidget(const MyApp());

    // Verify app title appears
    expect(find.text('GitHub Portfolio'), findsOneWidget);
  });
}
