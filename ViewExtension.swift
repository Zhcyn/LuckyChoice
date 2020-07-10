//
//  ViewExtension.swift
//  LuckyChoice
//
//  Created by WinterOS on 2020/7/9.
//  Copyright © 2020 WinterOS. All rights reserved.
//

import UIKit

class ViewExtension: NSObject {

}
let screenWidth = UIScreen.main.bounds.size.width
let screenHeight = UIScreen.main.bounds.size.height
let statusHeight = UIApplication.shared.statusBarFrame.size.height
let tabbarHeight: CGFloat = statusHeight >= 24.0 ? 34.0 : 0.0
let navHeigth: CGFloat = statusHeight >= 24.0 ? 88 : 64;
extension UIView{
    func viewH() ->CGFloat {
        return self.frame.size.height
    }
    func viewW() ->CGFloat {
        return self.frame.size.width
    }
    func viewX() ->CGFloat {
        return self.frame.origin.x
    }
    func viewY() ->CGFloat {
        return self.frame.origin.y
    }
    func setViewY(y:CGFloat){
        self.frame = CGRect(x: self.frame.origin.x, y: y, width:self.frame.size.width , height: self.frame.size.height)
    }
    func setViewX(x:CGFloat){
        self.frame = CGRect(x: x, y: self.frame.origin.y, width:self.frame.size.width , height: self.frame.size.height)
    }
    func setViewH(height:CGFloat){
        self.frame = CGRect(x: self.frame.origin.x, y: self.frame.origin.y, width:self.frame.size.width , height: height)
    }
    func setViewW(width:CGFloat){
        self.frame = CGRect(x: self.frame.origin.x, y: self.frame.origin.y, width:width , height: self.frame.size.height)
    }
    func exchanggeFrame(toView: UIView){
        let rect = self.frame
        self.frame = toView.frame
        toView.frame = rect
    }
}
extension UIView{
    class func createButton(_ title: String = "",_ textColor: UIColor = .black,_ fontSize: CGFloat = 12, _ imgName:String = "",_ backImgName:String = "", target: Any, selector: Selector,  controlEvents: UIControl.Event = .touchUpInside) -> UIButton{
        let btn = UIButton.init(type: .custom)
        if !title.isEmpty {
            btn.setTitle(title, for: .normal)
            btn.setTitleColor(textColor, for: .normal)
            btn.titleLabel?.font = UIFont.systemFont(ofSize: fontSize)
        }
        if !imgName.isEmpty{
            btn.setImage(UIImage.init(named: imgName), for: .normal)
        }
        if !backImgName.isEmpty {
            btn.setBackgroundImage(UIImage.init(named: backImgName), for: .normal)
        }
        btn.imageView?.contentMode = .scaleAspectFit
        btn.addTarget(target, action: selector, for: controlEvents)
        return btn
    }
    class  func createLabel(title: String = "", color:UIColor = .black, font: CGFloat = 14, textAlignment: NSTextAlignment = .center, backColor:UIColor = .white,numberOfLines: Int = 1) -> UILabel {
        let label = UILabel.init()
        label.text = title
        label.textColor = color
        label.font = UIFont.systemFont(ofSize: font)
        label.textAlignment = textAlignment
        label.backgroundColor = backColor
        label.numberOfLines = numberOfLines
        return label
    }
    class  func createImageView(_ imgName: String = "nav_share_44x44_") -> UIImageView {
        let imgView = UIImageView.init(image: UIImage.init(named: imgName))
        imgView.isUserInteractionEnabled = true
        return imgView
    }
    class func creatScrollView(_ delegate: UIScrollViewDelegate? = nil) -> UIScrollView{
        let sc = UIScrollView.init()
        sc.delegate = delegate
        sc.isPagingEnabled = true
        sc.showsVerticalScrollIndicator = false
        sc.showsHorizontalScrollIndicator = false
        return sc
    }
    class func createLineView(_ backgroundColor: UIColor = UIColor.black.withAlphaComponent(0.15)) -> UIView{
        let view = UIView.init()
        view.backgroundColor = backgroundColor
        return view
    }
    func cuttingView(radius:CGFloat = 0, borWidth: CGFloat = 0, borColor:UIColor = .white) {
        self.layer.cornerRadius = radius
        self.layer.borderColor = borColor.cgColor
        self.layer.borderWidth = borWidth
        self.layer.masksToBounds = true
    }
    func addShadow(_ shadowColor: UIColor = .black,_ shadowOffset: CGSize = CGSize(width: 2, height:2), _ shadowRadius: CGFloat = 4,_  shadowOpacity: Float = 0.3) {
        self.layer.shadowColor = shadowColor.cgColor
        self.layer.shadowOffset = shadowOffset
        self.layer.shadowRadius = shadowRadius
        self.layer.shadowOpacity = shadowOpacity
    }
}
