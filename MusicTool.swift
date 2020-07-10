//
//  MusicTool.swift
//  LuckyChoice
//
//  Created by WinterOS on 2020/7/9.
//  Copyright © 2020 WinterOS. All rights reserved.
//

import UIKit
import SpriteKit
import AVFoundation

class MusicTool: NSObject {
    private static var _sharedInstance: MusicTool?
  var musicPlayer =  AVAudioPlayer()
   private let hitAct = SKAction.playSoundFileNamed("bgMusic.wav", waitForCompletion: true)
    func playBackGround()  {
        guard let bgMusicURL = Bundle.main.url(forResource: "bgMusic.wav", withExtension: "") else {
            return
        }
        try! musicPlayer = AVAudioPlayer(contentsOf: bgMusicURL)
        musicPlayer.numberOfLoops = -1
        musicPlayer.prepareToPlay()
        musicPlayer.play()
    }
    func playResult()  {
        guard let bgMusicURL = Bundle.main.url(forResource: "result.wav", withExtension: "") else {
            return
        }
        try! musicPlayer = AVAudioPlayer(contentsOf: bgMusicURL)
        musicPlayer.numberOfLoops = 0
        musicPlayer.play()
    }
    func stopMusic() {
        if musicPlayer.isPlaying {
            musicPlayer.stop()
        }
    }
    class func makeMusicTool() -> MusicTool {
        guard let instance = _sharedInstance else {
            _sharedInstance = MusicTool()
            return _sharedInstance ?? MusicTool()
        }
        return instance
    }
    private override init(){}
    class func destroy() {
        _sharedInstance = nil
    }
}
