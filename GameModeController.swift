//
//  GameModeController.swift
//  LuckyChoice
//
//  Created by WinterOS on 2020/7/9.
//  Copyright © 2020 WinterOS. All rights reserved.
//

import UIKit

enum GameMode: String {
    case Lottery = "Roulette"
    case Random = "Random"
    case Scrath = "Scratch"
}
class GameModeController: ProjectBaseViewController {
    let titleL = UILabel.createLabel(title: "GAME MODES", color: .white, font: 44, textAlignment: .center, backColor: .clear, numberOfLines: 1)
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        let height = 65
        let btn1 = UIButton.createButton("", UIColor.black, 20, target: self, selector: #selector(startGame), controlEvents: UIControl.Event.touchUpInside)
        btn1.tag = 102
        btn1.setBackgroundImage(UIImage.init(named: "scratch_mode"), for: .normal)
        view.addSubview(btn1)
        btn1.snp.makeConstraints { (make) in
            make.center.equalTo(view.snp.center)
            make.left.equalTo(25)
            make.right.equalTo(-25)
            make.height.equalTo(height)
        }
        let btn = UIButton.createButton("", UIColor.black, 20, target: self, selector: #selector(startGame), controlEvents: UIControl.Event.touchUpInside)
        btn.setBackgroundImage(UIImage.init(named: "Roulette_mode"), for: .normal)
        btn.tag = 101
        view.addSubview(btn)
        btn.snp.makeConstraints { (make) in
            make.bottom.equalTo(btn1.snp.top).offset(-30)
            make.left.equalTo(25)
            make.right.equalTo(-25)
            make.height.equalTo(height)
            make.centerX.equalTo(view.snp.centerX)
        }
        let btn2 = UIButton.createButton("", UIColor.black, 20, target: self, selector: #selector(startGame), controlEvents: UIControl.Event.touchUpInside)
        btn2.tag = 103
        btn2.setBackgroundImage(UIImage.init(named: "Random_mode"), for: .normal)
        btn2.imageView?.contentMode = .scaleAspectFit
        view.addSubview(btn2)
        btn2.snp.makeConstraints { (make) in
            make.top.equalTo(btn1.snp.bottom).offset(30)
            make.left.equalTo(25)
            make.right.equalTo(-25)
            make.height.equalTo(height)
            make.centerX.equalTo(view.snp.centerX)
        }
    }
    @objc private func startGame(btn: UIButton){
        switch btn.tag {
        case 101:
            CurrentGameModel = GameMode.Lottery
            break
        case 102:
            CurrentGameModel = GameMode.Scrath
            break
        case 103:
            CurrentGameModel = GameMode.Random
            break
        default:
            break
        }
        backGame()
    }
}
