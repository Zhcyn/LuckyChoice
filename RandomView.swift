//
//  RandomView.swift
//  LuckyChoice
//
//  Created by WinterOS on 2020/7/9.
//  Copyright © 2020 WinterOS. All rights reserved.
//

import UIKit

class RandomView: UIView {
    private lazy var label: UILabel = {
       let l = UILabel.createLabel(title: "", color: .red, font: 22, textAlignment: .center, backColor: .clear, numberOfLines: 0)
        l.adjustsFontSizeToFitWidth = true
        return l
    }()
    private let btn = UIButton.createButton("Start", .red, 35,target: self, selector: #selector(statRandom), controlEvents: UIControl.Event.touchUpInside)
    private var timer: Timer!
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    func updataRandomView(){
        for view in subviews {
            view.removeFromSuperview()
        }
        let imageView = UIImageView.init(image: UIImage.init(named: "scratch_content"))
        addSubview(imageView)
        imageView.snp.makeConstraints { (make) in
            make.width.equalTo(160)
            make.height.equalTo(44)
            make.centerX.equalTo(self.snp.centerX)
            make.top.equalTo(30)
        }
        imageView.addSubview(label)
        label.snp.makeConstraints { (make) in
            make.edges.equalTo(imageView)
        }
        addSubview(btn)
        btn.addShadow()
        btn.cuttingView(radius: 60, borWidth: 3, borColor: UIColor.init(hexString: "#EC6E07"))
        btn.backgroundColor = UIColor.init(hexString: "#FED103")
        btn.snp.makeConstraints { (make) in
            make.width.equalTo(120)
            make.height.equalTo(120)
            make.top.equalTo(label.snp.bottom).offset(35)
            make.centerX.equalTo(self.snp.centerX)
        }
        guard CurrentGameAry.count > 0 else { return }
        label.text = CurrentGameAry.first
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    @objc private func statRandom(){
        btn.isEnabled = false
        time = 0.08
        index = 0
        i = 0
        timer = Timer.scheduledTimer(timeInterval: time, target: self, selector: #selector(romdomText), userInfo: nil, repeats: true)
    }
    private var index = 0
    private var time = 0.08
    private var i = 0
    @objc private func romdomText(){
        AppConfig.addFeedBackGenerator()
        if i > endIndex  {
            btn.isEnabled = true
            timer.invalidate()
            return
        }
        if index >= CurrentGameAry.count {
            index = 0
        }
        label.text = CurrentGameAry[index]
        index += 1
        i += 1
        if i > endIndex - 10 {
            time += 0.02
            timer.invalidate()
            timer = Timer.scheduledTimer(timeInterval: time, target: self, selector: #selector(romdomText), userInfo: nil, repeats: true)
        }
    }
    private var endIndex: Int{
        get{
            let count = CurrentGameAry.count
            if count > 0 && count <= 5 {
                return count * 4 + Int(arc4random()%40)
            }else if count > 5 && count <= 10{
                return count * 3 + Int(arc4random()%40)
            }else{
                return count * 2 + Int(arc4random()%40)
            }
        }
    }
    deinit {
        guard let timer = timer else { return}
        timer.invalidate()
    }
    override func removeFromSuperview() {
        super.removeFromSuperview()
        guard let timer = timer else { return}
        timer.invalidate()
    }
}
