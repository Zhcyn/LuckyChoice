//
//  StringExtension.swift
//  LuckyChoice
//
//  Created by WinterOS on 2020/7/9.
//  Copyright © 2020 WinterOS. All rights reserved.
//

import UIKit

class StringExtension: NSObject {

}
extension String{
    func textHeight(font:CGFloat, width:CGFloat) -> CGFloat {
        let rect: CGRect = self.boundingRect(with: CGSize.init(width: width, height: CGFloat(MAXFLOAT)), options: [NSStringDrawingOptions.usesFontLeading,NSStringDrawingOptions.usesLineFragmentOrigin], attributes: [NSAttributedString.Key.font:UIFont.systemFont(ofSize: font)], context: nil)
        return rect.height
    }
    func textWidth(font:CGFloat, height:CGFloat) -> CGFloat {
        let rect: CGRect = self.boundingRect(with:CGSize(width: CGFloat(MAXFLOAT), height: height),options:[NSStringDrawingOptions.usesFontLeading,NSStringDrawingOptions.usesLineFragmentOrigin],attributes:[NSAttributedString.Key.font: UIFont.systemFont(ofSize: font)],context:nil)
        return rect.width
    }
}
extension String {
    var localized: String {
        return NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value: "", comment: "")
    }
    func localized(withComment:String) -> String {
        return NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value: "", comment: withComment)
    }
    func localized(tableName: String) -> String{
        return NSLocalizedString(self, tableName: tableName, bundle: Bundle.main, value: "", comment: "")
    } }
