import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_multi_screenshot/flutter_multi_screenshot.dart';
import 'package:flutter_multi_screenshot/flutter_multi_screenshot_platform_interface.dart';
import 'package:flutter_multi_screenshot/flutter_multi_screenshot_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockFlutterMultiScreenshotPlatform
    with MockPlatformInterfaceMixin
    implements FlutterMultiScreenshotPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final FlutterMultiScreenshotPlatform initialPlatform = FlutterMultiScreenshotPlatform.instance;

  test('$MethodChannelFlutterMultiScreenshot is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelFlutterMultiScreenshot>());
  });

  test('getPlatformVersion', () async {
    FlutterMultiScreenshot flutterMultiScreenshotPlugin = FlutterMultiScreenshot();
    MockFlutterMultiScreenshotPlatform fakePlatform = MockFlutterMultiScreenshotPlatform();
    FlutterMultiScreenshotPlatform.instance = fakePlatform;

    expect(await flutterMultiScreenshotPlugin.getPlatformVersion(), '42');
  });
}
