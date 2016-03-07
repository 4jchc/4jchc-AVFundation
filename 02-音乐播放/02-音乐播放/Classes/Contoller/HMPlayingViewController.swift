//
//  HMPlayingViewController.swift
//  4.2baiduMusic
//
//  Created by 蒋进 on 15/11/25.
//  Copyright © 2015年 sijichcai. All rights reserved.
//

import UIKit
import AVFoundation

class HMPlayingViewController: UIViewController,AVAudioPlayerDelegate {
    
    
    
    //MARK: - 当前正在播放的音乐
    
    var playingMusic:HMMusic?
 
    
    
    //MARK: - 当前播放器
    
    var player:AVAudioPlayer!

    
     //MARK: - 时长
     
    @IBOutlet weak var durationLabel: UILabel?

    
    //MARK: - 获取进度定时器
    
    var progressTimer:NSTimer?
  
    
    //MARK: - 开启定时器
    
    func addProgressTimer(){
        
        // 1.判断是否正在播放音乐
        if(self.player.playing == false){
            return
        }
        
        // 保证数据同步, 立即更新
        
        self.removeProgressTimer()
        
        self.updateCurrentProgress()
        // 2.创建定时器
        self.progressTimer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: "updateCurrentProgress", userInfo: nil, repeats: true)

