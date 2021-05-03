//
//  SignInViewController.swift
//  zrmgz
//
//  Created by lenbo lan on 2021/4/27.
//

import UIKit
import SwiftHEXColors
import BUAdSDK

class SignInViewController: UIViewController, AdButtonDelegate {
    
    var ad_watch_times = 0
    
    var rewardedVideo: BURewardedVideoAd!
    var bannerView: BUNativeExpressBannerView!
    
    private var btns = [AdButton]()
    
    private var lb_id: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textAlignment = .center
        label.textColor = UIColor(hexString: "#130c0e")
        return label
    }()
    
    private var lb_date: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = UIColor(hexString: "#464547")
        return label
    }()
    
    private var lb_tip: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = UIColor(hexString: "#aa2116")
        return label
    }()
    
    private var container: UIView = {
        let uiview = UIView()
        uiview.layer.cornerRadius = 8
        uiview.backgroundColor = UIColor(hexString: "#ea66a6")
        return uiview
    }()
    
    private var btn_get: UIButton = {
        let btn: UIButton = UIButton()
        btn.layer.cornerRadius = 20
        btn.backgroundColor = UIColor(hexString: "#ea66a6")
        btn.setTitle("签  到", for: .normal)
        btn.titleLabel?.font.withSize(24)
        btn.addTarget(self, action: #selector(onGetTap), for: .touchUpInside)
        return btn
    }()
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        checkTodayTimes()
        
        print("Screen width: \(Constant.screenWidth)")
        var ui_width:CGFloat = 0
        var ui_padding:CGFloat = 0
        
        self.view.addSubview(lb_id)
        lb_id.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 10, paddingLeft: 30, paddingBottom: 0, paddingRight: 40, width: 200, height: 40)
        if let keyID = UserDefaults.localData.keyID.storedString {
            lb_id.text = "ID: \(keyID)"
        } else {
            let strID = String.randomStr(len: 6).uppercased()
            UserDefaults.localData.keyID.store(value: strID)
            lb_id.text = "ID: \(strID)"
        }
        
        
        self.view.addSubview(lb_date)
        lb_date.anchor(top: lb_id.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 40, paddingBottom: 0, paddingRight: 40, width: 200, height: 30)
        let current = Date.getStamp()
        let curDate = Date.timeStampToString("\(current)", useCN: false, strLink: "-")
        lb_date.text = "日期：\(curDate)"
        
        self.view.addSubview(lb_tip)
        lb_tip.anchor(top: lb_date.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 40, paddingBottom: 0, paddingRight: 40, width: 200, height: 30)
        lb_tip.text = "点亮所有的空格后可签到领取奖励"
        
        self.view.addSubview(container)
        ui_width = 280
        ui_padding = (Constant.screenWidth - ui_width) * 0.5
        container.anchor(top: lb_tip.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 30, paddingLeft: ui_padding, paddingBottom: 0, paddingRight: ui_padding, width: ui_width, height: ui_width)
        
        for i in 0..<16 {
            let column = i % 4
            let row = Int(i / 4)
            let btn = AdButton(frame: CGRect(x: 8+(column*68), y: 8+(row*68), width: 60, height: 60))
            btn.layer.cornerRadius = 5
            btn.backgroundColor = .white
            if i < ad_watch_times {
                let img = UIImage(systemName: "checkmark.circle")?.scaleImage(scaleSize: 3)
                btn.setImage(img?.withTintColor(UIColor(hexString: "#f173ac")!), for: .normal)
                btn.isEnabled = false
            } else {
                let img = UIImage(systemName: "plus.circle")?.scaleImage(scaleSize: 3)
                btn.setImage(img?.withTintColor(UIColor(hexString: "#f173ac")!), for: .normal)
            }
            btn.tag = i
            btn.delegate = self
            container.addSubview(btn)
        }
        
        self.view.addSubview(btn_get)
        ui_width = 120
        ui_padding = (Constant.screenWidth - ui_width) * 0.5
        btn_get.anchor(top: container.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 30, paddingLeft: ui_padding, paddingBottom: 0, paddingRight: ui_padding, width: ui_width, height: 40)
        btn_get.layer.shadowOpacity = 0.8
        btn_get.layer.shadowColor = UIColor.gray.cgColor
        btn_get.layer.shadowOffset = CGSize(width: 5, height: 5)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white

        requestRewardedVideoAd()
        
        requestBannerAd()
    }
    
    func checkTodayTimes() {
        let current = Date.getStamp()
        let today = Date.timeStampToString("\(current)", useCN: false, strLink: "")
        print("today: \(today)")
        
        if let keyDate = UserDefaults.localData.keyDate.storedString {
            if keyDate == today {
                ad_watch_times = UserDefaults.localData.keyState.storedInt
            } else {
                UserDefaults.localData.keyDate.store(value: today)
                UserDefaults.localData.keyState.store(value: 0)
            }
        } else {
            UserDefaults.localData.keyDate.store(value: today)
            UserDefaults.localData.keyState.store(value: 0)
        }
        
    }
    
    func requestRewardedVideoAd() {
        let rewardModel = BURewardedVideoModel.init()
//        rewardModel.userId = ""
        
        rewardedVideo = BURewardedVideoAd.init(slotID: Constant.rewardedVideoAdPlacementID, rewardedVideoModel: rewardModel)
        rewardedVideo.delegate = self
        
    }
    
    func requestBannerAd() {
        let bannerHeight:CGFloat = 90
        bannerView = BUNativeExpressBannerView(slotID: Constant.bannerSlotID, rootViewController: self, adSize: CGSize(width: Constant.screenWidth, height: bannerHeight))
        bannerView.frame = CGRect(x: 0, y: Constant.screenHeight-view.safeAreaInsets.bottom-bannerHeight, width: Constant.screenWidth, height: bannerHeight)
        bannerView.delegate = self
        bannerView.loadAdData()
    }
    
    func onTapAdButton() {
        print("onTapAdButton...")
        rewardedVideo.loadData()
    }
    
    @objc func onGetTap() {
        if ad_watch_times < 1 {
            let alertController = UIAlertController(title: nil, message: "签到失败，您还未点亮所有空格", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "确定", style: .default, handler: { action in })
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
        } else {
            let alertController = UIAlertController(title: nil, message: "签到成功，添加微信：qwer1234，领取奖励", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "确定", style: .default, handler: { action in })
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }

}

