//
//  AppDelegate.swift
//  SmartCamera
//
//  Created by Sergey Shalnov on 10/02/2019.
//  Copyright © 2019 Sergey Shalnov. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let controller = CameraViewController()
        window?.rootViewController = controller
        window?.makeKeyAndVisible()
        
        return true
    }



}

