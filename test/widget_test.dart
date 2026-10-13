import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:app1/main.dart';

void main() {
  testWidgets('MenuListPage renders correctly', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that the app title and welcome text appear
    expect(find.text('Kantin Bu Sari'), findsOneWidget);
    expect(find.textContaining('Mau makan apa'), findsOneWidget);

    // Verify search field exists
    expect(find.byType(TextField), findsOneWidget);

    // Verify menu items are displayed
    expect(find.text('Nasi Goreng Spesial'), findsOneWidget);
  });
}
