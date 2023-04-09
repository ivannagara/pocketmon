import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pokedex_app/home/home.dart';

void main() {
  group('HomePage', () {
    const page = MaterialApp(
      home: HomePage(),
    );
    testWidgets('should be renderable', (tester) async {
      await tester.pumpWidget(page);
      expect(find.byType(HomePage), findsOneWidget);
    });
  });
}
