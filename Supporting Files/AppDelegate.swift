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
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        let root = BaseNavBarVC(rootViewController: LoadAppVC())
        
        let window = UIWindow(frame: UIScreen.mainScreen().bounds)
        window.rootViewController = root
        window.makeKeyAndVisible()
        self.window = window
        
        return true
    }
    
}
