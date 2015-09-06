//
//  AppDelegate.swift
//  FontBrowser
//
//  Created by Daniel Krofchick on 2015-09-03.
//  Copyright (c) 2015 Figure1. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var backgroundTask = UIBackgroundTaskInvalid

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        return true
    }
    
    func applicationWillResignActive(application: UIApplication) {
        registerBackgroundTask()
    }
    
    func applicationWillEnterForeground(application: UIApplication) {
        endBackgroundTask()
    }
    
    func registerBackgroundTask() {
        backgroundTask = UIApplication.sharedApplication().beginBackgroundTaskWithExpirationHandler {
            [unowned self] in
            self.endBackgroundTask()
        }
        assert(backgroundTask != UIBackgroundTaskInvalid)
        println("backgroundTaskStarted")
    }
    
    func endBackgroundTask() {
        UIApplication.sharedApplication().endBackgroundTask(backgroundTask)
        backgroundTask = UIBackgroundTaskInvalid
        println("backgroundTaskEnded")
    }

}

