//
//  AppDelegate.swift
//  AppboosterClientLoggerExample
//
//  Created by Appbooster on 26/12/2018.
//  Copyright © 2018 Appbooster. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?

  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {

    /* Activation of AppboosterClientLogger, you can control the logs writing */

    AppboosterClientLogger.activate(writeLogs: true)

    return true
  }

}
