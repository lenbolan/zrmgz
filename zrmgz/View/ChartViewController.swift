//
//  ChartViewController.swift
//  zrmgz
//
//  Created by lenbo lan on 2021/5/4.
//

import UIKit
import AAInfographics

class ChartViewController: UIViewController {

    @IBOutlet weak var btnExpend: UIButton!
    @IBOutlet weak var btnIncome: UIButton!
    
    @IBOutlet weak var btnWeek: UIButton!
    @IBOutlet weak var btnMonth: UIButton!
    @IBOutlet weak var btnYear: UIButton!
    @IBOutlet weak var container: UIView!
    @IBOutlet weak var container2: UIView!
    
    let today = Date()
    
    var aaChartView: AAChartView?
    var aaChartView2: AAChartView?
    
    let accountList: Accountlist = Accountlist()
    
    var isInit = false
    var curDataType = 1
    var curTimeType = 1
    
    var needRefresh = false
    
    @IBAction func onTapType(_ sender: UIButton) {
        btnExpend.backgroundColor = .systemGray2
        btnIncome.backgroundColor = .systemGray2
        
        if sender.tag == 1 {
            btnExpend.backgroundColor = .orange
        } else {
            btnIncome.backgroundColor = .orange
        }
        curDataType = sender.tag
        setData(curTimeType, curDataType)
    }
    
    @IBAction func onTapDate(_ sender: UIButton) {
        btnWeek.backgroundColor = .systemGray2
        btnMonth.backgroundColor = .systemGray2
        btnYear.backgroundColor = .systemGray2
        
        if sender.tag == 1 {
            btnWeek.backgroundColor = .orange
        } else if sender.tag == 2 {
            btnMonth.backgroundColor = .orange
        } else {
            btnYear.backgroundColor = .orange
        }
        curTimeType = sender.tag
        setData(curTimeType, curDataType)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUI()
        
//        setData()
    }
    
    func setUI() {
        // bottons
        btnExpend.roundLeft()
        btnIncome.roundRight()
        
        btnWeek.roundLeft()
        btnYear.roundRight()
        
        var statusBarHeight: CGFloat = 0
        var navigationBarHeight: CGFloat = 0
        var tabBarHeight: CGFloat = 0
        if #available(iOS 13.0, *) {
            let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
            statusBarHeight = window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
        } else {
            statusBarHeight = UIApplication.shared.statusBarFrame.height
        }
        navigationBarHeight = self.navigationController?.navigationBar.frame.height ?? 0
        tabBarHeight = self.tabBarController?.tabBar.frame.size.height ?? 0
        
        let screenHeight = UIScreen.main.bounds.height
        let mainHeight = screenHeight - statusBarHeight - navigationBarHeight - tabBarHeight
        let mainWidth = UIScreen.main.bounds.width
        
        print("height: \(statusBarHeight) \(navigationBarHeight) \(tabBarHeight) \(screenHeight) \(mainHeight)")
        
