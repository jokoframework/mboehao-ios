//
//  AppDelegate.swift
//  iOS Starter Kit
//
//  Created by nessvaldez on 12/13/17.
//  Copyright © 2017 Sodep. All rights reserved.
//

import UIKit
import FirebaseCore
import FirebaseMessaging
import FirebaseInstanceID
import Firebase
import GoogleSignIn
import UserNotifications
import Alamofire
import FBSDKCoreKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, MessagingDelegate {
    var window: UIWindow?
    // swiftlint:disable:next line_length
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        UNUserNotificationCenter.current().delegate = self
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (_, error) in
            if error != nil {
                print("Error en el proceso de autorización")
            }
        }
        let alert = WPSAlertController.init(title: "Sin conexión a internet",
                                            message: "Asegurese que su dispositivo esté conectado a Internet",
                                            preferredStyle: .alert)
        UIApplication.shared.registerForRemoteNotifications()
        checkInternetConnectivity(alert: alert)
        //Facebook
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        return true
    }
    // MARK: Google Sign In Methods
    func application(_ app: UIApplication,
                     open url: URL,
                     options: [UIApplicationOpenURLOptionsKey: Any] = [:]) -> Bool {
        // swiftlint:disable line_length
        let googleDidHandle = GIDSignIn.sharedInstance().handle(url, sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String, annotation: [:])
        let facebookDidHandle = FBSDKApplicationDelegate.sharedInstance().application(app,
                                                                                      open: url,
                                                                                      sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String,
                                                                                      annotation: [:])
        // swiftlint:enable line_length
        return googleDidHandle || facebookDidHandle
    }
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        print("El usuario se desconectó de la app")
    }
    // MARK: FB Sign IN
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        print("Got a token \(deviceToken)")
        connectToFirebaseCM()
    }
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("No se pudo registrar \(error)")
    }
    func connectToFirebaseCM() {
        Messaging.messaging().shouldEstablishDirectChannel = true
    }
    func applicationDidEnterBackground(_ application: UIApplication) {
        Messaging.messaging().shouldEstablishDirectChannel = false
    }

}

//Para mostrar las notificaciones si la app está abierta.
extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                // swiftlint:disable:next line_length
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler(.alert)
    }
}

func checkInternetConnectivity(alert: WPSAlertController) {
    let reachabilityManager = NetworkReachabilityManager()
    reachabilityManager?.startListening()
    reachabilityManager?.listener = { _ in
        if let isNetworkReachable = reachabilityManager?.isReachable, !isNetworkReachable {
            alert.show(animated: true)
        } else {
            alert.dismiss(animated: true, completion: nil)
        }
    }
}
