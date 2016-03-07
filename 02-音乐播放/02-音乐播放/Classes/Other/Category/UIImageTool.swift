//
//  图片常用方法.swift
//  07-01图片水印
//
//  Created by 蒋进 on 15/10/10.
//  Copyright © 2015年 sijichcai. All rights reserved.
//

import UIKit
///*****✅返回一个截屏图片-剪切的头像
//class UIImageTool: UIImage {
    
    extension UIImage{
    
///*****✅返回一个截屏图片
  class func imageWithCaptureView(view:UIView) -> UIImage{
        
    // 开启上下文
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, false, 0.0);
    
    // 获取上下文
    let ctx:CGContextRef = UIGraphicsGetCurrentContext()!

    // 渲染控制器view的图层到上下文
    // 图层只能用渲染不能用draw
    view.layer.renderInContext(ctx)

    // 获取截屏图片
    let newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()

    // 关闭上下文
    UIGraphicsEndImageContext();
    
    ////*****✅/ 把图片转换成png格式的二进制数据
    //   let d:NSData = UIImagePNGRepresentation(newImage)!
    
    ////*****✅/ 写入桌面
    //还没实现
    //   d.writeToFile("/Users/jiangjin/Desktop/newImage.png", atomically: true)
    
        
    return newImage;
        
}
    
    
    
    
///*****✅返回一个剪切的头像 border:
  class  func circleImageWithName(name:NSString, border:CGFloat,borderColor color:UIColor) ->UIImage{

        // 圆环的宽度
        let borderW:CGFloat = border;
    
        // 1.加载原图
        let oldImage:UIImage =  UIImage(named: name as String)!
    

        // 2.开启上下文
        // 新的图片尺寸
        let imageW:CGFloat = oldImage.size.width + 2 * borderW;
        let imageH:CGFloat  = oldImage.size.height + 2 * borderW;
        // 设置新的图片尺寸
        let circirW:CGFloat  = imageW > imageH ? imageH : imageW;
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(circirW, circirW), false, 0.0);
    
    
        // 3.取得当前的上下文
        let ctx:CGContextRef = UIGraphicsGetCurrentContext()!
    
        // 4.画边框(大圆)
    
        let path:UIBezierPath = UIBezierPath(ovalInRect: CGRectMake(0, 0, circirW, circirW))
        // 添加到上下文
        CGContextAddPath(ctx, path.CGPath);
        // 设置颜色
        color.set()
        // 渲染
        CGContextFillPath(ctx);
        
        let clipR:CGRect = CGRectMake(borderW, borderW, oldImage.size.width, oldImage.size.height);
        
        // 画圆：正切于旧图片的圆
        let clipPath:UIBezierPath = UIBezierPath(ovalInRect: clipR)
 
        // 设置裁剪区域
        clipPath.addClip()
    
        // 6.画图
        oldImage.drawAtPoint(CGPointMake(borderW, borderW))

        // 7.取图
        let newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()
        
        // 8.结束上下文
        
        UIGraphicsEndImageContext();
        
        ////*****✅/ 把图片转换成png格式的二进制数据
     //   let d:NSData = UIImagePNGRepresentation(newImage)!
        
        ////*****✅/ 写入桌面
        //还没实现
     //   d.writeToFile("/Users/jiangjin/Desktop/\(name).png", atomically: true)
        
        return newImage;
        }
        
 
    
  }

