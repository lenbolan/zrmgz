//
//  Util.swift
//  GDTMobSample-Swift
//
//  Created by nimomeng on 2018/8/22.
//  Copyright © 2018 Tencent. All rights reserved.
//

import Foundation
import UIKit

class Util: NSObject {
    class public func isIphoneX() -> Bool {
        return UIScreen.main.nativeBounds.size.height-2436 == 0 ? true : false
    }
    class public func isSmallIphone() -> Bool {
        return UIScreen.main.bounds.size.height == 480 ? true : false
    }
}

public protocol UserDefaultSettable {
    var uniqueKey: String { get }
}

public extension UserDefaultSettable where Self: RawRepresentable, Self.RawValue == String {
    
    func store(value: Any?){
        UserDefaults.standard.set(value, forKey: uniqueKey)
    }
    var storedValue: Any? {
        return UserDefaults.standard.value(forKey: uniqueKey)
    }
    var storedString: String? {
        return storedValue as? String
    }
    
    func store(url: URL?) {
        UserDefaults.standard.set(url, forKey: uniqueKey)
    }
    var storedURL: URL? {
        return UserDefaults.standard.url(forKey: uniqueKey)
    }
    
    func store(value: Bool) {
        UserDefaults.standard.set(value, forKey: uniqueKey)
    }
    var storedBool: Bool {
        return UserDefaults.standard.bool(forKey: uniqueKey)
    }
    
    func store(value: Int) {
        UserDefaults.standard.set(value, forKey: uniqueKey)
    }
    var storedInt: Int {
        return UserDefaults.standard.integer(forKey: uniqueKey)
    }
    
    func store(value: Double) {
        UserDefaults.standard.set(value, forKey: uniqueKey)
    }
    var storedDouble: Double {
        return UserDefaults.standard.double(forKey: uniqueKey)
    }
    
    func store(value: Float) {
        UserDefaults.standard.set(value, forKey: uniqueKey)
    }
    var storedFloat: Float {
        return UserDefaults.standard.float(forKey: uniqueKey)
    }
    
    var uniqueKey: String {
        return "\(Self.self).\(rawValue)"
    }
    
    /// removed object from standard userdefaults
    func removed() {
        UserDefaults.standard.removeObject(forKey: uniqueKey)
    }

}

extension UserDefaults {
    enum localData: String, UserDefaultSettable {
        case keyID
        case keyAdmin
        case keyDate
        case keyState
    }
    
    //UserDefaults.localData.keyDate.store(value: "xxxxx")
    //let keyDateValue = UserDefaults.localData.keyDate.storedString
}
