//
//  XMGLrcCell.swift
//  02-音乐播放
//
//  Created by 蒋进 on 16/3/8.
//  Copyright © 2016年 蒋进. All rights reserved.
//

import UIKit

class XMGLrcCell: UITableViewCell {

    var lrcLabel:XMGLrcLabel?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        let lrcLabel:XMGLrcLabel = XMGLrcLabel()
        lrcLabel.textColor = UIColor.greenColor()
        lrcLabel.font = UIFont.systemFontOfSize(14)
        lrcLabel.textAlignment = NSTextAlignment.Center;
        self.contentView.addSubview(lrcLabel)
        self.lrcLabel = lrcLabel;
        
        lrcLabel.translatesAutoresizingMaskIntoConstraints = false
        lrcLabel.mas_makeConstraints { (make) -> Void in
//            make.top.equalTo()(self.mas_top);
//            make.bottom.equalTo()(self.mas_bottom);
//            make.height.equalTo()(self.mas_height);
//            make.left.equalTo()(self.mas_left).offset()(self.bounds.size.width);
//            make.right.equalTo()(self.mas_right);
//            make.width.equalTo()(self.mas_width);
            make.center.equalTo()(self.contentView);
        }

    }
   static func lrcCellWithTableView(tableView:UITableView)->XMGLrcCell{
        
        let ID:String = "LrcCell"
        var cell = tableView.dequeueReusableCellWithIdentifier(ID) as? XMGLrcCell
        if cell == nil {
            cell = XMGLrcCell(style: UITableViewCellStyle.Default, reuseIdentifier: ID)
            cell!.backgroundColor = UIColor.clearColor()
            cell!.selectionStyle = UITableViewCellSelectionStyle.None;
        }
        return cell!

    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}






