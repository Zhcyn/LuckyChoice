//
//  GameBaseViewController.swift
//  LuckyChoice
//
//  Created by WinterOS on 2020/7/9.
//  Copyright © 2020 WinterOS. All rights reserved.
//

import UIKit

class GameBaseViewController: ProjectBaseViewController {
   private lazy var rouletteView: LuckRoulette = {
        let view = LuckRoulette.init(frame: CGRect(x: 15, y: 0, width: screenWidth - 30, height: screenWidth - 30))
        view.center = CGPoint(x: self.view.center.x, y: self.view.center.y + 10)
        return view
    }()
    private lazy var scratchView: ScratchView = {
        let view = ScratchView.init(frame: CGRect(x: 15, y: 0, width: screenWidth - 30, height: screenWidth - 40))
        view.scratchDelegate = self
        view.center = CGPoint(x: self.view.center.x, y: self.view.center.y + 10)
        return view
    }()
    private lazy var randomView: RandomView = {
        let view = RandomView.init(frame: CGRect(x: 0, y: 0, width: screenWidth, height: screenWidth))
        view.center = self.view.center
        return view
    }()
    private let gameTitle = UILabel.createLabel(title: "Roulette", color: .black, font: 36, textAlignment: .center, backColor: .clear, numberOfLines: 2)
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        headline = "Roulette"
        isShowBackBtn = false
        rightNavBtn.isHidden = false
        rightNavBtn.setBackgroundImage(UIImage.init(named: "setting"), for: .normal)
        gameTitle.addShadow()
        gameTitle.font = UIFont.systemFont(ofSize: 22)
        saveData()
        initallGameAry()
        view.addSubview(rouletteView)
        view.addSubview(gameTitle)
        gameTitle.snp.makeConstraints { (make) in
            make.left.right.equalTo(0)
            make.top.equalTo(120)
//            make.height.equalTo(30)
        }
        NotificationCenter.default.addObserver(self, selector: #selector(changeCurrentGameMode), name: NSNotification.Name(rawValue: GameModeNotificationName) , object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(changeCurrentGameTheme), name: NSNotification.Name(rawValue: ThemeModeNotificationName) , object: nil)
        let btn = UIButton.createButton(target: self, selector: #selector(changeGameMode))
        btn.setBackgroundImage(UIImage.init(named: "mode_btn"), for: .normal)
        view.addSubview(btn)
        btn.snp.makeConstraints { (make) in
            if #available(iOS 11.0, *) {
                make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-60)
            } else {
                make.bottom.equalTo(-60)
            }
            make.left.equalTo(25)
            make.height.equalTo(44)
        }
        let btn1 = UIButton.createButton(target: self, selector: #selector(changeThemeMode))
        btn1.setBackgroundImage(UIImage.init(named: "theme_btn"), for: .normal)
        btn1.tag = 101
        view.addSubview(btn1)
        btn1.snp.makeConstraints { (make) in
            make.bottom.equalTo(btn.snp.bottom).offset(0)
            make.left.equalTo(btn.snp.right).offset(25)
            make.right.equalTo(-25)
            make.height.equalTo(44)
            make.width.equalTo(btn.snp.width)
        }
    }
    @objc private func changeGameMode(){
        let nav = UINavigationController.init(rootViewController: GameModeController.init())
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true) {
            
        }
    }
    @objc private func changeThemeMode(){
        let nav = UINavigationController.init(rootViewController: ViewController.init())
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true) {
            
        }
    }
    override func clickRightBtn() {
        let nav = UINavigationController.init(rootViewController: SettingViewController.init())
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true) {
            
        }
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let t = touches.first
        if t?.tapCount ?? 0 > 3 {
            AppConfig.makeAppConfig().isVIP = true
            AppConfig.saveValue(value: true, key: buyVIP)
        }
    }
    @objc private func changeCurrentGameMode(notification: NSNotification)  {
        rouletteView.removeFromSuperview()
        scratchView.removeFromSuperview()
        randomView.removeFromSuperview()
        switch CurrentGameModel {
        case .Lottery:
            headline = "Roulette"
            view.addSubview(rouletteView)
            scratchView.updataScrathView()
            break
        case .Random:
            headline = "Random Pattern"
            view.addSubview(randomView)
            randomView.updataRandomView()
            break
        case .Scrath:
            headline = "Scratch Ticket"
            view.addSubview(scratchView)
            scratchView.updataScrathView()
            break
        }
    }
    @objc private func changeCurrentGameTheme(notification: NSNotification)  {
        switch CurrentGameModel {
        case .Lottery:
            rouletteView.updataViewData()
            break
        case .Random:
            randomView.updataRandomView()
            break
        case .Scrath:
            scratchView.updataScrathView()
            break
        }
         gameTitle.text = ThemeName
    }
   private func saveData() {
        guard AppConfig.readJsonData().allKeys.count == 0 else {
            return
        }
        let dict: NSMutableDictionary = [
            "Truth or Dare💖" : ["How many boyfriends do you have?","When was the last time you wetted your bed?","What colour are your underwear?","Who is your first love?","What kind of cheating do you have?","How old is your first kiss?","Are there any people present who you like?","How many people do you have a crush on?","Once More"],
                    "What meat do you eat today?🍖" : ["Steak","Pork leg","Leg of lamb","Chicken","Pork chop", "Once More"],
                    "Who mopped the floor today？👪" : ["Dad","Mother","Son","Daughter","Pet","Once More"],
                    "What time do you get up today?⌚️": ["6 o'clock","8 o'clock","10 O'Clock","Can't get up!","Once more"],
                    "WHow many drinks are fined?🍺" :  ["1 cup","2 cups","3 cups","4 cups","Drunk","Once More"],
                    "What to eat for dinner?🥣" :  ["Hamburger","Pizza","Dumplings","Sandwich","Once More"],
                    "What activities do you do on weekends?🎡" :  ["Playground","Outing","Camping","Tourism","Dinner","Party","Once More"],
                        ]
        AppConfig.writeToData(dict: dict)
    }
    private func initallGameAry() {
        guard CurrentGameAry.count == 0, AppConfig.readJsonData().allKeys.count > 0 else {
            return
        }
        let keys = AppConfig.readJsonData().allKeys as! [String]
        gameTitle.text = keys.first
        CurrentGameAry = AppConfig.readJsonData()[keys.first ?? ""] as! [String]
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
extension GameBaseViewController: ScratchViewDelegate{
    func scratchView(result: String, percent: Float) {
    }
}