// MARK: - BURewardedVideoAdDelegate
extension SignInViewController: BURewardedVideoAdDelegate {
    func rewardedVideoAdDidLoad(_ rewardedVideoAd: BURewardedVideoAd) {
        print("\(#function)")
    }
    
    func rewardedVideoAdVideoDidLoad(_ rewardedVideoAd: BURewardedVideoAd) {
        print("\(#function)")
        rewardedVideoAd.show(fromRootViewController: self)
        
        ad_watch_times += 1
        UserDefaults.localData.keyState.store(value: ad_watch_times)
    }
    
    func rewardedVideoAd(_ rewardedVideoAd: BURewardedVideoAd, didFailWithError error: Error?) {
        print("\(#function) failed with \(String(describing: error?.localizedDescription))")
    }
}

// MARK: - BUNativeExpressBannerViewDelegate
extension SignInViewController: BUNativeExpressBannerViewDelegate {
    func nativeExpressBannerAdViewDidLoad(_ bannerAdView: BUNativeExpressBannerView) {
        print("加载成功回调")
    }
    
    func nativeExpressBannerAdView(_ bannerAdView: BUNativeExpressBannerView, didLoadFailWithError error: Error?) {
        print("\(#function) failed with \(String(describing: error?.localizedDescription))")
    }
    
    func nativeExpressBannerAdViewRenderSuccess(_ bannerAdView: BUNativeExpressBannerView) {
        print("渲染成功回调")
        // 展示Banner广告
        self.view.addSubview(self.bannerView)
    }
    
    func nativeExpressBannerAdViewRenderFail(_ bannerAdView: BUNativeExpressBannerView, error: Error?) {
        print("渲染失败")
    }
    
    func nativeExpressBannerAdViewWillBecomVisible(_ bannerAdView: BUNativeExpressBannerView) {
        print("当显示新的广告时调用此方法")
    }
    
    func nativeExpressBannerAdViewDidClick(_ bannerAdView: BUNativeExpressBannerView) {
        print("点击回调")
    }
    
    func nativeExpressBannerAdView(_ bannerAdView: BUNativeExpressBannerView, dislikeWithReason filterwords: [BUDislikeWords]?) {
        print("dislike回调方法")
        // 移除广告
        self.bannerView.removeFromSuperview()
        self.bannerView = nil
    }
    
    func nativeExpressBannerAdViewDidCloseOtherController(_ bannerAdView: BUNativeExpressBannerView, interactionType: BUInteractionType) {
        print("此回调在广告跳转到其他控制器时")
    }
}
