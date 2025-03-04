
import 'package:flutter/services.dart';

import 'flutter_multi_screenshot_platform_interface.dart';

class FlutterMultiScreenshot {
  static const MethodChannel _channel = MethodChannel('flutter_multi_screenshot');

  Future<String?> getPlatformVersion() {
    return FlutterMultiScreenshotPlatform.instance.getPlatformVersion();
  }

  /// Capture screenshot and return Base64
  static Future<String> captureAsBase64() async {
    try {
      return await _channel.invokeMethod<String>('captureScreenshotAsBase64') ?? "";
    } catch (e) {
      print("Error capturing screenshot: $e");
      return "";
    }
  }

  /// Capture screenshot and save to a file
  static Future<String> captureToFile() async {
    try {
      return await _channel.invokeMethod<String>('captureScreenshotToFile') ?? "";
    } catch (e) {
      print("Error capturing screenshot: $e");
      return "";
    }
  }
}
