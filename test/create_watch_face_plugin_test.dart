import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:create_watch_face_plugin/create_watch_face_plugin.dart';
import 'package:create_watch_face_plugin/create_watch_face_plugin_platform_interface.dart';
import 'package:create_watch_face_plugin/create_watch_face_plugin_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockCreateWatchFacePluginPlatform
    with MockPlatformInterfaceMixin
    implements CreateWatchFacePluginPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');

  @override
  Future<bool> shareImage({required Uint8List imageInBytes}) {
    return Future.value(true);
  }

  @override
  Future<bool> shareImages({required List<Uint8List> listOfImagesInBytes}) {
    return Future.value(false);
  }
}

void main() {
  final CreateWatchFacePluginPlatform initialPlatform = CreateWatchFacePluginPlatform.instance;

  test('$MethodChannelCreateWatchFacePlugin is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelCreateWatchFacePlugin>());
  });

  test('getPlatformVersion', () async {
    CreateWatchFacePlugin createWatchFacePlugin = CreateWatchFacePlugin();
    MockCreateWatchFacePluginPlatform fakePlatform = MockCreateWatchFacePluginPlatform();
    CreateWatchFacePluginPlatform.instance = fakePlatform;
    expect(await createWatchFacePlugin.getPlatformVersion(), '42');
  });
}
