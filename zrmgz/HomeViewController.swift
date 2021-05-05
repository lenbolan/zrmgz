//
//  HomeViewController.swift
//  zrmgz
//
//  Created by lenbo lan on 2021/5/1.
//

import UIKit

class HomeViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBar.tintColor = UIColor(red: 68/255, green: 25/255, blue: 123/255, alpha: 1)

        addChildViewController(child: ViewController(), title: "明细", image: "yensign.circle", topTitle: "有财记账")
        addChildViewController(child: AddAcountViewController(), title: "记账", image: "plus.circle")
        addChildViewController(child: ChartViewController(), title: "图表", image: "chart.pie")
        
        if UserDefaults.localData.keyAdmin.storedString != nil {
            addChildViewController(child: SignInViewController(), title: "签到", image: "s.circle")
        }
        
    }
    
    private func addChildViewController(child: UIViewController,
                                        title: String,
                                        image: String, topTitle: String? = nil) {
        child.tabBarItem.image = UIImage(systemName: image)
        let navVC = UINavigationController(rootViewController: child)
//        navVC.navigationBar.backgroundColor = UIColor(red: 152/255, green: 36/255, blue: 47/255, alpha: 1)
        navVC.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navVC.navigationBar.backgroundColor = .clear
        navVC.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white,
                                                   NSAttributedString.Key.font:UIFont.boldSystemFont(ofSize: 22)]
        navVC.navigationBar.tintColor = .white
//        let topColor = UIColor(red: 68/255, green: 25/255, blue: 123/255, alpha: 1) // UIColor(hexString: "#ea66a6")!
//        let bottomColor = UIColor.white
//        child.view.setBackgroundGradientColor(topColor: topColor, buttomColor: bottomColor, topPos: 0, bottomPos: 0.3)
        child.view.setDefaultBackground()
        if topTitle == nil {
            child.title = title
        } else {
            child.title = topTitle
            navVC.tabBarItem.title = title
        }
        addChild(navVC)
    }

}
