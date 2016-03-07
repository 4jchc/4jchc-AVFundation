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
    
    static var  playSongs = NSMutableDictionary()
    static var soundIDs:NSMutableDictionary = NSMutableDictionary()
    
    class var userList: NSMutableDictionary {
        struct Static {
            static let instance: NSMutableDictionary = NSMutableDictionary()
        }
        return Static.instance
    }
    //static var soundIDs:NSMutableArray?
    // 当第一次使用这个类的时候会调用一次
    override class func initialize(){
        //soundIDs = NSMutableArray()
        
    }
    //MARK: - 音效播放
    // 播放声音文件soundName : 音效文件的名称
    static  func playSoundWithSoundname(soundname:String){
        
        // 1.定义SystemSoundID
        var soundID:SystemSoundID=0
        
        // 2.从字典中取出对应soundID,如果取出是nil,表示之前没有存放在字典
        
        if let soundI = soundIDs[soundname]?.integerValue{
            soundID = UInt32(soundI)
            
        }else{
            
            let url = NSBundle.mainBundle().URLForResource(soundname, withExtension: nil)
            if url == nil{
                
                return
            }
            let urlRef:CFURLRef = url as! CFURLRef
            
            AudioServicesCreateSystemSoundID(urlRef, &soundID);
            // 将soundID存入字典
            let sound = Int(soundID) as AnyObject
            soundIDs.setObject(sound, forKey: soundname)
            
        }
        // 3.播放音效
        AudioServicesPlaySystemSound(soundID);
        
    }
    
    //MARK: -  音乐播放
    // 播放音乐 musicName : 音乐的名称
    static func playMusicWithMusicName(musicName:String)->AVAudioPlayer{
        
        var audioPlayer:AVAudioPlayer?
        audioPlayer = playSongs[musicName] as? AVAudioPlayer
        
        if audioPlayer == nil {
            let fileUrl = NSBundle.mainBundle().URLForResource(musicName, withExtension: nil)
            if fileUrl != nil {
                //去创建对应的播放器
                do{
                    audioPlayer = try AVAudioPlayer(contentsOfURL: fileUrl!)
                    playSongs.setObject(audioPlayer!, forKey: musicName)
                    audioPlayer!.prepareToPlay()
                    
                }catch{
                    print("臣妾真的不想来这里")
                }
            }
        }
        audioPlayer!.play()
        return audioPlayer!
        
    }
    
    // 暂停音乐 musicName : 音乐的名称
    static func pauseMusicWithMusicName(musicName:String){
        
        let player = playSongs[musicName];
        
        if (player != nil) {
            player?.pause()
        }
        
    }
    
    // 停止音乐 musicName : 音乐的名称
    static func stopMusicWithMusicName(musicName:String){
        
        var player = playSongs[musicName];
        if (player != nil) {
            player!.player
            playSongs.removeObjectForKey(musicName)
            player = nil;
        }
        
    }
    
    
    
}
