import Flutter
import UIKit

public class CreateWatchFacePlugin: NSObject, FlutterPlugin {
    private static func RootViewController() -> UIViewController? {
        var rootViewController: UIViewController? = nil
        if #available(iOS 13.0, *) {
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
        } else {
            rootViewController = UIApplication.shared.keyWindow?.rootViewController
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
 
        if call.method != "create_watch_face_plugin" {
            result(FlutterMethodNotImplemented)
            return
        }
        
        guard let rootViewController = CreateWatchFacePlugin.RootViewController() else {
            result(FlutterError(code: "No root view controller", message: "No root view controller found!", details: nil))
            return
        }
        
        let shareModel = ShareModel(rootViewController, result)
        shareModel.validateArgumentsAndCallFunction("create_watch_face_plugin", call: call)
    }
}

class ShareModel {
    let viewController: UIViewController
    let result: FlutterResult
    
    init(_ viewController: UIViewController, _ flutterResult: @escaping FlutterResult) {
        self.viewController = viewController
        self.result = flutterResult
    }
    
    func validateArgumentsAndCallFunction(_ methodName: String, call: FlutterMethodCall) -> Void {
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
    
    // function to share multiple images
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
    
    // function to share image only
    private func shareImage(imageBytes: FlutterStandardTypedData) {
        // image to share
        guard let imageToShare = UIImage(data: imageBytes.data) else {
            self.result(FlutterError(code: "UNAVAILABLE", message: "Arguments were of wrong type please provide any image's Uint8List", details: nil))
            return
        }
        
        ShowActivityController([imageToShare])
    }
    
    // function to show acitivity controller with the activity items
    private func ShowActivityController(_ activityItems: [Any]) {
        let activityViewController = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
        if activityViewController.excludedActivityTypes == nil {
            activityViewController.excludedActivityTypes = [.assignToContact]
        } else {
            activityViewController.excludedActivityTypes?.append(.assignToContact)
        }
        activityViewController.popoverPresentationController?.sourceView = self.viewController.view // to make sure iPad doesn't crash
        
        // present the view controller
        self.viewController.present(activityViewController, animated: true, completion: {
            self.result(true)
        })
    }
}
