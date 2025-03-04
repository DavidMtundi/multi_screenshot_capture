import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_multi_screenshot_example/main.dart';

void main() {
  testWidgets('Verify UI elements exist and interact properly', (WidgetTester tester) async {
    // Build the app
    await tester.pumpWidget(MaterialApp(home: ScreenshotTestApp()));

    // Verify the main buttons exist
    expect(find.text('Capture Single Screen (File)'), findsOneWidget);
    expect(find.text('Capture Single Screen (Base64)'), findsOneWidget);
    expect(find.text('Capture All Screens (Files)'), findsOneWidget);
    expect(find.text('Capture All Screens (Base64)'), findsOneWidget);

    // Simulate tapping the "Capture Single Screen (File)" button
    await tester.tap(find.text('Capture Single Screen (File)'));
    await tester.pumpAndSettle();

    // Simulate tapping the "Capture Single Screen (Base64)" button
    await tester.tap(find.text('Capture Single Screen (Base64)'));
    await tester.pumpAndSettle();

    // Simulate tapping the "Capture All Screens (Files)" button
    await tester.tap(find.text('Capture All Screens (Files)'));
    await tester.pumpAndSettle();

    // Simulate tapping the "Capture All Screens (Base64)" button
    await tester.tap(find.text('Capture All Screens (Base64)'));
    await tester.pumpAndSettle();

    // Ensure that at least one screenshot appears (by checking image widgets)
    expect(find.byType(Image), findsWidgets);
  });
}
