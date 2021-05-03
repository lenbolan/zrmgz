//
//  UIView+Extension.swift
//  components
//
//  Created by lenbo lan on 2021/4/25.
//

import UIKit

extension UIView {

    var width: CGFloat {
        return frame.size.width
    }

    var height: CGFloat {
        return frame.size.height
    }

    var top: CGFloat {
        return frame.origin.y
    }

    var bottom: CGFloat {
        return frame.size.height + frame.origin.y
    }

    var left: CGFloat {
        return frame.origin.x
    }

    var right: CGFloat {
        return frame.size.width + frame.origin.x
    }
    
    func anchor(top: NSLayoutYAxisAnchor?, left: NSLayoutXAxisAnchor?, bottom: NSLayoutYAxisAnchor?, right: NSLayoutXAxisAnchor?, paddingTop: CGFloat, paddingLeft: CGFloat, paddingBottom: CGFloat, paddingRight: CGFloat, width: CGFloat, height: CGFloat) {
        
        translatesAutoresizingMaskIntoConstraints = false
        
        if let top = top {
            self.topAnchor.constraint(equalTo: top, constant: paddingTop).isActive = true
        }
        
        if let left = left {
            self.leftAnchor.constraint(equalTo: left, constant: paddingLeft).isActive = true
        }
        
        if let bottom = bottom {
            self.bottomAnchor.constraint(equalTo: bottom, constant: -paddingBottom).isActive = true
        }
        
        if let right = right {
            self.rightAnchor.constraint(equalTo: right, constant: -paddingRight).isActive = true
        }
        
        if width != 0 {
            widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        
        if height != 0 {
            heightAnchor.constraint(equalToConstant: height).isActive = true
        }
    }

}


// MARK: - Corner & Border

@IBDesignable
public extension UIView {
    @IBInspectable var cornerRadius: CGFloat {
        get { return layer.cornerRadius }
        set {
            layer.masksToBounds = newValue > 0
            layer.cornerRadius = newValue
        }
    }
    
    @IBInspectable var borderWith: CGFloat {
        get { return layer.borderWidth }
        set { layer.borderWidth = newValue }
    }
    
    @IBInspectable var borderColor: UIColor? {
        get {
            if let CGColor = layer.borderColor {
                return UIColor(cgColor: CGColor)
            } else {
                return nil
            }
        }
        set { layer.borderColor = newValue?.cgColor }
    }
    
    /// Setup border width & color.
    func setBorder(
        width: CGFloat = 0.5,
        color: UIColor = UIColor.separator)
    {
        layer.borderWidth = width
        layer.borderColor = color.cgColor
    }
    
    func roundTop(radius:CGFloat = 5){
        self.clipsToBounds = true
        self.layer.cornerRadius = radius
        if #available(iOS 11.0, *) {
            self.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        } else {
            // Fallback on earlier versions
        }
    }

    func roundBottom(radius:CGFloat = 5){
        self.clipsToBounds = true
        self.layer.cornerRadius = radius
        if #available(iOS 11.0, *) {
            self.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        } else {
            // Fallback on earlier versions
        }
    }
    
    func roundLeft(radius:CGFloat = 5) {
        self.clipsToBounds = true
        self.layer.cornerRadius = radius
        if #available(iOS 11.0, *) {
            self.layer.maskedCorners = [
                .layerMinXMinYCorner,
                .layerMaxXMinYCorner,
                .layerMaxXMaxYCorner
            ]
        } else {
            // Fallback on earlier versions
        }
    }
    
    func roundRight(radius:CGFloat = 5) {
        self.clipsToBounds = true
        self.layer.cornerRadius = radius
        if #available(iOS 11.0, *) {
            self.layer.maskedCorners = [
                .layerMinXMinYCorner,
                .layerMaxXMinYCorner,
                .layerMinXMaxYCorner
            ]
        } else {
            // Fallback on earlier versions
        }
    }
    
}

// MARK: - Background

extension UIView {
    func setBackgroundGradientColor(topColor: UIColor, buttomColor: UIColor, topPos: NSNumber, bottomPos: NSNumber) {
        //定义渐变的颜色（从黄色渐变到橙色）
//        let topColor = UIColor(red: 199/255, green: 36/255, blue: 111/255, alpha: 1)
//        let buttomColor = UIColor(red: 38/255, green: 30/255, blue: 41/255, alpha: 1)
        let gradientColors = [topColor.cgColor, buttomColor.cgColor]

        //定义每种颜色所在的位置
        let gradientLocations:[NSNumber] = [topPos, bottomPos]

        //创建CAGradientLayer对象并设置参数
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = gradientColors
        gradientLayer.locations = gradientLocations

        //设置其CAGradientLayer对象的frame，并插入view的layer
        gradientLayer.frame = self.frame
        self.layer.insertSublayer(gradientLayer, at: 0)
    }
}

// MARK: - Blur

extension UIView {
    func blur() {
        backgroundColor = UIColor.clear
        let backend = UIToolbar(frame: bounds)
        backend.barStyle = .default
        backend.clipsToBounds = true
        insertSubview(backend, at: 0)
    }
}
