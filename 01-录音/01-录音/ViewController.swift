//
//  ViewController.swift
//  01-录音
//
//  Created by 蒋进 on 16/3/6.
//  Copyright © 2016年 蒋进. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    var recorder:AVAudioRecorder? //录音器
    var player:AVAudioPlayer? //播放器
    var recorderSeetingsDic:[String : AnyObject]? //录音器设置参数数组
    var volumeTimer:NSTimer! //定时器线程，循环监测录音的音量大小
    var aacPath:String? //录音存储路径
    
    @IBOutlet weak var vidoName: UITextField!
    @IBOutlet weak var volumLab: UILabel! //显示录音音量
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //初始化录音器
        let session:AVAudioSession = AVAudioSession.sharedInstance()
        
        //设置录音类型
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord)
        //设置支持后台
        try! session.setActive(true)

        //组合录音文件路径
        //aacPath = docDir + "/play.aac"
        //初始化字典并添加设置参数
        recorderSeetingsDic =
            [
                AVFormatIDKey: NSNumber(unsignedInt: kAudioFormatMPEG4AAC),
                AVNumberOfChannelsKey: 2, //录音的声道数，立体声为双声道
                AVEncoderAudioQualityKey : AVAudioQuality.Max.rawValue,
                AVEncoderBitRateKey : 320000,
                AVSampleRateKey : 44100.0 //录音器每秒采集的录音样本数
        ]
    }
    lazy var docDir:String = {
        
         //获取Document目录
        let ani = NSSearchPathForDirectoriesInDomains(.DocumentDirectory,.UserDomainMask, true)[0]
        print("\(ani)")
        return ani
    }()
    
    // 获得用户名字
    func setupNamepath(text:String?)->String{
        print("text\(text)")
        if text == nil{
            
            return docDir+NSDate().toString(nil)
        }
        let name:String = NSDate().toString(nil)
       
        print("\(docDir + "/" + text! + name + ".aac")")
        return docDir + "/" + text! + name + ".aac"
    }
    
    //按下录音
    @IBAction func downAction(sender: AnyObject) {
        //初始化录音器
        recorder = try! AVAudioRecorder(URL: NSURL(string: setupNamepath(vidoName.text!))!,
            settings: recorderSeetingsDic!)
        print("setupNamepath(vidoName.text)==\(setupNamepath(vidoName.text))")
        if recorder != nil {
            //开启仪表计数功能
            recorder!.meteringEnabled = true
            //准备录音
            recorder!.prepareToRecord()
            //开始录音
            recorder!.record()
            //启动定时器，定时更新录音音量
            volumeTimer = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self,
                selector: "levelTimer", userInfo: nil, repeats: true)
        }
        
    }
  
    var isstop: Bool = false
    //松开按钮，结束录音
    @IBAction func upAction(sender: AnyObject) {
        if isstop == true{
            
            return
        }
        //停止录音
        recorder?.stop()
        //录音器释放
        recorder = nil
        //暂停定时器
        volumeTimer.invalidate()
        volumeTimer = nil
        volumLab.text = "录音音量:0"
        isstop = true
    }
    
    //播放录制的声音
    @IBAction func playAction(sender: AnyObject) {
        //播放
        player = try? AVAudioPlayer(contentsOfURL: NSURL(string: setupNamepath(vidoName.text!))!)
        if player == nil {
            print("播放失败")
        }else{
            player?.play()
        }
    }
    
    //定时检测录音音量
    func levelTimer(){
        recorder!.updateMeters() // 刷新音量数据
        let averageV:Float = recorder!.averagePowerForChannel(0) //获取音量的平均值
        let maxV:Float = recorder!.peakPowerForChannel(0) //获取音量最大值
        let lowPassResult:Double = pow(Double(averageV), Double(0.05*maxV))
        //let lowPassResult:Double = pow(Double(10), Double(0.05*maxV))
        volumLab.text = "录音音量:\(lowPassResult)"
    }
    
    
    
    
    
    @IBAction func playSound(sender: AnyObject) {
        
        XMGAudioTool.playSoundWithSoundname("m_03.wav")
    }
    
    
    
}






extension NSDate{
    
    //MARK:  返回一个只有年月日的时间
    ///  返回一个只有年月日的时间
    func dateWithYMD() -> NSDate {
        let fmt = NSDateFormatter()
        fmt.dateFormat = "yyyy-MM-dd"
        let selfStr = fmt.stringFromDate(self)
        return fmt.dateFromString(selfStr)!
    }
    
    public func toString(format:String?) -> String{
        let f = format != nil ? format : "-MM.dd.yyyy"
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = f
        return dateFormatter.stringFromDate(self)
    }
}




