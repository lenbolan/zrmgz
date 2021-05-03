//
//  String+Extension.swift
//  Utility
//
//  Created by lenbo lan on 2020/12/19.
//

import Foundation

public extension String {
    
    func isEmail() -> Bool {
        let regex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let pattern = NSPredicate(format: "SELF MATCHES %@", regex)
        return pattern.evaluate(with: self)
    }
    
    func converToDate() -> Date? {
        let createDateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        let dateFromStringFormatter = DateFormatter()
        dateFromStringFormatter.dateFormat = createDateFormat
        return dateFromStringFormatter.date(from: self)
    }
    
    static let random_str_characters = "0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
    static func randomStr(len : Int) -> String{
        var ranStr = ""
        for _ in 0..<len {
            let index = Int(arc4random_uniform(UInt32(random_str_characters.count)))
            ranStr.append(random_str_characters[random_str_characters.index(random_str_characters.startIndex, offsetBy: index)])
        }
        return ranStr
    }
    
}
