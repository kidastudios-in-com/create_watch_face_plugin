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

  /// Method to call `shareImage` method from swift
  /// to share a single image.
  /// - Required: [imageInBytes] the image's Binary data.
  /// - Returns: `boolean` indicating did share or not
  Future<bool> shareImage({required Uint8List imageInBytes}) {
    throw UnimplementedError('method has not been implemented.');
  }

  /// Method to call `shareImage` method from swift
  /// to share a single image.
  /// - Required: [imageInBytes] the image's Binary data.
  /// - Returns: `boolean` indicating did share or not
  Future<bool> shareImages({required List<Uint8List> listOfImagesInBytes}) {
    throw UnimplementedError('method has not been implemented.');
  }

  /// Method to invoke `CLKWatchFaceLibrary`'s `addWatchFace` method
  /// - Required: [watchFace] the path to the watch face in flutter assets.
  /// - Returns: "Success" or "Error" with the error description
  Future<String> createWatchFaceButton({required String watchFace}) {
    throw UnimplementedError('method has not been implemented.');
  }

  /// Method to invoke `CLKWatchFaceLibrary`'s `addWatchFace` method
  /// - Required: [watchFace] the full path to the watch face on device.
  /// - Returns: "Success" or "Error" with the error description
  Future<String> createWatchFaceButtonFullURL({required String watchFace}) {
    throw UnimplementedError('method has not been implemented.');
  }

  /// Method to open AppStore for the specific [appId].
  /// - Returns: `boolean` indicating did share or not
  Future<bool> shareAppStoreLink({required String appId}) {
    throw UnimplementedError('method has not been implemented.');
  }

  /// Method to share the link of this app.
  /// - Required: [appId] for current
  /// - Returns: `boolean` indicating did share or not
  Future<bool> shareThisApp({required String appId}) {
    throw UnimplementedError('method has not been implemented.');
  }

  /// Method to invoke `WatchKit`'s details map from swift
  /// - Returns: A `Map<String, dynamic>>` of the possible keys
  Future<Map<String, dynamic>> getWatchConnectionDetails() {
    throw UnimplementedError('method has not been implemented.');
  }
}
