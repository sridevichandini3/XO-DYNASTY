import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:xo_dynasty/main.dart';

void main() {
  testWidgets('App boots and shows the guest sign-in entry point',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(child: XoDynastyApp()),
    );
    await tester.pump();

    expect(find.text('XO Dynasty'), findsWidgets);
    expect(find.text('Continue as Guest'), findsOneWidget);
  });
}
