//
//  HMPlayingViewController.swift
//  4.2baiduMusic
//
//  Created by 蒋进 on 15/11/25.
//  Copyright © 2015年 sijichcai. All rights reserved.
//

import UIKit
import AVFoundation
import Masonry

class HMPlayingViewController: UIViewController,AVAudioPlayerDelegate {
    
    
    /// 播放暂停按钮
    @IBOutlet weak var playOrPauseButton: UIButton!
    @IBOutlet weak var iconView: UIImageView!
    /// 歌曲大图
    @IBOutlet  var albumView: UIImageView!
    /// 歌曲名称
    @IBOutlet weak var songLabel: UILabel!
    /// 歌手名称
    @IBOutlet weak var singerLabel: UILabel!
    /// 时长
    @IBOutlet weak var durationLabel: UILabel?
    /// 滑块
    @IBOutlet weak var slider: UIButton!
    /// 蓝色播放进度
    @IBOutlet weak var progressView: UIView!
    /// 显示时间小方块
    @IBOutlet weak var currentTimeView: UIButton!
    // 歌词的View
    @IBOutlet weak var lrcView: XMGLrcView!
    
    // 歌词的Label
    @IBOutlet weak var lrcLabel: UILabel!

    
    //MARK:  获取进度定时器
    var progressTimer:NSTimer?
    //MARK:  当前正在播放的音乐
    var playingMusic:HMMusic?
    //MARK:  当前播放器
    var player:AVAudioPlayer!
    
    
    //MARK:  监听进度条的点击
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
    //MARK:  监听滑块拖拽事件
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
    
    //MARK:  移除定时器
    func removeProgressTimer(){
        
        self.progressTimer?.invalidate()
        self.progressTimer = nil;
    }
    //MARK: 开启定时器
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
    
    //MARK:  退出
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
    
    
    //MARK:  上一首
    @IBAction func previous() {
        
        // 1.取出上一首歌曲
        let previousMusic:HMMusic = HMMusicsTool.previouesMusic()
        // 2.播放上一首歌曲
        playingMusicWithMusic(previousMusic)
        
        /*
        // 1.重置数据
        self.resetplayingMusics()
        // 2.设置当前播放的音乐
        //HMMusicsTool.setPlayingMusic(HMMusicsTool.previouesMusic())
        // HMMusicsTool.playingMusics = HMMusicsTool.previouesMusic()
        
        let previousMusic:HMMusic = HMMusicsTool.previouesMusic()
        
        // 3.开始播放
        self.startplayingMusics()
        */
        
        
    }
    
    
    //MARK:  下一首
    @IBAction func next() {
        
        // 1.取出下一首歌曲
        let nextMusic:HMMusic = HMMusicsTool.nextMusic()
        // 2.播放下一首歌曲
        playingMusicWithMusic(nextMusic)
        
        /*
        // 1.重置数据
        self.resetplayingMusics()
        // 2.设置当前播放的音乐
        //HMMusicsTool.setPlayingMusic(HMMusicsTool.previouesMusic())
        HMMusicsTool.playingMusics = HMMusicsTool.nextMusic()
        // 3.开始播放
        self.startplayingMusics()
        */
        
        
        
    }
    func playingMusicWithMusic(music:HMMusic){
        
        // 1.停止当前歌曲
        //let playingMusic:HMMusic = HMMusicsTool.playingMusicing()
        
        //HMAudioTool.stopMusicWithFilename(playingMusic.filename)
        
        HMAudioTool.stopMusicWithFilename(playingMusic?.filename)
        self.removeProgressTimer()
        // 3.播放歌曲
        HMAudioTool.playMusicWithFilename(music.filename)
        
        // 4.将工具类中的当前歌曲切换成播放的歌曲
        HMMusicsTool.setPlayingMusic(music)
        
        // 5.改变界面信息
        startplayingMusics()
        
    }
    
    @IBAction func playOrPause() {
        
        // 判断按钮当前的状态
        if (self.playOrPauseButton.selected){
            // 选中, 显示的暂停-->显示播放
            self.playOrPauseButton.selected = false
            // 调用工具类方法暂停
            ///*****✅一个问号就不暂停了self.playingMusic?
            HMAudioTool.pauseMusicWithFilename(self.playingMusic?.filename)
            self.iconView.layer.pauseAnimation()
            
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
            self.iconView.layer.resumeAnimation()
        }
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 1.添加毛玻璃效果和歌词的View
        setupBlurGlass()
        self.currentTimeView.layer.cornerRadius = 8;
        startAnimation()
        
        // 4.设置lrcView的ContentSize
        self.lrcView.contentSize = CGSizeMake(self.view.bounds.size.width * 2, 0);
        
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // 3.设置图片圆角
        self.iconView.layer.cornerRadius = self.iconView.frame.size.width * 0.5;
        self.iconView.layer.borderWidth = 5;
        self.iconView.layer.borderColor = UIColor.RGB(36, 36, 36).CGColor;
        self.iconView.layer.masksToBounds = true
        
    }
    
    
    // MARK: - 动画--360度旋转
    ///  开始圈圈动画
    private func startAnimation(){
        // 1.创建动画
        let anim = CABasicAnimation(keyPath: "transform.rotation")
        // 2.设置动画属性
        anim.toValue = 2 * M_PI
        anim.duration = 20
        anim.repeatCount = MAXFLOAT
        
        // 该属性默认为YES, 代表动画只要执行完毕就移除
        anim.removedOnCompletion = false
        // 3.将动画添加到图层上
        iconView.layer.addAnimation(anim, forKey: nil)
    }
    
