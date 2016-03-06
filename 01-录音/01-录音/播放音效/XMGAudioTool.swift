//
//  XMGAudioTool.swift
//  01-录音
//
//  Created by 蒋进 on 16/3/6.
//  Copyright © 2016年 蒋进. All rights reserved.
//

import UIKit
import AVFoundation
class XMGAudioTool: NSObject {

    static var soundIDs:NSMutableDictionary = {
        
        let ani = NSMutableDictionary()
        
        return ani
    }()

    //static var soundIDs:NSMutableArray?
    // 当第一次使用这个类的时候会调用一次
    override class func initialize(){
        //soundIDs = NSMutableArray()
        
    }
    static  func playSoundWithSoundname(soundname:String){
        
        // 1.定义SystemSoundID
        var soundID:SystemSoundID=0
        
        // 2.从字典中取出对应soundID,如果取出是nil,表示之前没有存放在字典
        soundID = soundIDs[soundname] as! UInt32

        if (soundID == 0) {
            let url:NSURL = NSBundle.mainBundle().URLForResource(soundname, withExtension: nil)!
            let urlRef:CFURLRef = url as CFURLRef

            AudioServicesCreateSystemSoundID(urlRef, &soundID);
            
            // 将soundID存入字典
            soundIDs.setObject(soundID as! AnyObject , forKey: soundname)
            }
        
        // 3.播放音效
        AudioServicesPlaySystemSound(soundID);
        
    }

}
