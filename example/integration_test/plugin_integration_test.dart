import 'dart:io';
import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flutter_multi_screenshot/flutter_multi_screenshot.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  testWidgets('Capture Single Screen as File', (WidgetTester tester) async {
    final String filePath = await FlutterMultiScreenshot.captureToFile();

    expect(filePath, isNotNull);
    expect(filePath.isNotEmpty, true);
    expect(File(filePath).existsSync(), true, reason: "File should exist");
  });

  testWidgets('Capture Single Screen as Base64', (WidgetTester tester) async {
    final String base64Image = await FlutterMultiScreenshot.captureAsBase64();
    final String cleanBase64 = base64Image.replaceAll('\n', '').replaceAll('\r', '');

    expect(cleanBase64, isNotNull);
    expect(cleanBase64.isNotEmpty, true);

    // Validate if Base64 decoding works correctly
    expect(() => base64Decode(cleanBase64), returnsNormally);
  });

  testWidgets('Capture All Screens as Files', (WidgetTester tester) async {
    final List<String> filePaths = await FlutterMultiScreenshot.captureAllToFile();

    expect(filePaths, isNotNull);
    expect(filePaths.isNotEmpty, true);
    for (final path in filePaths) {
      expect(File(path).existsSync(), true, reason: "Each screenshot file should exist");
    }
  });

  testWidgets('Capture All Screens as Base64', (WidgetTester tester) async {
    final List<String> base64Images = await FlutterMultiScreenshot.captureAllAsBase64();

    expect(base64Images, isNotNull);
    expect(base64Images.isNotEmpty, true);

    for (final base64 in base64Images) {
      final String cleanBase64 = base64.replaceAll('\n', '').replaceAll('\r', '');
      expect(() => base64Decode(cleanBase64), returnsNormally);
    }
  });
}
