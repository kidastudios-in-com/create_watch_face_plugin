import 'dart:typed_data';
import 'create_watch_face_plugin_platform_interface.dart';

class CreateWatchFacePlugin {
  Future<bool?> shareImage({required Uint8List imageInBytes}) {
    return CreateWatchFacePluginPlatform.instance
        .shareImage(imageInBytes: imageInBytes);
  }

  Future<bool?> shareImages({required List<Uint8List> listOfImagesInBytes}) {
    return CreateWatchFacePluginPlatform.instance
        .shareImages(listOfImagesInBytes: listOfImagesInBytes);
  }

  Future<String?> getPlatformVersion() {
    return CreateWatchFacePluginPlatform.instance.getPlatformVersion();
  }
}
