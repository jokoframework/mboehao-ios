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
        //Configurar Firebase
        FirebaseApp.configure()
        //Configurar Google SignIn
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        //Solicitar permiso al usuario para recibir notificaciones
        UNUserNotificationCenter.current().delegate = self
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (_, error) in
            if error != nil {
                print("Error en el proceso de autorización")
            }
        }

        UIApplication.shared.registerForRemoteNotifications()
        //Configurar Facebook
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        //Alerta de falta de conexión a Internet
        let alert = WPSAlertController.init(title: "Sin conexión a internet",
                                            message: "Asegurese que su dispositivo esté conectado a Internet",
                                            preferredStyle: .alert)
        checkInternetConnectivity(alert: alert)
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
//Funcion que usa Alamofire para checkear la conexión a Internet y muestra una alerta
func checkInternetConnectivity(alert: WPSAlertController) {
    let reachabilityManager = NetworkReachabilityManager()
    //Mirar primero si la app fue iniciada ya sin conexión a internet
    if let firstCheck = reachabilityManager?.isReachable, !firstCheck {
        alert.show(animated: true)
    }
    reachabilityManager?.startListening()
    reachabilityManager?.listener = { _ in
        if let isNetworkReachable = reachabilityManager?.isReachable, !isNetworkReachable {
            alert.show(animated: true)
        } else {
            alert.dismiss(animated: true, completion: nil)
        }
    }
}
