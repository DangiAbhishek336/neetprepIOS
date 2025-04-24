import UIKit
import CleverTapSDK
import clevertap_plugin
import Flutter
import UserNotifications // Add this import

@main
@objc class AppDelegate: FlutterAppDelegate {

    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        
        // Initialize CleverTap
        CleverTap.autoIntegrate()
        CleverTapPlugin.sharedInstance()?.applicationDidLaunch(options: launchOptions)

        
        // Register Flutter plugins
        GeneratedPluginRegistrant.register(with: self)
        
        // Set UNUserNotificationCenter delegate to handle foreground notifications
        UNUserNotificationCenter.current().delegate = self
        
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    // Handle notifications when the app is in FOREGROUND
    override func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        // Call CleverTap SDK to handle the notification
        CleverTap.sharedInstance()?.recordNotificationViewedEvent(withData: notification.request.content.userInfo)
        
        // Show the notification even in the foreground (with banner, sound, and badge)
       if #available(iOS 14.0, *) {
           completionHandler([.banner, .sound, .badge]) // Modern banner (iOS 14+)
        } else {
        completionHandler([.alert, .sound, .badge])  // Classic alert (iOS 10-13)
    }    }
    
    // Handle notification taps (when the user opens the notification)
    override func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse,
        withCompletionHandler completionHandler: @escaping () -> Void
    ) {
        // Call CleverTap SDK to handle the notification tap
        CleverTap.sharedInstance()?.handleNotification(withData: response.notification.request.content.userInfo)
        
        completionHandler()
    }
}