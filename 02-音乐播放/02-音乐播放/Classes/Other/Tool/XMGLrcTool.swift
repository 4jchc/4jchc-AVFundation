//
//  XMGLrcline.swift
//  02-音乐播放
//
//  Created by 蒋进 on 16/3/8.
//  Copyright © 2016年 蒋进. All rights reserved.
//

import UIKit

class XMGLrcTool: NSObject {

    func lrcToolWithLrcName(lrcName:String)->NSArray{
        
        // 1.拿到歌词文件的路径
        let lrcPath:String = NSBundle.mainBundle().pathForResource(lrcName, ofType: nil)!
        // 2.读取歌词
        let lrcString:NSString = try! NSString(contentsOfFile: lrcPath, encoding: NSUTF8StringEncoding)
        // 3.拿到歌词的数组
        let lrcArray:NSArray = lrcString.componentsSeparatedByString("\n")
        
        // 4.遍历每一句歌词,转成模型
        let tempArray:NSMutableArray = NSMutableArray()
        for lrclineString in lrcArray{
            let lrclineString = lrclineString as! NSString
            // 过滤不需要的歌词的行
            if lrclineString.hasPrefix("[ti:") || lrclineString.hasPrefix("[ar:") || lrclineString.hasPrefix("[al:") || lrclineString.hasPrefix("["){
                
                continue
            }
            // 拿到每一句歌词
            /*
            [ti:心碎了无痕]
            [ar:张学友]
            [al:]
            */
            
            // 将歌词转成模型
//            
//            XMGLrcline *lrcLine = [XMGLrcline lrcLineWithLrclineString:lrclineString];
//            [tempArray addObject:lrcLine];
            
        }

        return tempArray;
        
    }

}
