import UIKit
import Flutter
import GoogleMaps

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GMSServices.provideAPIKey("<key>")
    GeneratedPluginRegistrant.register(with: self)
    
    var dict:[String] = ProcessInfo.processInfo.arguments
      dict.append("-FIRDebugEnabled")
      dict.append("-FIRAnalyticsDebugEnabled")
      ProcessInfo.processInfo.setValue(dict, forKey: "arguments")
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
    
}
