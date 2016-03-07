//
//  HMMusicsTool.swift
//  4.2baiduMusic
//
//  Created by 蒋进 on 15/11/25.
//  Copyright © 2015年 sijichcai. All rights reserved.

import UIKit
import MJExtension

class HMMusicsTool: NSObject {
    

    // 所有歌曲
    static var musics:NSMutableArray? = {
        
        var ani = HMMusic.mj_objectArrayWithFilename("Musics.plist")
        return ani
    }()
    
    
    
    // 当前正在播放歌曲
    static var playingMusics:HMMusic!
    
    
    /**  正在播放的歌*/
    class func playingMusicing() -> HMMusic{
        return playingMusics!
    }
    
    
    
    //MARK: -  设置当前正在播放的音乐
    class func setPlayingMusic(music:HMMusic?){
        // 判断传入的音乐模型是否为nil
        // 判断数组中是否包含该音乐模型
        if music == nil || self.musics?.containsObject(music!) == false {
            return;
        }
        
        playingMusics = music;
    }
    
    
    
    
    
    //MARK: -  获取下一首
    class func nextMusic() -> HMMusic  {
        // 1.获取当前播放的索引
        let currentIndex: Int  = (self.musics?.indexOfObject(playingMusics!))!
        
        // 2.计算下一首的索引
        var nextIndex:Int  = currentIndex + 1;
        // 3.越界处理
        
        if (nextIndex >= self.musics!.count) {
            nextIndex = 0;
        }
        // 4.取出下一首的模型返回
        return self.musics![nextIndex] as! HMMusic
        
    }
    
    
    //MARK: -  获取上一首
    class func previouesMusic() -> HMMusic  {
        
        // 1.获取当前播放的索引
        let currentIndex: Int  = (self.musics?.indexOfObject(playingMusics!))!
        // 2.计算下一首的索引
        var perviouesIndex:Int  = currentIndex - 1;
        // 3.越界处理
        if (perviouesIndex < 0) {
            perviouesIndex = self.musics!.count - 1
        }
        // 4.取出下一首的模型返回
        return self.musics![perviouesIndex] as! HMMusic
        
    }
    
}




