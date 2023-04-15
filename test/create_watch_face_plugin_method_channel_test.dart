import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:create_watch_face_plugin/create_watch_face_plugin_method_channel.dart';

void main() {
  MethodChannelCreateWatchFacePlugin platform = MethodChannelCreateWatchFacePlugin();
  const MethodChannel channel = MethodChannel('create_watch_face_plugin');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await platform.getPlatformVersion(), '42');
  });
}
