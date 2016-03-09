//
//  HMMusicsViewController.swift
//  4.2baiduMusic
//
//  Created by 蒋进 on 15/11/25.
//  Copyright © 2015年 sijichcai. All rights reserved.
//

import UIKit

class HMMusicsViewController: UITableViewController {


    lazy var playingVc:HMPlayingViewController? = {
        
        let ani = HMPlayingViewController()
        
        return ani
        }()

    lazy var anim:NSMutableArray? = {
        
        let ani = NSMutableArray()
        
        return ani
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()


    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows[[HMMusicsTool musics] count];
        return (HMMusicsTool.musics?.count)!
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let ID:NSString = "cell"
        var cell = tableView.dequeueReusableCellWithIdentifier(ID as NSString as String)
        
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: ID as String)
        }
        // 2.设置数据

        let music  = HMMusicsTool.musics![indexPath.row] as! HMMusic
        
       cell!.imageView!.image = UIImage.circleImageWithName(music.singerIcon, border: 5.0, borderColor: UIColor.blueColor())
  
        cell!.textLabel!.text = music.name;
        cell!.detailTextLabel!.text = music.singer;

        return cell!
    }
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // 选中某一个行

            // 1.主动取消选中
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
            // 2.执行segue跳转到播放界面
        //self.performSegueWithIdentifier("musics2playing", sender: nil)
            /*
            1.直接传递
            */
            //    self.playingVc.music = self.musics[indexPath.row];
            //    self.playingVc.musics = self.musics;
            //    self.playingVc.datasource = self;
            // 3.设置当前播放的音乐
        
        let music = HMMusicsTool.musics![indexPath.row] as! HMMusic;
        HMMusicsTool.setPlayingMusic(music)
            
            self.playingVc!.show()
    
    }
    
    
    
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
       return 100;
    }
    
    
    
}