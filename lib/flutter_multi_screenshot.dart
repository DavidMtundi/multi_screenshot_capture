import 'dart:async';
import 'package:flutter/services.dart';

class FlutterMultiScreenshot {
  static const MethodChannel _channel = MethodChannel('flutter_multi_screenshot');

  /// Capture screenshots of all screens as file paths
  static Future<List<String>> captureAllToFile() async {
    final List<dynamic> result = await _channel.invokeMethod('captureAllScreenshotsToFiles');
    return result.cast<String>();  // Convert to List<String>
  }

  /// Capture screenshots of all screens as Base64 images
  static Future<List<String>> captureAllAsBase64() async {
    final List<dynamic> result = await _channel.invokeMethod('captureAllScreenshotsAsBase64');
    return result.cast<String>();  // Convert to List<String>
  }

  /// Capture a single screenshot as a file
  static Future<String> captureToFile() async {
    return await _channel.invokeMethod<String>('captureScreenshotToFile') ?? "";
  }

  /// Capture a single screenshot as Base64
  static Future<String> captureAsBase64() async {
    return await _channel.invokeMethod<String>('captureScreenshotAsBase64') ?? "";
  }
}
