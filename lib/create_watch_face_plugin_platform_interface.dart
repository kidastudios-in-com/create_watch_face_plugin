import 'dart:typed_data';

import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'create_watch_face_plugin_method_channel.dart';

abstract class CreateWatchFacePluginPlatform extends PlatformInterface {
  /// Constructs a CreateWatchFacePluginPlatform.
  CreateWatchFacePluginPlatform() : super(token: _token);

  static final Object _token = Object();

  static CreateWatchFacePluginPlatform _instance = MethodChannelCreateWatchFacePlugin();

  /// The default instance of [CreateWatchFacePluginPlatform] to use.
  ///
  /// Defaults to [MethodChannelCreateWatchFacePlugin].
  static CreateWatchFacePluginPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [CreateWatchFacePluginPlatform] when
  /// they register themselves.
  static set instance(CreateWatchFacePluginPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<bool> shareImage({required Uint8List imageInBytes}) {
    throw UnimplementedError('method has not been implemented.');
  }

  Future<bool> shareImages({required List<Uint8List> listOfImagesInBytes}) {
    throw UnimplementedError('method has not been implemented.');
  }

  Future<String> createWatchFaceButton({required dynamic watchFace}) {
    throw UnimplementedError('method has not been implemented.');
  }

  Future<bool> shareAppStoreLink({required String appId}) {
    throw UnimplementedError('method has not been implemented.');
  }

  Future<bool> shareThisApp({required String appId}) {
    throw UnimplementedError('method has not been implemented.');
  }

  Future<Map<String, dynamic>> getWatchConnectionDetails() {
    throw UnimplementedError('method has not been implemented.');
  }
}
