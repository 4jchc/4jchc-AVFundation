//
//  XMGLrcline.swift
//  02-音乐播放
//
//  Created by 蒋进 on 16/3/8.
//  Copyright © 2016年 蒋进. All rights reserved.
//

import UIKit

class XMGLrcline: NSObject {

    
    /**时间点  */
    var time:NSTimeInterval?
    /**歌  */
    var text:String?
    
    private func initWithLrclineString(lrcText: String) ->XMGLrcline{
        let lrcLine = XMGLrcline()
        // [01:05.43]我想就这样牵着你的手不放开
        let lrcArray:NSArray = lrcText.componentsSeparatedByString("]")
        let timeString:NSString = lrcArray[0] as! NSString;
        
        lrcLine.time = NSString.timeStringWithString(timeString.substringFromIndex(1))
        lrcLine.text = lrcArray[1] as? String;
        return lrcLine
    }
    
    class func lrcLineWithLrclineString(lrcText: String) ->XMGLrcline{
        let lrcLine = XMGLrcline()
        return lrcLine.initWithLrclineString(lrcText)
    }


    
  
}
