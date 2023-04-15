import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'create_watch_face_plugin_platform_interface.dart';

/// An implementation of [CreateWatchFacePluginPlatform] that uses method channels.
class MethodChannelCreateWatchFacePlugin extends CreateWatchFacePluginPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('create_watch_face_plugin');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }

  @override
  Future<bool> shareImage({required Uint8List imageInBytes}) async {
    final completion = await methodChannel.invokeMethod<bool>('create_watch_face_plugin', [imageInBytes]) ?? false;
    return completion;
  }

  @override
  Future<bool> shareImages({required List<Uint8List> listOfImagesInBytes}) async {
    final completion = await methodChannel.invokeMethod<bool>('create_watch_face_plugin', listOfImagesInBytes) ?? false;
    return completion;
  }
}
