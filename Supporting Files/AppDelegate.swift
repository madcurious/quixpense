//
//  AppDelegate.swift
//  Spare
//
//  Created by Matt Quiros on 20/04/2016.
//  Copyright © 2016 Matt Quiros. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        let root = TabbedRootViewController()
        
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.rootViewController = root
        window.makeKeyAndVisible()
        self.window = window
        
        return true
    }
    
}
