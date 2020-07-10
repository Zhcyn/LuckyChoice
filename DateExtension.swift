//
//  DateExtension.swift
//  LuckyChoice
//
//  Created by WinterOS on 2020/7/9.
//  Copyright © 2020 WinterOS. All rights reserved.
//

import UIKit

class DateExtension: NSObject {

}
extension Date{
    static  func convertTime(time:TimeInterval) -> String {
        let minute = Int(time.truncatingRemainder(dividingBy: 3600) / 60)
        let second = Int(time.truncatingRemainder(dividingBy: 60))
        return String(format:"%02d",minute) + ":" + String(format:"%02d",second)
    }
}
