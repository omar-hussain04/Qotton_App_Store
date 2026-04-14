import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:qotton_shop/main.dart';

void main() {
  testWidgets('Qotton Shop app smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const QottonShopApp());

    // Verify that our main text appears on the home screen.
    expect(find.text('Discover\nPremium Hoodies'), findsOneWidget);
    expect(find.text('Classic Qotton Hoodie'), findsOneWidget);
  });
}
