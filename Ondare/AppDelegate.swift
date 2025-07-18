//
//  AppDelegate.swift
//  Ondare
//
//  Created by Eldar Tutnjic on 5. 7. 2025..
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var applicationCoordaintor: ApplicationCoordinator!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let window = UIWindow(frame: UIScreen.main.bounds)

        applicationCoordaintor = ApplicationCoordinator(window: window)
        applicationCoordaintor.start()

        return true
    }
}