        // 3.将定时器添加到事件循环
        NSRunLoop.mainRunLoop().addTimer(self.progressTimer!, forMode: NSRunLoopCommonModes)

        
    }
    
    //MARK: - 移除定时器
    
    func removeProgressTimer(){
        
        self.progressTimer?.invalidate()
        self.progressTimer = nil;
        print("****progressTimer\(progressTimer)")
        
    }
    
    
    //MARK: - 滑块
    @IBOutlet weak var slider: UIButton!
    

 
    
    //MARK: - 蓝色播放进度
    
    @IBOutlet weak var progressView: UIView!
   
    
    //MARK: - 监听进度条的点击
    
    @IBAction func onProgressBgTap(sender: UIGestureRecognizer) {
        

        // 1.取出当前点击的位置
        let point: CGPoint = sender.locationInView(sender.view)

        // 2.设置滑块的位置, 为点击的位置
        self.slider.frame.origin.x = point.x;
        // 3.计算进度
        let progress:Double = Double(point.x / (sender.view?.frame.size.width)!)
        // 4.设置播放事件
        self.player.currentTime = progress * self.player.duration;
        // 5.立即更新
        self.updateCurrentProgress()
        
        
    }
    //MARK: - 监听滑块拖拽事件
    @IBAction func onPanSlider(sender: UIPanGestureRecognizer) {
        
        
        // 获取到滑块平移的位置
        // 1.取出当前点击的位置
        let point: CGPoint = sender.locationInView(sender.view)
        
        sender.setTranslation(CGPointZero, inView: sender.view)
      
        // 2.将滑块移动到拖拽的位置
        // 累加平移的位置
        self.slider.frame.origin.x += point.x;
        // 矫正移动的位置
        let sliderMaxX: CGFloat = self.view.frame.size.width - self.slider.frame.size.width;
        NSLog("%f %f", sliderMaxX, self.slider.frame.origin.x);
        
        if (self.slider.frame.origin.x < 0) {
            self.slider.frame.origin.x = 0;
        } else if (self.slider.frame.origin.x > sliderMaxX) {
            self.slider.frame.origin.x = sliderMaxX;
        }
        
        
        // 3.设置蓝色进度条的宽度
        self.progressView.frame.size.width = self.slider.center.x;
        
        // 计算当前拖拽到得指定位置
        ///#warning 这个地方计算错误, 和上面计算比例的总长度不一致导致问题
        //    double progress = self.slider.x / self.view.width;
        let progress:Double = Double(self.slider.frame.origin.x / sliderMaxX)
        NSLog("%f", progress);
        let time: NSTimeInterval  = progress * self.player.duration;
        
        // 4.设置拖拽时滑块的标题

        self.slider.setTitle(self.strWithTimeInterval(time), forState: UIControlState.Normal)

        // 5.设置显示进度的方块的内容
        self.currentTimeView.setTitle(self.strWithTimeInterval(time), forState: UIControlState.Normal)
        
        // 6.设置显示进度的方块的frame
        self.currentTimeView.frame.origin.x = self.slider.frame.origin.x;
        self.currentTimeView.frame.origin.y = (self.currentTimeView.superview?.frame.size.height)! - self.currentTimeView.frame.size.height - 10;
        
        // 3.判断当前收拾的状态
        // 如果是开始拖拽就停止定时器, 如果结束拖拽就开启定时器
        if (sender.state == UIGestureRecognizerState.Began) {
            
            // 显示进度的方块
            self.currentTimeView.hidden = false
            
            // 开始拖拽
            NSLog("开始拖拽, 停止定时器");
            self.removeProgressTimer()
            
        }else if (sender.state == UIGestureRecognizerState.Ended)
        {
            // 隐藏显示进度的方块
            self.currentTimeView.hidden = true
            
            self.player.currentTime  = time;
            
            // 结束拖拽
            if (self.player.playing) {
                NSLog("结束拖拽, 开启定时器");
                self.addProgressTimer()
            }
        }
        
    }
 
    
    
    
    //MARK: - 显示时间小方块
    
    @IBOutlet weak var currentTimeView: UIButton!


    //MARK: - 退出
    @IBAction func exitBtnClick(sender: AnyObject) {
        
        // 停止定时器
        
        self.removeProgressTimer()
        
        // 1. 拿到Window
        
        let window: UIWindow  = UIApplication.sharedApplication().keyWindow!;
        // 禁用交互功能
        window.userInteractionEnabled = true
        
        // 2.执行退出动画
        
        UIView.animateWithDuration(1, animations: { () -> Void in
            // 执行动画
            self.view.frame.origin.y = window.bounds.size.height;
            }) { (finished) -> Void in
                
                // 隐藏控制器的view
                self.view.hidden = true
                
                // 开启交互
                window.userInteractionEnabled = true
        }
  
    }
    
    

    
    
    //MARK: - 歌曲大图
    
    @IBOutlet  var iconView: UIImageView!
      
    //MARK: - 歌曲名称
    
    @IBOutlet weak var songLabel: UILabel!
   
    
    //MARK: - 歌手名称
    
    
    @IBOutlet weak var singerLabel: UILabel!
    
    

    
    
    //MARK: - 上一首
    
    @IBAction func previous() {
        
        // 1.重置数据
        self.resetplayingMusics()
        // 2.设置当前播放的音乐
        
        //[HMMusicsTool setPlayingMusic:[HMMusicsTool previouesMusic]];
        //HMMusicsTool.setPlayingMusic(HMAudioTool.previouesMusic())
    
        HMMusicsTool.setPlayingMusic(HMMusicsTool.previouesMusic())

      
        // 3.开始播放
        self.startplayingMusics()
        
    }

    
    //MARK: - 下一首
    
    @IBAction func next() {
        
        // 1.重置数据
        self.resetplayingMusics()
        // 2.设置当前播放的音乐
        HMMusicsTool.setPlayingMusic(HMMusicsTool.previouesMusic())
        //HMMusicsTool.playingMusics = HMMusicsTool.nextMusic()
        // 3.开始播放
        self.startplayingMusics()
        
    }

    
    //MARK: - 播放暂停
    
    @IBAction func playOrPause() {
        
        // 判断按钮当前的状态
        if (self.playOrPauseButton.selected){
            // 选中, 显示的暂停-->显示播放
            self.playOrPauseButton.selected = false
            // 调用工具类方法暂停
            ///*****✅一个问号就不暂停了self.playingMusic?
            HMAudioTool.pauseMusicWithFilename(self.playingMusic?.filename)
            
        }else{
            // 未选中, 显示播放-->显示的暂停
            self.playOrPauseButton.selected = true
            
            //         调用工具类方法播放
            // 调用工具类方法暂停
            //HMAudioTool.playMusicWithFilename(self.playingMusic?.filename)
           
            // 开启定时器更新进度
            //self.addProgressTimer()
            
            // 3.开始播放
            self.startplayingMusics()
        }
        
    }

    
    //MARK: - 播放暂停按钮
    
    @IBOutlet weak var playOrPauseButton: UIButton!
    
    
    

    
    

    override func viewDidLoad() {
        super.viewDidLoad()

          self.currentTimeView.layer.cornerRadius = 8;
    }

    ///#pragma mark - 全局内部方法
    func show(){
        
        // 0.判断是否切换歌曲
        if (self.playingMusic != HMMusicsTool.playingMusicing()){

        // 重置数据
        self.resetplayingMusics()
            
        }
        
        // 1. 拿到Window
        let window: UIWindow  = UIApplication.sharedApplication().keyWindow!;
        // 2. 设置当前控制器的frame
        self.view.frame = window.bounds;
        // 3. 将当前控制器的view添加到Window上
        window.addSubview(self.view)
        self.view.hidden = false
        
        // 禁用交互功能
        window.userInteractionEnabled = true
        
        // 4.执行动画, 让控制器的view从下面转出来
        self.view.frame.origin.y = window.bounds.size.height;
        UIView.animateWithDuration(1, animations: { () -> Void in
            // 执行动画
            self.view.frame.origin.y = 0
            }) { (finished) -> Void in
                // 开启交互
                window.userInteractionEnabled = true
                
                // 开始播放
                self.startplayingMusics()
        }

    }
    
    
    
    
    
    
    //MARK: -  重置数据
    func resetplayingMusics() {
        
        // 停止定时器
        self.removeProgressTimer()
        // 背景大图
        self.iconView?.image = UIImage(named: "play_cover_pic_bg")
        // 设置歌手
       // print("*****\(singerLabel.text)")
        self.singerLabel?.text = nil
      
        // 歌曲名称
        self.songLabel?.text = nil

        
//        // 停止当前正在播放的歌曲
//        //停止播放
//        print("*****\(self.playingMusic?.filename)")
//        
        if self.playingMusic?.filename == nil {
            
            return
        }
        print("*@@@@@@@@@@@@@@@@@\(self.playingMusic?.filename)")
        HMAudioTool.stopMusicWithFilename(self.playingMusic?.filename)

  
    }
    
    // 开始播放
    func startplayingMusics(){

        // 停止定时器
        self.removeProgressTimer()
        // 执行动画完毕, 开始播放音乐
        // 1.取出当前正在播放的音乐模型    
        let music = HMMusicsTool.playingMusicing()
        
        print("1.取出当前正在播放的音乐模型*****\(music.filename)")
        // 2.播放音乐
        self.player = HMAudioTool.playMusicWithFilename(music.filename)
        self.player.delegate = self
        
        self.playOrPauseButton.selected = true
        
        if self.playingMusic == HMMusicsTool.playingMusicing() {
            NSLog("仅开启定时器");
            // 4.开始获取进度
            self.addProgressTimer()
            return
        }
        
        // 记录当前正在播放的音乐
        self.playingMusic = HMMusicsTool.playingMusicing()
        
        // 3.设置其他属性
        // 设置歌手
        self.singerLabel.text = music.singer;
        // 歌曲名称
        self.songLabel.text = music.name;
        // 背景大图
        print("背景大图*****\(music.icon)")
        self.iconView.image = UIImage(named: music.icon)
        // 设置总时长
        self.durationLabel!.text = self.strWithTimeInterval(self.player.duration)
        
        // 4.开始获取进度
        self.addProgressTimer()
    }
    
    
    //MARK: -  将秒转换为指定格式的字符串
    func strWithTimeInterval(interval:NSTimeInterval)->String?{
        
        let m: Int  = Int(interval) / 60;
        let s: Int = Int(interval) % 60;
        return NSString(format: "%02d: %02d",  m , s) as String
    }
    
    
    /**
    *  更新进度
    */
    func updateCurrentProgress(){
        //    NSLog(@"%s", __func__);
        
        // 1.计算进度
        let progress:Double  = self.player.currentTime / self.player.duration;
        
        // 2.获取滑块移动的最大距离
        let sliderMaxX:Double = Double(self.view.frame.size.width - self.slider.frame.size.width)
        
        // 3.设置滑块移动的位置
        self.slider.frame.origin.x = CGFloat(sliderMaxX * progress)
        
        // 4.设置蓝色进度条的宽度
        self.progressView.frame.size.width = self.slider.center.x;
        
        // 5.设置滑块的标题
        self.slider.setTitle(self.strWithTimeInterval(self.player.currentTime), forState: UIControlState.Normal)
    
    }



    
    
    
    
    
    
    ///#pragma mark - AVAudioPlayerDelegate
    // 播放结束时调用
    func audioPlayerDidFinishPlaying(player: AVAudioPlayer, successfully flag: Bool) {
        // 下一曲
        self.next()
    }

    
    // 播放器被打断时调用(例如电话)
    func audioPlayerBeginInterruption(player: AVAudioPlayer) {
        // 暂停
        if (self.player.playing) {
            
            HMAudioTool.pauseMusicWithFilename(self.playingMusic!.filename)
        }
    }

    
    // 播放器打断结束
    func audioPlayerEndInterruption(player: AVAudioPlayer) {
        // 继续播放
        if (!self.player.playing) {
            self.startplayingMusics()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    



}
