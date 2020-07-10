//
//  ScratchView.swift
//  LuckyChoice
//
//  Created by WinterOS on 2020/7/9.
//  Copyright © 2020 WinterOS. All rights reserved.
//

import UIKit

public protocol ScratchViewDelegate{
    func scratchView(result: String, percent: Float)
}
class ScratchView: UIView {
    private lazy var scrollView: UIScrollView = {
       let view = UIScrollView.init(frame: self.bounds)
        view.showsVerticalScrollIndicator = false
        view.showsHorizontalScrollIndicator = false
        return view
    }()
    var scratchDelegate: ScratchViewDelegate?
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(scrollView)
    }
    func updataScrathView(){
        for view in scrollView.subviews {
            view.removeFromSuperview()
        }
        let margin: CGFloat = 10
        let count: CGFloat = 2
        let width = (self.viewW() - (count + 1 ) * margin) / count
        let height: CGFloat = 50
        let offsetHeight = (height + margin) * CGFloat(CurrentGameAry.count / Int(count))
        scrollView.contentSize = CGSize(width: self.viewW(), height: offsetHeight)
        for index in 0 ..< CurrentGameAry.count {
            let i = CGFloat(index)
            let offsetx = margin + (margin + width) * i.truncatingRemainder(dividingBy: count)
            let offsety = (height + margin) * CGFloat(index / Int(count))
            let contentView = UILabel.createLabel(title: CurrentGameAry[index], color: UIColor.init(hexString: "#E21A1C"), font: 25, textAlignment: .center, backColor: UIColor.init(hexString: "#FFD703"), numberOfLines: 0)
            contentView.adjustsFontSizeToFitWidth = true
            contentView.cuttingView(radius: 2, borWidth: 0, borColor: .clear)
            let maskView = UIImageView.init(image: UIImage.init(named: "scratch_bg"))
            let scratchView = JXScratchView(contentView: contentView, maskView: maskView)
            scratchView.delegate = self
            scratchView.strokeLineWidth = 25
            scratchView.strokeLineCap = CAShapeLayerLineCap.round.rawValue
            scratchView.tag = index
            scratchView.frame = CGRect(x: offsetx, y:offsety, width: width, height: height)
            scrollView.addSubview(scratchView)
        }
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
extension ScratchView:JXScratchViewDelegate{
    func scratchView(scratchView: JXScratchView, didScratched percent: Float) {
        if percent >= 0.7 {
            scratchView.showContentView()
        }
        if percent >= 0.45 {
            scratchDelegate?.scratchView(result:CurrentGameAry[scratchView.tag] , percent: percent)
        }
    }
}
@objc public protocol JXScratchViewDelegate {
    func scratchView(scratchView: JXScratchView, didScratched percent: Float)
}
open class JXScratchView: UIView {
    open weak var delegate: JXScratchViewDelegate?
    open var scratchContentView: UIView!
    open var scratchMaskView: UIView!
    open var strokeLineCap: String = CAShapeLayerLineCap.round.rawValue {
        didSet {
            maskLayer.lineCap = CAShapeLayerLineCap(rawValue: strokeLineCap)
        }
    }
    open var strokeLineWidth: CGFloat = 20 {
        didSet {
            maskLayer.lineWidth = strokeLineWidth
        }
    }
    private var maskLayer: CAShapeLayer!
    private var maskPath: UIBezierPath!
    public init(contentView: UIView, maskView: UIView) {
        super.init(frame: CGRect.zero)
        scratchMaskView = maskView
        self.addSubview(scratchMaskView)
        scratchContentView = contentView
        self.addSubview(scratchContentView)
        maskLayer = CAShapeLayer()
        maskLayer.strokeColor = UIColor.red.cgColor
        maskLayer.lineWidth = strokeLineWidth
        maskLayer.lineCap = CAShapeLayerLineCap(rawValue: strokeLineCap)
        scratchContentView?.layer.mask = maskLayer
        maskPath = UIBezierPath()
        let pan = UIPanGestureRecognizer(target: self, action: #selector(processPanGesture(gesture:)))
        self.addGestureRecognizer(pan)
    }
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    open override func layoutSubviews() {
        super.layoutSubviews()
        scratchContentView?.frame = self.bounds
        scratchMaskView?.frame = self.bounds
    }
    open func showContentView() {
        self.scratchContentView.layer.mask = nil
    }
    open func resetState() {
        self.maskPath.removeAllPoints()
        self.maskLayer.path = nil
        self.scratchContentView.layer.mask = maskLayer
    }
    @objc func processPanGesture(gesture: UIPanGestureRecognizer) {
        switch gesture.state {
        case .began:
            let point = gesture.location(in: scratchContentView)
            maskPath.move(to: point)
        case .changed:
            let point = gesture.location(in: scratchContentView)
            maskPath.addLine(to: point)
            maskPath.move(to: point)
            maskLayer.path = maskPath.cgPath
            if self.delegate != nil {
                updateScratchScopePercent()
            }
        default:
            break
        }
    }
    private func updateScratchScopePercent() {
        let image = self.getImageFromContentView()
        var percent = 1 - self.getAlphaPixelPercent(img: image)
        percent = max(0, min(1, percent))
        self.delegate?.scratchView(scratchView: self, didScratched: percent)
    }
    private func getAlphaPixelPercent(img: UIImage) -> Float {
        let width = Int(img.size.width)
        let height = Int(img.size.height)
        let bitmapByteCount = width * height
        let pixelData = UnsafeMutablePointer<UInt8>.allocate(capacity: bitmapByteCount)
        let colorSpace = CGColorSpaceCreateDeviceGray()
        let context = CGContext(data: pixelData,
                                width: width,
                                height: height,
                                bitsPerComponent: 8,
                                bytesPerRow: width,
                                space: colorSpace,
                                bitmapInfo: CGBitmapInfo(rawValue:
                                    CGImageAlphaInfo.alphaOnly.rawValue).rawValue)!
        let rect = CGRect(x: 0, y: 0, width: width, height: height)
        context.clear(rect)
        context.draw(img.cgImage!, in: rect)
        var alphaPixelCount = 0
        for x in 0...Int(width) {
            for y in 0...Int(height) {
                if pixelData[y * width + x] == 0 {
                    alphaPixelCount += 1
                }
            }
        }
        free(pixelData)
        return Float(alphaPixelCount) / Float(bitmapByteCount)
    }
    private func getImageFromContentView() -> UIImage {
        let size = scratchContentView.bounds.size
        UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)
        let context = UIGraphicsGetCurrentContext()
        scratchContentView.layer.render(in: context!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
}
