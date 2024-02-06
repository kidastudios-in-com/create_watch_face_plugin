import 'dart:typed_data';
import 'create_watch_face_plugin_platform_interface.dart';

class CreateWatchFacePlugin {
  Future<String?> getPlatformVersion() {
    return CreateWatchFacePluginPlatform.instance.getPlatformVersion();
  }

  /// Method to call `shareImage` method from swift
  /// to share a single image.
  /// - Required: [imageInBytes] the image's Binary data.
  /// - Returns: `boolean` indicating did share or not
  Future<bool?> shareImage({required Uint8List imageInBytes}) {
    return CreateWatchFacePluginPlatform.instance
        .shareImage(imageInBytes: imageInBytes);
  }

  /// Method to call `shareImage` method from swift
  /// to share a single image.
  /// - Required: [imageInBytes] the image's Binary data.
  /// - Returns: `boolean` indicating did share or not
  Future<bool?> shareImages({required List<Uint8List> listOfImagesInBytes}) {
    return CreateWatchFacePluginPlatform.instance
        .shareImages(listOfImagesInBytes: listOfImagesInBytes);
  }

  /// Method to invoke `CLKWatchFaceLibrary`'s `addWatchFace` method
  /// - Required: [watchFace] the path to the watch face in flutter assets.
  /// - Returns: "Success" or "Error" with the error description
  Future<String> createWatchFaceButton({required String watchFace}) {
    return CreateWatchFacePluginPlatform.instance.createWatchFaceButton(watchFace: watchFace);
  }

  /// Method to invoke `CLKWatchFaceLibrary`'s `addWatchFace` method
  /// - Required: [watchFace] the full path to the watch face on device.
  /// - Returns: "Success" or "Error" with the error description
  Future<String> createWatchFaceButtonWithFullURL({required String watchFace}) {
    return CreateWatchFacePluginPlatform.instance.createWatchFaceButtonFullURL(watchFace: watchFace);
  }

  /// Method to open AppStore for the specific [appId].
  /// - Returns: `boolean` indicating did share or not
  Future<bool> shareAppStoreLink({required String appId}) {
    return CreateWatchFacePluginPlatform.instance.shareAppStoreLink(appId: appId);
  }

  /// Method to share the link of this app.
  /// - Required: [appId] for current app
  /// - Returns: `boolean` indicating did share or not
  Future<bool> shareThisApp({required String appId}) {
    return CreateWatchFacePluginPlatform.instance.shareThisApp(appId: appId);
  }

  /// Method to invoke `WatchKit`'s details map from swift
  /// - Returns: A `Map<String, dynamic>>` of the possible keys
  Future<Map<String, dynamic>> getWatchConnectionDetails() {
    return CreateWatchFacePluginPlatform.instance.getWatchConnectionDetails();
  }
}
