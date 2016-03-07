//
//  HMAudioTool.swift
//  4.2baiduMusic
//
//  Created by 蒋进 on 15/11/25.
//  Copyright © 2015年 sijichcai. All rights reserved.
//

import UIKit
import AVFoundation
class HMAudioTool: NSObject {
    
    
    override class func initialize(){
        
        // 1.创建音频会话
        let session: AVAudioSession  = AVAudioSession()
        // 2.设置会话类型
       try!session.setCategory(AVAudioSessionCategoryPlayback)
  
        // 3.激活会话
       try! session.setActive(true)
        
    }
    
    static var soundIDs:NSMutableDictionary? = {
        
        let ani = NSMutableDictionary()
        
        return ani
        }()

   static var players:NSMutableDictionary? = {
        
        let ani = NSMutableDictionary()
        
        return ani
        }()



    
    //MARK: - 播放音效 传入需要 播放的音效文件名称
    class func playAudioWithFilename(filename:NSString ){
        
        // 0.判断文件名是否为nil
        print("playAudioWithFilename*****\(filename)")
        if (filename.length == 0) {
            return;
            
            }
        
        // 1.从字典中取出音效ID
        var soundID: SystemSoundID  = self.soundIDs![filename] as! UInt32
        // 判断音效ID是否为nil
        if soundID  == 0 {
            NSLog("创建新的soundID");
            
            // 音效ID为nil
            // 根据文件名称加载音效URL
            let url: NSURL?  = NSBundle.mainBundle().URLForResource(filename as String, withExtension: nil)!
            
            
            // 判断url是否为nil
            if (url == nil) {
            return;
        }
        
            // 创建音效ID
            AudioServicesCreateSystemSoundID(url! as CFURLRef, &soundID)
                
            // 将音效ID添加到字典中
                self.soundIDs![filename] = (soundID) as? AnyObject
          
            }
            // 播放音效
            AudioServicesPlaySystemSound(soundID);
        }
    
    
    //MARK: - 销毁音效
    class func disposeAudioWithFilename(filename:NSString?) {
        // 0.判断文件名是否为nil
        if (filename == nil) {
            return;
        }
        
        let soundID: SystemSoundID  = self.soundIDs![filename!] as! UInt32
        // 判断音效ID是否为nil
        if soundID  != 0 {
            NSLog("创建新的soundID");
            
            
            // 2.销毁音效ID
            AudioServicesDisposeSystemSoundID(soundID);
            
            // 3.从字典中移除已经销毁的音效ID
            self.soundIDs?.removeObjectForKey(filename!)
            
        }

    }

    
        //MARK: - 根据音乐文件名称播放音乐
        class func playMusicWithFilename(filename:NSString)->AVAudioPlayer? {
            
            print("playMusicWithFilename*****\(filename)")
            
            // 0.判断文件名是否为nil
            if (filename.length == 0) {
                return nil
            }
            
            // 1.从字典中取出播放器
            var player  = self.players!["\(filename)"] as? AVAudioPlayer
  
            
            // 2.判断播放器是否为nil
            
            if (player == nil) {
                NSLog("创建新的播放器");
                
                // 2.1根据文件名称加载音效URL
                // 音效ID为nil
                // 根据文件名称加载音效URL
                let url: NSURL?  = NSBundle.mainBundle().URLForResource(filename as String, withExtension: nil)!
                
                // 2.2判断url是否为nil
                if (url == nil) {
                    return nil
                }
                
                
                // 2.3创建播放器
                
                player = try! AVAudioPlayer(contentsOfURL: url!)
                
                
                // 2.4准备播放
                if player?.prepareToPlay() == false{
                    
                    return nil
                }
                // 允许快进
//                    player!.enableRate = true
//                    player!.rate = 3;
                
                // 2.5将播放器添加到字典中
                self.players!["\(filename)"] = player
             print("2.5将播放器添加到字典中2.5将播放器添加到字典中\(players)")
                
            }
            // 3.播放音乐
            if player?.playing == false{
                
                player?.play()
            }
            
            return player;
        }

    
        
    
    
    //MARK: -  根据音乐文件名称暂停音乐
    
    class func pauseMusicWithFilename(filename:NSString?) {
        
        print("pauseMusicWithFilename*****\(filename)")
        // 0.判断文件名是否为nil
        if (filename == nil) {
            return;
        }

    // 1.从字典中取出播放器
    let player = self.players!["\(filename!)"] as? AVAudioPlayer
    print("从字典中取出播放器\(self.players!["\(filename!)"])")
    // 2.判断播放器是否存在
    
        if(player != nil) {
        // 2.1判断是否正在播放
            if (player!.playing){
            // 暂停
            player!.pause()
            }
        }
    
    }
    //MARK: -  根据音乐文件名称停止音乐
    class func stopMusicWithFilename(filename:NSString?) {
        
        print("stopMusicWithFilename*****\(filename)")
        
        // 0.判断文件名是否为nil
        if (filename == nil) {
            return;
        }
    
        // 1.从字典中取出播放器
        let player = self.players!["\(filename!)"] as? AVAudioPlayer
        print("判断播放器是否存在*****\(player)")
        // 2.判断播放器是否存在
        
        if(player != nil) {
                // 暂停
            player?.stop()
               //player!.pause()
            // 2.2清空播放器
            //        player = nil;
            // 2.3从字典中移除播放器
            self.players?.removeObjectForKey("\(filename)")
           
        }

    }
    

    
    

    
}

    
    

