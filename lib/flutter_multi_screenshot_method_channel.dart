import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'flutter_multi_screenshot_platform_interface.dart';

/// An implementation of [FlutterMultiScreenshotPlatform] that uses method channels.
class MethodChannelFlutterMultiScreenshot extends FlutterMultiScreenshotPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('flutter_multi_screenshot');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
