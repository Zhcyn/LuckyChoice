//
//  LuckRoulette.swift
//  LuckyChoice
//
//  Created by WinterOS on 2020/7/9.
//  Copyright © 2020 WinterOS. All rights reserved.
//

import UIKit
import AudioToolbox

class LuckRoulette: UIView {
    private var btnAry = [UIButton]()
    private var labelAry = [UILabel]()
    private lazy var bgImageView: UIImageView = {
        let imageView = UIImageView.init(image: UIImage.init(named: "Roulette_bg1"))
        imageView.frame = self.bounds;
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    private var isChnage = true
    private var changeTimer : Timer!
    private var selectBtn: UIButton!
    private  var dataAry: [String] {
        get{
            let ary = NSMutableArray.init(array: CurrentGameAry)
            if CurrentGameAry.count > 8{
                return ary.subarray(with: NSRange.init(location: 0, length: 8)) as! [String]
            }else{
                for index in 0..<8{
                    let count = index % ary.count
                    guard ary.count < 8, count < ary.count else{
                        return ary as! [String]
                    }
                    ary.add(ary[count])
                }
                return ary as! [String]
            }
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(bgImageView)
        updataViewData()
        changeTimer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(changeBgImage), userInfo: nil, repeats: true)
    }
    func updataViewData(){
        for view in bgImageView.subviews {
            view.removeFromSuperview()
        }
        btnAry.removeAll()
        labelAry.removeAll()
        let margin: CGFloat = 15.0
        let count: CGFloat = 3
        let imageW:CGFloat = 35
        let wh: CGFloat = (self.bounds.size.width - margin * 2 - imageW * 2) / count
        for i in 0..<9 {
            var index: CGFloat = CGFloat(i)
            let offsetx = imageW + (wh + margin) * (index.truncatingRemainder(dividingBy: count))
            let offsety = 30 + (wh + margin) * CGFloat(i / 3)
            let btn = UIButton.init(frame: CGRect.init(x: offsetx, y: offsety, width: wh, height: wh))
            btn.setBackgroundImage(UIImage.init(named: "Roulette_btn_bg"), for: .normal)
            bgImageView.addSubview(btn)
            if index == 4 {
                btn.addTarget(self, action: #selector(clickBtn), for: UIControl.Event.touchUpInside)
                btn.setBackgroundImage(UIImage.init(named: "Roulette_start"), for: .normal)
                selectBtn = btn
                continue
            }
            index = index > 4 ? index - 1 : index
            let label = UILabel.createLabel(title: "\(dataAry[Int(index)])", color: UIColor.init(r: 147, g: 78, b: 40, a: 1), font: 16, textAlignment: .center,backColor: .clear,numberOfLines: 0)
            btn.addSubview(label)
            label.snp.makeConstraints { (make) in
                make.top.left.equalTo(1)
                make.bottom.right.equalTo(-1)
            }
            label.adjustsFontSizeToFitWidth = true
            btnAry.append(btn)
            labelAry.append(label)
        }
        btnAry[3].exchanggeFrame(toView: btnAry[4])
        btnAry[4].exchanggeFrame(toView: btnAry[7])
        btnAry[5].exchanggeFrame(toView: btnAry[6])
        labelAry[3].exchanggeFrame(toView: labelAry[4])
        labelAry[4].exchanggeFrame(toView: labelAry[7])
        labelAry[5].exchanggeFrame(toView: labelAry[6])
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    var currentCount = 0
    var stopCount:Int {
        get{
            return Int(arc4random()%40 + 30)
        }
    }
    var time = 0.05
    var timer: Timer!
    @objc private func clickBtn(){
        time = 0.06
        currentCount = 0
        selectBtn.isEnabled = false
        timer = Timer.scheduledTimer(timeInterval: time, target: self, selector: #selector(runloopBtn), userInfo: nil, repeats: true)
        for btn in btnAry {
            btn.setBackgroundImage(UIImage.init(named: "Roulette_btn_bg"), for: .normal)
        }
        for label in labelAry {
            label.textColor = UIColor.init(r: 147, g: 78, b: 40, a: 1)
        }
    }
    @objc private func runloopBtn(){
        AppConfig.addFeedBackGenerator()
        let oldBtn = btnAry[currentCount % btnAry.count]
        oldBtn.layer.borderColor = UIColor.clear.cgColor
        oldBtn.setBackgroundImage(UIImage.init(named: "Roulette_btn_bg"), for: .normal)
        currentCount += 1
        let newBtn = btnAry[currentCount % btnAry.count]
        let newLabel = labelAry[currentCount % btnAry.count]
        newBtn.setBackgroundImage(UIImage.init(named: "Roulette_select_btn"), for: .normal)
        if currentCount > stopCount {
            timer.invalidate()
            timer = nil
            addAnimation(view: newBtn)
            UIView.animate(withDuration: 0.3) {
                self.selectBtn.isEnabled = true
                newLabel.textColor = .white
            }
            return
        }
        if currentCount > stopCount - 12 {
            time += 0.05
            timer.invalidate()
            timer = nil
            timer = Timer.scheduledTimer(timeInterval: time, target: self, selector: #selector(runloopBtn), userInfo: nil, repeats: true)
        }
    }
    @objc private func joinSourceView(){
        let feed =  UIImpactFeedbackGenerator.init(style: UIImpactFeedbackGenerator.FeedbackStyle.light)
        feed.impactOccurred()
    }
    private func addAnimation(view: UIView) {
        let animation = CAKeyframeAnimation.init(keyPath: "transform")
        animation.isCumulative = false
        animation.repeatCount = 1
        animation.duration = 2
        animation.values = [CATransform3DMakeRotation(0, 0, 1, 0),
                            CATransform3DMakeRotation(CGFloat(Float.pi/2), 0, 1, 0),
                            CATransform3DMakeRotation(0, 0, 1, 0),]
        view.layer.add(animation, forKey: "11")
    }
    @objc private func changeBgImage(){
        isChnage = !isChnage
        bgImageView.image = isChnage ? UIImage.init(named: "Roulette_bg1") : UIImage.init(named: "Roulette_bg2")
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
