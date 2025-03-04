import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'flutter_multi_screenshot_method_channel.dart';

abstract class FlutterMultiScreenshotPlatform extends PlatformInterface {
  /// Constructs a FlutterMultiScreenshotPlatform.
  FlutterMultiScreenshotPlatform() : super(token: _token);

  static final Object _token = Object();

  static FlutterMultiScreenshotPlatform _instance = MethodChannelFlutterMultiScreenshot();

  /// The default instance of [FlutterMultiScreenshotPlatform] to use.
  ///
  /// Defaults to [MethodChannelFlutterMultiScreenshot].
  static FlutterMultiScreenshotPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [FlutterMultiScreenshotPlatform] when
  /// they register themselves.
  static set instance(FlutterMultiScreenshotPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
