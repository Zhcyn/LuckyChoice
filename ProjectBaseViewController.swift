//
//  ProjectBaseViewController.swift
//  LuckyChoice
//
//  Created by WinterOS on 2020/7/9.
//  Copyright © 2020 WinterOS. All rights reserved.
//

import UIKit
import SnapKit

class ProjectBaseViewController: UIViewController {
    private let titleL = UILabel.createLabel(title: "", color: .white, font: 44, textAlignment: .center, backColor: .clear, numberOfLines: 1)
    private lazy var bgImgView: UIImageView = {
        let bg = UIImageView.init(frame: view.bounds)
        bg.isUserInteractionEnabled = true
        bg.image = UIImage.init(named: "game_bg")
        return bg
    }()
    lazy var backBtn: UIButton = {
        let backBtn = UIButton.createButton(target: self, selector: #selector(backGame))
        backBtn.setBackgroundImage(UIImage.init(named: "back"), for: .normal)
        return backBtn
    }()
    lazy var rightNavBtn: UIButton = {
        let rightNavBtn = UIButton.createButton(target: self, selector: #selector(clickRightBtn))
        rightNavBtn.isHidden = true
        rightNavBtn.setTitleColor(UIColor.yellow.withAlphaComponent(0.8), for: .normal)
        rightNavBtn.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        return rightNavBtn
    }()
    var isShowBackBtn = true{
        didSet{
            backBtn.isHidden = !isShowBackBtn
        }
    }
    var headline: String =  ""{
        didSet{
            titleL.text = headline
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(bgImgView)
        view.addSubview(titleL)
        titleL.addShadow()
        titleL.font = UIFont.init(name: "ZXFDarkGothic-", size: 36)
        titleL.snp.makeConstraints { (make) in
            make.centerX.equalTo(view.snp.centerX)
            make.height.equalTo(44)
            make.width.equalTo(280)
            make.top.equalTo(statusHeight + 5)
        }
        view.addSubview(backBtn)
        backBtn.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.width.height.equalTo(25)
            make.centerY.equalTo(titleL.snp.centerY)
        }
        view.addSubview(rightNavBtn)
        rightNavBtn.snp.makeConstraints { (make) in
            make.right.equalTo(-15)
            make.width.height.equalTo(25)
            make.centerY.equalTo(titleL.snp.centerY)
        }
    }
    @objc func clickRightBtn(){
    }
    @objc  func backGame(){
        if navigationController?.viewControllers.count ?? 1 > 1 {
            navigationController?.popViewController(animated: true)
            return
        }
        self.dismiss(animated: true, completion: nil)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
}
