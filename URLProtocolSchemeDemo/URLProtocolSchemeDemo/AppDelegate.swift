//
//  AppDelegate.swift
//  URLProtocolSchemeDemo
//
//  Created by Minecode on 2018/10/7.
//  Copyright © 2018年 Minecode. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        
        let vc = HomeViewController()
        let nvc = UINavigationController(rootViewController: vc)
        window?.rootViewController = nvc
        
        return true
    }

}

