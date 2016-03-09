//
//  XMGLrcLabel.swift
//  02-音乐播放
//
//  Created by 蒋进 on 16/3/8.
//  Copyright © 2016年 蒋进. All rights reserved.
//

import UIKit

class XMGLrcLabel: UILabel {

    override func drawRect(rect: CGRect) {
        super.drawRect(rect)

        // 1.获取需要画的区域
        let fillRect:CGRect = CGRectMake(0, 0, self.bounds.size.width * self.progress!, self.bounds.size.height);
    
        // 2.设置颜色
        UIColor.redColor().set()
        // 3.添加区域//SourceOut文字外部的颜色
        UIRectFillUsingBlendMode(fillRect, CGBlendMode.SourceIn);
    }
    
    
    var progress:CGFloat? = 0{
        
        didSet{
            setNeedsDisplay()
        }
    }
    

}
