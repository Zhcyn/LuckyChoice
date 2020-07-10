//
//  AppConfig.swift
//  LuckyChoice
//
//  Created by WinterOS on 2020/7/9.
//  Copyright © 2020 WinterOS. All rights reserved.
//

import UIKit

let AppColor = UIColor.init(hexString: "#FFA500")
let ThemeColor = UIColor.init(hexString: "#6495ED")
let ThemeText = "Topic Name"
let TabText = "Editing options"
var ThemeName = ""
let GameModeNotificationName = "GameModeNotificationName"
let ThemeModeNotificationName = "ThemeModeNotificationName"
var CurrentGameModel: GameMode = .Lottery{
    didSet{
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: GameModeNotificationName), object: CurrentGameModel)
    }
}
var CurrentGameAry = [String](){
    didSet{
        if AppConfig.makeAppConfig().isOpenRandom {
            let ary = NSMutableArray(capacity: CurrentGameAry.count)
            let ary1 = NSMutableArray.init(array: CurrentGameAry)
            while(ary1.count > 0){
                let count = ary1.count
                let s = ary1.object(at: Int(arc4random())%count)
                ary.add(s)
                ary1.remove(s)
            }
            CurrentGameAry = ary as! [String]
        }
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: ThemeModeNotificationName), object: CurrentGameAry)
    }
}
let docPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString
let jsonPath = docPath.appendingPathComponent("data.json")
let openTouch = "openTouch"
let openRandom = "openRandom"
let openMusic = "openMusic"
let buyVIP = "buyVIP"
class AppConfig{
    var isOpenTouch = UserDefaults.standard.bool(forKey: openTouch)
    var isOpenRandom = UserDefaults.standard.bool(forKey: openRandom){
        didSet{
            if isOpenRandom {
                let ary = NSMutableArray(capacity: CurrentGameAry.count)
                let ary1 = NSMutableArray.init(array: CurrentGameAry)
                while(ary1.count > 0){
                    let count = ary1.count
                    let s = ary1.object(at: Int(arc4random())%count)
                    ary.add(s)
                    ary1.remove(s)
                }
                CurrentGameAry = ary as! [String]
            }
        }
    }
    var isOpenMusic = UserDefaults.standard.bool(forKey: openMusic){
        didSet{
            if isOpenMusic {
                MusicTool.makeMusicTool().playBackGround()
            }else{
                MusicTool.makeMusicTool().stopMusic()
            }
        }
    }
    var isVIP = UserDefaults.standard.bool(forKey: buyVIP)
    var isTemporaryVip = false
    class func saveValue(value:Bool, key: String){
        UserDefaults.standard.set(value, forKey: key)
    }
    class func addFeedBackGenerator(){
        if AppConfig.makeAppConfig().isOpenTouch == false {
            return
        }
        let feed =  UIImpactFeedbackGenerator.init(style: UIImpactFeedbackGenerator.FeedbackStyle.light)
        feed.impactOccurred()
    }
    class func writeToData(dict: NSMutableDictionary){
        dict.write(toFile: jsonPath, atomically: true)
    }
    class func readJsonData() -> NSMutableDictionary{
        return NSMutableDictionary.init(contentsOfFile: jsonPath) ?? NSMutableDictionary.init()
    }
    private static var _sharedInstance: AppConfig?
    class func makeAppConfig() -> AppConfig {
        guard let instance = _sharedInstance else {
            _sharedInstance = AppConfig()
            return _sharedInstance ?? AppConfig()
        }
        return instance
    }
    private init(){}
    class func destroy() {
        _sharedInstance = nil
    }
}
