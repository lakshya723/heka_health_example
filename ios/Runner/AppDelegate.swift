import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
     let controller : FlutterViewController = window?.rootViewController as! FlutterViewController;
      
      let METHOD_CHANNEL_NAME = "com.example.fit-track/health";
      let healthChannel = FlutterMethodChannel(
        name: METHOD_CHANNEL_NAME,
        binaryMessenger: controller.binaryMessenger);

         healthChannel.setMethodCallHandler({
          (call: FlutterMethodCall, result: @escaping FlutterResult) ->  Void in
          switch call.method {
          case "syncData":
              result(self.syncData(call: call, result: result))
              
          default:
              result(FlutterMethodNotImplemented)
          }
      });
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

   private func syncData(call: FlutterMethodCall, result: @escaping FlutterResult) -> Int  {
    let healthStore = HealthStore()
       healthStore.requestAuthorization {
           success in
           if success {
             // Setup observer query
               guard let args = call.arguments as? [String: String] else {return}
               let apiKey = args["apiKey"]!
               let userUuid = args["userUuid"]!
               
               healthStore.setupStepsObserverQuery(apiKey: apiKey, userUuid: userUuid)
           }
       }
       return 0
   }
}