    // 添加毛玻璃效果
    func setupBlurGlass(){
        // 添加毛玻璃效果
        let toolBar:UIToolbar = UIToolbar()
        toolBar.barStyle = UIBarStyle.Black;
        self.albumView.addSubview(toolBar)
        
        toolBar.translatesAutoresizingMaskIntoConstraints = false
        // Masonry
        toolBar.mas_makeConstraints { (make) -> Void in
            //make.top.equalTo()(self.albumView)
            make.edges.equalTo()(self.albumView)
            
        }
        // VFL
        /*
        toolBar.translatesAutoresizingMaskIntoConstraints = false
        let VVFL:String = "V:|-0-[toolBar]-0-|";
        let HVFL:String = "H:|-0-[toolBar]-0-|";
        let views:NSDictionary = ["toolBar":toolBar]
        var cons = [NSLayoutConstraint]()
        // 水平方向的约束
        cons += NSLayoutConstraint.constraintsWithVisualFormat(HVFL, options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views as! [String : AnyObject])
        // 垂直方向的约束
        cons += NSLayoutConstraint.constraintsWithVisualFormat(VVFL, options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views as! [String : AnyObject])
        self.albumView.addConstraints(cons)
        */
        
        
    }
    
    
    
    ///#pragma mark - 全局内部方法
    func show(){
        
        // 重置数据
        self.resetplayingMusics()
        
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
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            // 执行动画
            self.view.frame.origin.y = 0
            }) { (finished) -> Void in
                // 开启交互
                window.userInteractionEnabled = true
                
                
        }
        // 开始播放
        self.startplayingMusics()
        
    }
    
    
    
    
    
    
    //MARK: -  重置数据
    func resetplayingMusics() {
        
        // 0.判断是否切换歌曲
        if (self.playingMusic != HMMusicsTool.playingMusicing()){
            
            // 停止定时器
            self.removeProgressTimer()
            // 背景大图
            self.albumView?.image = UIImage(named: "play_cover_pic_bg")
            self.iconView?.image = UIImage(named: "play_cover_pic_bg")
            // 设置歌手
            self.singerLabel?.text = nil
            // 歌曲名称
            self.songLabel?.text = nil
            self.removeProgressTimer()
            HMAudioTool.stopMusicWithFilename(playingMusic?.filename)
        }
        
        
    }
    
    
    // 开始播放
    func startplayingMusics(){
        
        resetplayingMusics()
        
        // 停止定时器
        self.removeProgressTimer()
        // 执行动画完毕, 开始播放音乐
        // 1.取出当前正在播放的音乐模型
        let music = HMMusicsTool.playingMusicing()
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
        self.albumView.image = UIImage(named: music.icon)
        self.iconView.image = UIImage(named: music.icon)
        // 设置总时长
        self.durationLabel!.text = self.strWithTimeInterval(self.player.duration)
        
        // 4.开始获取进度
        self.addProgressTimer()
    }
    
    
    //MARK: -  将秒转换为指定格式的字符串MM:ss
    func strWithTimeInterval(interval:NSTimeInterval)->String?{
        
        let m: Int  = Int(interval) / 60;
        let s: Int = Int(interval) % 60;
        return NSString(format: "%02d: %02d",  m , s) as String
    }
    
    
    //MARK:  更新进度
    ///  更新进度
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
    
    
    
    
    
    
    
    
    
    //MARK: - AVAudioPlayerDelegate
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
    
    
    
}
//MARK: - 实现UIScrollView的代理方法
extension HMPlayingViewController :UIScrollViewDelegate{
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        // 1.获取到滑动多少
        let point:CGPoint = scrollView.contentOffset
        // 2.计算滑动的比例
        let ratio:CGFloat = 1 - point.x / scrollView.bounds.size.width;

        // 3.设置iconView和歌词的Label的透明度
        self.iconView.alpha = ratio;
        self.lrcLabel.alpha = ratio;
    }


    
}
