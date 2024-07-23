//
//  AppDelegate.swift
//  BAQQMusic
//
//  Created by boai on 2024/7/22.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.frame = UIScreen.main.bounds
        let vc = UINavigationController(rootViewController: BAHomeVC())
        window?.rootViewController = vc//PlayMusicViewController()
        window?.backgroundColor = .white
        window?.makeKeyAndVisible()
        return true
    }


}

