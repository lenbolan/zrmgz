//
//  BlankViewController.swift
//  zrmgz
//
//  Created by lenbo lan on 2021/4/29.
//

import UIKit

class BlankViewController: UIViewController {
    
    var splashAdView: BUSplashAdView?
    
    var myTimer: Timer?

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        BUAdSDKManager.setDisableSKAdNetwork(true)
        
//        let topColor = UIColor(red: 152/255, green: 36/255, blue: 47/255, alpha: 1)
//        let bottomColor = UIColor.white
//        view.setBackgroundGradientColor(topColor: topColor, buttomColor: bottomColor, topPos: 0, bottomPos: 0.3)
        
        if UserDefaults.localData.keyAdmin.storedString != nil {
            splashAdView = BUSplashAdView(slotID: Constant.splashSlotID, frame: UIScreen.main.bounds)
            splashAdView?.delegate = self
            
            // optional
    //        是否设置点睛广告
    //        splashAdView.needSplashZoomOutAd = false
    //        是否隐藏跳过按钮
            splashAdView?.hideSkipButton = false
    //        超时时间
            splashAdView?.tolerateTimeout = 3
            
    //        splashAdView.loadAdData()
            
            self.view.addSubview(splashAdView!)
            splashAdView?.rootViewController = self
            
    //        self.navigationController?.view.addSubview(splashAdView)
    //        splashAdView.rootViewController = self.navigationController
            
            myTimer = Timer.scheduledTimer(timeInterval: 6,
                                           target: self,
                                           selector: #selector(onTimeOut(_:)),
                                           userInfo: ["info":"time out"],
                                           repeats: false)
            
        }

        readData()
    }
    
    @objc func onTimeOut(_ sender: Timer) {
        print(" time out ...")
        splashAdView?.removeFromSuperview()
        myTimer?.invalidate()
        myTimer = nil
        gotoHome()
    }
    
    func gotoHome() {
        let homeVC = HomeViewController()
        homeVC.modalPresentationStyle = .fullScreen
        self.present(homeVC, animated: false, completion: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if UserDefaults.localData.keyAdmin.storedString == nil {
            gotoHome()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        myTimer?.invalidate()
        myTimer = nil
    }
    
    func readData() {
        let accountTable = AccountTable.init()
        let _data = accountTable.query(_filter: nil)
        for account in _data {
            print("\(account.id) | \(account.sortId) | \(account.sortName) | \(account.type) | \(account.num) | \(account.year) | \(account.month) | \(account.day) | \(account.date)")
        }
    }

}

extension BlankViewController: BUSplashAdDelegate {
    
    // MARK: - BUSplashAdDelegate
    
    func splashAdDidLoad(_ splashAd: BUSplashAdView) {
        print("广告加载成功回调")
    }
    
    func splashAd(_ splashAd: BUSplashAdView, didFailWithError error: Error?) {
        print("\(#function)")
        if let err = error {
            print("\(err.localizedDescription)")
        }
    }
    
    func splashAdWillVisible(_ splashAd: BUSplashAdView) {
        print("SDK渲染开屏广告即将展示")
    }
    
    func splashAdDidClickSkip(_ splashAd: BUSplashAdView) {
        print("用户点击跳过按钮时会触发此回调")
    }
    
    func splashAdDidCloseOtherController(_ splashAd: BUSplashAdView, interactionType: BUInteractionType) {
        print("此回调在广告跳转到其他控制器时")
    }
    
    func splashAdWillClose(_ splashAd: BUSplashAdView) {
        print("SDK渲染开屏广告即将关闭回调")
    }
    
    func splashAdCountdown(toZero splashAd: BUSplashAdView) {
        print("倒计时为0时会触发此回调")
        splashAdView?.removeFromSuperview()
        gotoHome()
    }
    
    func splashAdDidClick(_ splashAd: BUSplashAdView) {
        print("SDK渲染开屏广告点击回调")
    }
    
    func splashAdDidClose(_ splashAd: BUSplashAdView) {
        print("SDK渲染开屏广告关闭回调")
        splashAdView?.removeFromSuperview()
        gotoHome()
    }
}
