//
//  AppDelegate.swift
//  4.2baiduMusic
//
//  Created by 蒋进 on 15/11/25.
//  Copyright © 2015年 sijichcai. All rights reserved.
//

import UIKit
import AVFoundation
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var identifiTask: UIBackgroundTaskIdentifier?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
//        // 开启后台任务
//         self.identifiTask  = application.beginBackgroundTaskWithExpirationHandler { () -> Void in
//            application.endBackgroundTask(self.identifiTask!)
//        }
//        
//        NSNotificationCenter.defaultCenter().addObserver(self, selector: "audioSessionInterrupted:", name: AVAudioSessionInterruptionNotification, object: AVAudioSession.sharedInstance())
        // 1.获取音频回话
        let session:AVAudioSession = AVAudioSession.sharedInstance()


        do{
            // 2.设置后台播放类别
            try session.setCategory(AVAudioSessionCategoryPlayback)
            // 3.激活回话
            try session.setActive(true)
            
        }catch{
            
            
            print(error)
            
        }
        return true
    }
    
    
    //MARK: - Notifications
    func audioSessionInterrupted(notification:NSNotification)
    {
        print("interruption received: \(notification)")
    }
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

