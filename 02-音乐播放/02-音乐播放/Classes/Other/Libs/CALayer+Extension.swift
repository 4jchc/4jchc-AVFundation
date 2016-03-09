//
//  CALayer+PauseAimate.swift
//  4jchc-Extension
//
//  Created by 蒋进 on 16/3/8.
//  Copyright © 2016年 sijichcai. All rights reserved.
//

import UIKit

extension CALayer {

    func pauseAnimation() {
        let pauseTime = convertTime(CACurrentMediaTime(), fromLayer: nil)
        speed = 0
        timeOffset = pauseTime
    }
    
    func resumeAnimation() {
        let pausedTime = timeOffset
        speed = 1
        timeOffset = 0.0
        beginTime = 0.0
        let timeSincePause = convertTime(CACurrentMediaTime(), fromLayer: nil) - pausedTime
        beginTime = timeSincePause
    }
}

extension NSString {
    class func stringWithTime(time: NSTimeInterval) ->String {
        let min = time / 60
        let seconde = time % 60
        
        return String(format: "%02.f:%02.f",min,seconde)
    }
    
    class func timeStringWithString(timeString: NSString) ->Double {

        let min = timeString.componentsSeparatedByString(":")[0].doubleValue
        let second = timeString.substringWithRange(NSMakeRange(3, 2)).doubleValue
        let haomiao = timeString.componentsSeparatedByString(".")[1].doubleValue
        return (min * 60 + second + haomiao * 0.01)
       
    }
}


extension String {
    var doubleValue: Double {
        return (self as NSString).doubleValue
    }
}

extension UIImage {
    /**
     根据文字的高度和传来的文字来生成水印文字
     
     :param: titleH      文字的高度
     :param: currText    中间行的文字
     :param: prevousText 上一行
     :param: nextText    下一行
     
     :returns: 返回的图片
     */
    func setImageWithString(titleH:CGFloat  ,currText:NSString,prevousText:NSString?,nextText:NSString?) -> UIImage {
        //获取图像上下文
        UIGraphicsBeginImageContext(size)
        //将图像画上去
        self.drawInRect(CGRectMake(0, 0, size.width, size.height))
        let style = NSMutableParagraphStyle()
        
        style.alignment = .Center
        let currTextAttributes = [
            NSFontAttributeName:UIFont.systemFontOfSize(18),
            NSForegroundColorAttributeName:UIColor(red: 38/255.0, green: 187/255.0, blue: 102/255.0, alpha: 1.0),
            NSParagraphStyleAttributeName:style
        ]
        
        let otherTextAttributes = [
            NSFontAttributeName:UIFont.systemFontOfSize(16),
            NSForegroundColorAttributeName:UIColor.whiteColor(),
            NSParagraphStyleAttributeName:style
        ]
        //当前行
        currText.drawInRect(CGRectMake(0, size.height - (titleH * 2), size.width, size.height), withAttributes: currTextAttributes)
        
        prevousText!.drawInRect(CGRectMake(0, size.height - (titleH * 3), size.width, size.height), withAttributes: otherTextAttributes)
        nextText!.drawInRect(CGRectMake(0, size.height - titleH, size.width, size.height), withAttributes: otherTextAttributes)
        //生成图片
        let textImage = UIGraphicsGetImageFromCurrentImageContext()
        //关闭上下文
        UIGraphicsEndImageContext()
        return textImage
    }
}
