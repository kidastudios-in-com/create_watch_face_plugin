import ClockKit
import Flutter
import WatchConnectivity
import UIKit

public class CreateWatchFacePlugin: NSObject, FlutterPlugin {
    // MARK: - function to get UIViewController
    private static func RootViewController() -> UIViewController? {
        var rootViewController: UIViewController? = nil
        let scenes = UIApplication.shared.connectedScenes
        scenes.forEach { connectedScene in
            if connectedScene is UIWindowScene {
                guard let connectedWindowScene = connectedScene as? UIWindowScene else {
                    return
                }
                let windows = connectedWindowScene.windows
                windows.forEach { uiWindow in
                    if uiWindow.isKeyWindow {
                        rootViewController = uiWindow.rootViewController
                    }
                }
            }
        }
        return rootViewController
    }
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "create_watch_face_plugin", binaryMessenger: registrar.messenger())
        let instance = CreateWatchFacePlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        if call.method == "getPlatformVersion" {
            result("\(UIDevice.current.systemVersion), \(UIDevice.current.systemName)")
            return
        }
        
        if call.method == "watch_connection_info" {
            Task {
                let coordinator: WatchCoordinator = .shared
                let watchDetails = await coordinator.isWatchConnected()
                result(watchDetails)
            }
            return
        }
        
        guard let rootViewController = CreateWatchFacePlugin.RootViewController() else {
            result(FlutterError(code: "No root view controller", message: "No root view controller found!", details: nil))
            return
        }
        
        let shareModel = ShareModel(call, rootViewController, result)
        
        if call.method == "share_this_app" {
            shareModel.shareThisApp()
            return
        }
        
        if call.method == "open_app_in_store" {
            shareModel.validateArgumentsForAppStoreLink()
            return
        }
        
        if call.method == "try_watch_face_full_url" {
            shareModel.validateArgumentsForWatchFaceFile()
            return
        }
        
        if call.method == "try_watch_face" {
            shareModel.validateArgumentsAndGetFromBundleForWatchFaceFile()
            return
        }
        
        if call.method != "create_watch_face_plugin" {
            result(FlutterMethodNotImplemented)
            return
        }
        
        shareModel.validateArgumentsAndCallFunction("create_watch_face_plugin")
    }
}

actor WatchCoordinator {
    static let shared = WatchCoordinator()
    
    private let session: WCSession = .default
    
    func isWatchConnected() -> [String : Bool] {
        let isPaired = session.isPaired
        let isReachable = session.isReachable
        let isWatchAppInstalled = session.isWatchAppInstalled
        
        return ["isPaired" : isPaired, "isReachable" : isReachable, "isWatchAppInstalled" : isWatchAppInstalled]
    }
}

class ShareModel {
    let viewController: UIViewController
    let result: FlutterResult
    let call: FlutterMethodCall
    private let watchFaceLibrary = CLKWatchFaceLibrary()
    
    init(_ call: FlutterMethodCall, _ viewController: UIViewController, _ flutterResult: @escaping FlutterResult) {
        self.call = call
        self.viewController = viewController
        self.result = flutterResult
    }
    
    // MARK: - This functions is for sharing the currently open app
    func shareThisApp() {
        if call.arguments == nil {
            result(FlutterError(code: "UNAVAILABLE", message: "No Arguments sent", details: nil))
            return
        }
        guard let appId = call.arguments as? String else {
            result(FlutterError(code: "UNAVAILABLE", message: "Arguments were of wrong type", details: nil))
            return
        }
        
        guard let url = URL(string: "https://apps.apple.com/app/drop-dodge/\(appId)") else {
            result(FlutterError(code: "UNAVAILABLE", message: "Wrong id sent", details: nil))
            return
        }
        ShowActivityController([url])
        result(true)
    }
    
    // MARK: - This function is for validation argument for app store link and sharing
    func validateArgumentsForAppStoreLink() {
        if call.arguments == nil {
            result(FlutterError(code: "UNAVAILABLE", message: "No Arguments sent", details: nil))
            return
        }
        guard let appId = call.arguments as? String else {
            result(FlutterError(code: "UNAVAILABLE", message: "Arguments were of wrong type", details: nil))
            return
        }
        
        if let url = URL(string: "itms-apps://itunes.apple.com/app/\(appId)") {
            UIApplication.shared.open(url)
            result(true)
        } else {
            result(FlutterError(code: "UNAVAILABLE", message: "Wrong id sent", details: nil))
        }
    }
    
