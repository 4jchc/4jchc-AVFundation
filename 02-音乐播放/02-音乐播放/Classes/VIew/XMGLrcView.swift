//
//  XMGLrcView.swift
//  02-音乐播放
//
//  Created by 蒋进 on 16/3/8.
//  Copyright © 2016年 蒋进. All rights reserved.
//

import UIKit
import Masonry
class XMGLrcView: UIScrollView{

    /** 当前播放的歌词的下标 */
    var currentIndex: Int = 0
    /** 歌词的数据 */
    var lrclist:NSArray?
    /** 当前播放的时间 */
    //var currentTime:NSTimeInterval?
    /** 外面歌词的Label */
    var lrcLabel:XMGLrcLabel=XMGLrcLabel()
    /** 当前歌曲的总时长 */
    var duration:NSTimeInterval?

    lazy var tableView: UITableView? = {
        let tableView:UITableView = UITableView()
        tableView.backgroundColor = UIColor.clearColor()
        tableView.separatorStyle = .None;
        tableView.rowHeight = 35;
        self.addSubview(tableView)
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false

        return tableView
    }()


    
    //MARK: 重写setLrcName方法
    var lrcName:String?{
        didSet{
            // 0.重置保存的当前位置的下标
            self.currentIndex = 0;
            
            // 1.保存歌词名称
            // 2.解析歌词
            self.lrclist = XMGLrcTool.lrcToolWithLrcName(lrcName!)
            
            // 3.刷新表格
            self.tableView?.reloadData()
      
        }
    }
    //MARK: 重写setCurrentTime当前播放的时间方法
    var currentTime:NSTimeInterval?{
        
        didSet{
  
            //当前时间和歌词进行匹配
            let count = self.lrclist!.count
            for i in 0...count-1 {
                
                // 1.拿到i位置的歌词
                let currentLrcLine = lrclist![i] as? XMGLrcline
                
                // 2.拿到下一句的歌词
                let nextIndex = i + 1
                var nextLrcLine:XMGLrcline?

                if (nextIndex < count) {
                    nextLrcLine = self.lrclist![nextIndex] as? XMGLrcline;
                }
                // 3.用当前的时间和i位置的歌词比较,并且和下一句比较,如果大于i位置的时间,并且小于下一句歌词的时间,那么显示当前的歌词
                if (self.currentIndex != i && currentTime >= currentLrcLine?.time && currentTime < nextLrcLine?.time) {
                    
                    // 1.获取需要刷新的行号
                    let indexPath = NSIndexPath(forRow: i, inSection: 0)
                    let previousIndexPath = NSIndexPath(forRow: currentIndex, inSection: 0)
                    // 2.记录当前i的行号
                    self.currentIndex = i;
                    // 3.刷新当前的行,和上一行
                    tableView!.reloadRowsAtIndexPaths([indexPath,previousIndexPath], withRowAnimation: .None)
                    // 4.显示对应句的歌词
                    tableView!.scrollToRowAtIndexPath(indexPath, atScrollPosition: .Top, animated: true)
                    // 5.设置外面歌词的Label的显示歌词
                    print("外面歌词的Label的显示歌词\(currentLrcLine?.text)")
                    self.lrcLabel.text = currentLrcLine?.text;
                    
                    // 6.生成锁屏界面的图片
                    
                    //[self generatorLockImage];
                }
                // 4.根据进度,显示label画多少
                if (self.currentIndex == i) {
                    // 4.1.拿到i位置的cell
                    let indexPath = NSIndexPath(forRow: i, inSection: 0)
                    let cell = tableView!.cellForRowAtIndexPath(indexPath) as? XMGLrcCell
                    
                    // 4.2.更新label的进度
                    let progress = (currentTime! - currentLrcLine!.time!) / ((nextLrcLine!.time)! - currentLrcLine!.time!)
                    cell?.lrcLabel?.progress = CGFloat(progress)
                    
                    // 4.3.设置外面歌词的Label的进度
                    self.lrcLabel.progress = CGFloat(progress)
                }
            }
        }
    }


    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
     
        //fatalError("init(coder:) has not been implemented")
        
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
        print("lrclist\(lrclist?.count)")
       return self.lrclist?.count ?? 0
    }
    

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        

        let cell:XMGLrcCell = XMGLrcCell.lrcCellWithTableView(tableView)
        
        if (self.currentIndex == indexPath.row) {
            cell.lrcLabel!.font = UIFont.systemFontOfSize(20)
        } else {
            cell.lrcLabel!.font = UIFont.systemFontOfSize(14)
            
            cell.lrcLabel!.progress = 0;
        }
        // 2.给cell设置数据
        // 2.1.取出模型
        let lrcline:XMGLrcline = self.lrclist![indexPath.row] as! XMGLrcline;

        // 2.2.给cell设置数据
        cell.lrcLabel!.text = lrcline.text;
        
        return cell

    }
}






