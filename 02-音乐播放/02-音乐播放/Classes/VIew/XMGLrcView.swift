//
//  XMGLrcView.swift
//  02-音乐播放
//
//  Created by 蒋进 on 16/3/8.
//  Copyright © 2016年 蒋进. All rights reserved.
//

import UIKit
import Masonry
class XMGLrcView: UIScrollView {

    /** tableView */
    var tableView:UITableView?
    /** 当前播放的歌词的下标 */
    var currentIndex: Int = 0
    /** 歌词的数据 */
    var lrclist:NSArray?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupTableView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        setupTableView()
        //fatalError("init(coder:) has not been implemented")
        
    }
    
    func setupTableView(){
        // 1.创建tableView
        let tableView:UITableView = UITableView()
        tableView.backgroundColor = UIColor.clearColor()
        tableView.separatorStyle = UITableViewCellSeparatorStyle.None;
        tableView.rowHeight = 35;
        self.addSubview(tableView)
        tableView.dataSource = self;
        tableView.translatesAutoresizingMaskIntoConstraints = false
        self.tableView = tableView;
    }
    override func layoutSubviews() {
        
        super.layoutSubviews()
        self.tableView!.translatesAutoresizingMaskIntoConstraints = false
        // Masonry
        self.tableView!.mas_makeConstraints { (make) -> Void in
            make.top.equalTo()(self.mas_top);
            make.bottom.equalTo()(self.mas_bottom);
            make.height.equalTo()(self.mas_height);
            make.left.equalTo()(self.mas_left).offset()(self.bounds.size.width);
            make.right.equalTo()(self.mas_right);
            make.width.equalTo()(self.mas_width);
        }
        // 设置tableView多出的滚动区域
        self.tableView!.contentInset = UIEdgeInsetsMake(self.bounds.size.height * 0.5, 0, self.bounds.size.height * 0.5, 0);
    }
    
}


extension XMGLrcView :UITableViewDataSource{

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
       return 10//self.lrclist?.count ?? 0
    }
    

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let ID:String = "contact"
        var cell:UITableViewCell? = tableView.dequeueReusableCellWithIdentifier(ID as String)
        
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: ID as String)
        }
        cell!.textLabel!.text = String(format: "----%zd",indexPath.row)
        
        
        return cell!
    }
}






