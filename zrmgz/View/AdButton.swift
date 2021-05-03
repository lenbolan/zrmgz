//
//  AdButton.swift
//  zrmgz
//
//  Created by lenbo lan on 2021/4/27.
//

import UIKit

class AdButton: UIButton {
    
    var delegate: AdButtonDelegate?
    var flag: String?
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if isTouchInside {
            print("btn tag: \(self.tag)")
            let img = UIImage(systemName: "checkmark.circle")?.scaleImage(scaleSize: 3)
            self.setImage(img?.withTintColor(UIColor(hexString: "#90d7ec")!), for: .normal)
            self.isEnabled = false
            if flag == nil {
                self.delegate?.onTapAdButton()
            }
            flag = "clicked"
        }
    }

}
