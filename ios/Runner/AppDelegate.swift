import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}


// import Flutter
// import UIKit
// import flutter_local_notifications
// // import UserNotifications

// @main
// @objc class AppDelegate: FlutterAppDelegate {
//   override func application(
//     _ application: UIApplication,
//     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
//   ) -> Bool {

//     // Register the plugin
//     FlutterLocalNotificationsPlugin.setPluginRegistrantCallback { (registry) in
//       GeneratedPluginRegistrant.register(with: registry)
//     }

//     GeneratedPluginRegistrant.register(with: self)

//     // Set delegate for notifications if iOS 10.0 or newer
//     if #available(iOS 10.0, *) {
//       UNUserNotificationCenter.current().delegate = self
//     }

//     return super.application(application, didFinishLaunchingWithOptions: launchOptions)
//   }
// }
