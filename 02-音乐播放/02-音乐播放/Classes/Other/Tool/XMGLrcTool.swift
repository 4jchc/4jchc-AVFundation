//
//  XMGLrcline.swift
//  02-音乐播放
//
//  Created by 蒋进 on 16/3/8.
//  Copyright © 2016年 蒋进. All rights reserved.
//

import UIKit

class XMGLrcTool: NSObject {

    /// 根据歌词名称来返回该歌词的对象数组(歌词每一行)
    class func lrcToolWithLrcName(lrcName:String)->NSArray {
        // 1.拿到歌词文件的路径
        let lrcPath = NSBundle.mainBundle().pathForResource(lrcName, ofType: nil)
        //承载转换的模型
        let tempArr = NSMutableArray()
 
        do{
            // 2.读取歌词
            let lrcString = try String(contentsOfFile: lrcPath!)
            // 3.拿到歌词的数组
            let lrcArr = lrcString.componentsSeparatedByString("\n")
            // 4.遍历每一句歌词,转成模型
            for  lrclineString:NSString in lrcArr {
                
                if lrclineString.hasPrefix("[ti:") || lrclineString.hasPrefix("[ar:") || lrclineString.hasPrefix("[al:") || !lrclineString.hasPrefix("["){
                    continue
                }
                // 将歌词转成模型
                let lrcLine = XMGLrcline.lrcLineWithLrclineString(lrclineString as String)
                tempArr.addObject(lrcLine)
            }
        }catch{
            print("这里真的没有了啊")
        }
    
        
        return tempArr
    }

    
    
    
//       static func lrcToolWithLrcName(lrcName:String)->NSArray{
//    
//            // 1.拿到歌词文件的路径
//            let lrcPath:String = NSBundle.mainBundle().pathForResource(lrcName, ofType: nil)!
//            // 2.读取歌词
//           // let lrcString:NSString = try! NSString(contentsOfFile: lrcPath, encoding: NSUTF8StringEncoding)
//            let lrcString:NSString = try! String(contentsOfFile: lrcPath)
//            // 3.拿到歌词的数组
//            let lrcArray:[String] = lrcString.componentsSeparatedByString("\n")
//    
//            // 4.遍历每一句歌词,转成模型
//            let tempArray = NSMutableArray()
//            for lrclineString:NSString in lrcArray {
//    
//                // 过滤不需要的歌词的行
//                if lrclineString.hasPrefix("[ti:") || lrclineString.hasPrefix("[ar:") || lrclineString.hasPrefix("[al:") || !lrclineString.hasPrefix("["){
//    
//                    continue
//                }
//    
//                // 拿到每一句歌词
//                /*
//                [ti:心碎了无痕]
//                [ar:张学友]
//                [al:]
//                */
//                // 将歌词转成模型
//                let lrcLine:XMGLrcline = XMGLrcline.lrcLineWithLrclineString(lrcString as String)
//                tempArray.addObject(lrcLine)
//        }
//            return tempArray;
//        }
    
    
    
}