        // chart
        aaChartView = AAChartView()
        aaChartView?.frame = CGRect(x: 0,
                                    y: 0,
                                    width: mainWidth,
                                    height: mainHeight*0.4)
        // aaChartView?.contentHeight = container.frame.size.height
        container.addSubview(aaChartView!)
        
        
//        container2.translatesAutoresizingMaskIntoConstraints = false
//        container2.topAnchor.constraint(equalTo: container.bottomAnchor, constant: 0).isActive = true
//        container2.leadingAnchor.constraint(equalTo: view.guide.leadingAnchor, constant: 0).isActive = true
//        container2.bottomAnchor.constraint(equalTo: view.guide.bottomAnchor, constant: 83).isActive = true
//        container2.trailingAnchor.constraint(equalTo: view.guide.trailingAnchor, constant: 0).isActive = true
        
        
        aaChartView2 = AAChartView()
        aaChartView2?.frame = CGRect(x: 0,
                                     y: 0,
                                     width: mainWidth,
                                     height: mainHeight*0.4)
        container2.addSubview(aaChartView2!)
    }
    
    func setData(_ timeType: Int = 1, _ dataType: Int = 1) {
        
        let (data, data2) = accountList.getData(timeType, dataType)
        
        if timeType == 1 {
            
            let theWeekRange = accountList.getTheWeekRangeStr("M月d日")
            let theWeekDays = accountList.getTheWeekDaysStr("M-d")
            
            let aaChartModel = AAChartModel()
                .chartType(.line)
                .title("本周")
                .subtitle("\(theWeekRange.0) - \(theWeekRange.1)")
                .inverted(false)
                .yAxisTitle("金额")
                .legendEnabled(false)
                .tooltipValueSuffix("元")
                .categories(theWeekDays)
                .colorsTheme(["#fe117c"])
                .series([
                    AASeriesElement()
                        .name("")
                        .data(data)
                ])
            
            if isInit == false {
                aaChartView?.aa_drawChartWithChartModel(aaChartModel)
            } else {
                aaChartView?.aa_refreshChartWholeContentWithChartModel(aaChartModel)
            }
            
//            刷新数据
//            aaChartView?.aa_onlyRefreshTheChartDataWithChartModelSeries(chartModelSeriesArray)
            
        } else if timeType == 2 {
            
            let thisMonth = today.month()
            let days = today.countOfDaysInMonth()
            var theMonthDays = [String]()
            for i in 1...days {
                theMonthDays.append("\(thisMonth)-\(i)")
            }
            
            let aaChartModel = AAChartModel()
                .chartType(.line)
                .title("本月")
                .subtitle("\(thisMonth)月1日 - \(thisMonth)月\(days)日")
                .inverted(false)
                .yAxisTitle("金额")
                .legendEnabled(false)
                .tooltipValueSuffix("元")
                .categories(theMonthDays)
                .colorsTheme(["#ffc069"])
                .series([
                    AASeriesElement()
                        .name("")
                        .data(data)
                ])
            
            aaChartView?.aa_refreshChartWholeContentWithChartModel(aaChartModel)
            
        } else {
            
            var theMonths = [String]()
            for i in 1...12 {
                theMonths.append("\(i)月")
            }
            
            let aaChartModel = AAChartModel()
                .chartType(.line)
                .title("今年")
                .subtitle("")
                .inverted(false)
                .yAxisTitle("金额")
                .legendEnabled(false)
                .tooltipValueSuffix("元")
                .categories(theMonths)
                .colorsTheme(["#06caf4"])
                .series([
                    AASeriesElement()
                        .name("")
                        .data(data)
                ])
            
            aaChartView?.aa_refreshChartWholeContentWithChartModel(aaChartModel)
            
        }
        
        var pieData = [[Any]]()
        for item in data2 {
            pieData.append([item.key, item.value])
        }
        let series = [
            AASeriesElement()
                .name("")
                .innerSize("20%")//内部圆环半径大小占比(内部圆环半径/扇形图半径),
                .allowPointSelect(true)
                .states(AAStates()
                            .hover(AAHover()
                                    .enabled(false)//禁用点击区块之后出现的半透明遮罩层
                            ))
                .data(pieData)
        ]
        let aaChartModel2 = AAChartModel()
            .chartType(.pie)
            .backgroundColor(AAColor.white)
            .title("支出分布图")
            .subtitle("")
            .dataLabelsEnabled(true)//是否直接显示扇形图数据
            .yAxisTitle("")
            .series(series)
        
        if isInit == false {
            aaChartView2?.aa_drawChartWithChartModel(aaChartModel2)
        } else {
            aaChartView2?.aa_onlyRefreshTheChartDataWithChartModelSeries(series)
//            aaChartView2?.aa_refreshChartWholeContentWithChartModel(aaChartModel2)
        }
        
        isInit = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        needRefresh = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
//        if needRefresh {
//            needRefresh = false
            setData()
//        }
    }

}