    // MARK: - This function is for validating arguments for watch face file append flutter assets path and add that to watch
    func validateArgumentsAndGetFromBundleForWatchFaceFile() {
        if call.arguments == nil {
            result(FlutterError(code: "UNAVAILABLE", message: "No Arguments sent", details: nil))
            return
        }
        guard let bundlePath = call.arguments as? String else {
            result(FlutterError(code: "UNAVAILABLE", message: "Arguments were of wrong type", details: nil))
            return
        }
        
        let bundle = Bundle.main
        var url = bundle.bundleURL
        // finding assets folder in app
        url = url.appendingPathComponent("Frameworks/App.framework/flutter_assets")
        // appending file path
        url = url.appendingPathComponent(bundlePath)
        
        watchFaceLibrary.addWatchFace(at: url) { error in
            if let err = error {
                self.result("Error: \(err.localizedDescription)")
            } else {
                self.result("Success!")
            }
        }
    }
    
    // MARK: - This function is for validating arguments for watch face file and add that to watch
    func validateArgumentsForWatchFaceFile() {
        if call.arguments == nil {
            result(FlutterError(code: "UNAVAILABLE", message: "No Arguments sent", details: nil))
            return
        }
        guard let arguments = call.arguments as? String else {
            result(FlutterError(code: "UNAVAILABLE", message: "Arguments were of wrong type", details: nil))
            return
        }
        
        let watchFaceURL = URL(fileURLWithPath: arguments)
        watchFaceLibrary.addWatchFace(at: watchFaceURL) { err in
            if let err {
                self.result("Error: \(err.localizedDescription)")
            } else {
                self.result("Success!")
            }
        }
    }
    
    // MARK: - This function is to valid arguments for images and call respective one
    func validateArgumentsAndCallFunction(_ methodName: String) -> Void {
        guard call.method == methodName else {
            self.result(FlutterMethodNotImplemented)
            return
        }
        if call.arguments != nil {
            guard let arguments = call.arguments as? NSMutableArray else {
                self.result(FlutterError(code: "UNAVAILABLE", message: "Arguments were of wrong type", details: nil))
                return
            }
            guard let swiftArray = arguments as NSArray as? [FlutterStandardTypedData] else {
                self.result(FlutterError(code: "UNAVAILABLE", message: "Arguments were of wrong type please provide any image's Uint8List", details: nil))
                return
            }
            
            if swiftArray.isEmpty {
                self.result(FlutterError(code: "EMPTY ARRAY", message: "No Images were sent", details: nil))
                return
            }
            
            if swiftArray.count == 1 {
                shareImage(imageBytes: swiftArray[0])
                return
            } else {
                shareImages(images: swiftArray)
                return
            }
        } else {
            self.result(FlutterError(code: "UNAVAILABLE",
                                     message: "Arguments not provided",
                                     details: nil))
        }
    }
    
    // MARK: - function to share multiple images
    private func shareImages(images: [FlutterStandardTypedData]) {
        // set up images to be shared
        var imagesToShare: [UIImage] = []
        images.forEach { imageBytes in
            guard let imageToShare = UIImage(data: imageBytes.data) else {
                self.result(FlutterError(code: "TYPE ERROR", message: "Arguments were of wrong type please provide any image's Uint8List", details: nil))
                return
            }
            imagesToShare.append(imageToShare)
        }
        
        ShowActivityController(imagesToShare)
    }
    
    // MARK: - function to share image only
    private func shareImage(imageBytes: FlutterStandardTypedData) {
        // image to share
        guard let imageToShare = UIImage(data: imageBytes.data) else {
            self.result(FlutterError(code: "UNAVAILABLE", message: "Arguments were of wrong type please provide any image's Uint8List", details: nil))
            return
        }
        
        ShowActivityController([imageToShare])
    }
    
    // MARK: - function to show acitivity controller with the activity items
    private func ShowActivityController(_ activityItems: [Any]) {
        let activityViewController = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
        activityViewController.excludedActivityTypes = [.assignToContact, .mail, .addToReadingList, .mail, .openInIBooks, .postToVimeo, .postToWeibo, .postToFlickr, .postToTwitter, .postToFacebook, .markupAsPDF]
        
        // to make sure iPad doesn't crash
        activityViewController.popoverPresentationController?.sourceView = self.viewController.view
        
        // present the view controller
        self.viewController.present(activityViewController, animated: true, completion: {
            self.result(true)
        })
    }
}
