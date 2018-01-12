//
//  AppDelegate.swift
//  Quixpense
//
//  Created by Matt Quiros on 12/01/2018.
//  Copyright © 2018 Matt Quiros. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        let keyWindow = UIWindow(frame: UIScreen.main.bounds)
        keyWindow.rootViewController = RootTabBarController()
        keyWindow.makeKeyAndVisible()
        window = keyWindow
        return true
    }
    
}

