# create_watch_face_plugin

A Flutter plugin to install Apple WatchFaces.

[![License](https://img.shields.io/github/license/kidastudios-in-com/create_watch_face_plugin)](https://github.com/kidastudios-in-com/create_watch_face_plugin/blob/main/LICENSE)
![Flutter platform](https://img.shields.io/badge/flutter-ios-blue)

## Installation
- Add `create_watch_face_plugin` to your `pubspec.yaml`
- Set iOS deployment level in `Podfile` to minimum: 14.0
  - `platform :ios, '14.0'`

## Getting Started
- [Getting Started](#getting-started)
  - [1. Initialization](#1-initialize-your-object-instance)
  - [2. Fetch from Flutter Assets](#2-fetch-watchface-file-link-from-flutter-assets)
  - [3. Fetch from network](#3-fetch-watchface-file-link-from-network)
  - [4. Share an image](#4-sharing-an-image-from-flutter-to-other-apps)
  - [5. Opening App Store link for an app](#5-opening-the-app-store-for-a-certain-appid)
  - [6. Sharing link the of an app](#6-sharing-the-link-to-the-current-running-app)

### 1. Initialize your object instance
```dart
import 'package:create_watch_face_plugin/create_watch_face_plugin.dart';

final createWatchFacePlugin = CreateWatchFacePlugin();
```

### 2. Fetch `.watchface` file link (from Flutter Assets)
```dart
Future<String> installWatchFace() async {
  final watchFaceLink = "assets/path-to-watchface-file";

  final res = await createWatchFacePlugin.createWatchFaceButton(watchFace: watchFaceLink);
  return res;
}
```

### 3. Fetch `.watchface` file link (from network)
```dart
Future<String> installWatchFaceFromURL(String watchFaceLink) async {
  final byteData = await NetworkAssetBundle(
    Uri.parse(watchFaceLink),
  ).load("");
  final data = byteData.buffer.asUint8List();

  final docDir = await getApplicationDocumentsDirectory();
  final filePath = "${docDir.path}/watchFace.watchface";
  final file = await File(filePath).writeAsBytes(data);
  
  if (Platform.isIOS) {
    final res =
    await createWatchFacePlugin.createWatchFaceButtonWithFullURL(
      watchFace: file.path,
    );
    return res;
  }
  
  throw Exception("Some exception!");
}
```

### 4. Sharing an image from Flutter to other apps
```dart
final Uint8List pngBytes = byteData.buffer.asUint8List();

await createWatchFacePlugin.shareImage(imageInBytes: pngBytes);
```

### 5. Opening the App Store for a certain `appId`
```dart
void shareApp(String appId) async {
  final bool didOpen = await createWatchFacePlugin.shareAppStoreLink(appId: appId);
  
  debugPrint(didOpen ? "Opened the AppStore successfully" : "Didn't open AppStore");
}
```

### 6. Sharing the link to the current running app
```dart
void shareThisApp(String appId) async {
  final bool didOpen = await createWatchFacePlugin.shareThisApp(appId: appId);
  
  debugPrint(didOpen ? "Shared app's link" : "Didn't oops!");
}
```