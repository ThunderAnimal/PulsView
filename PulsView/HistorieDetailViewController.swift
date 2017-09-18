//
//  HistorieDetailViewController.swift
//  PulsView
//
//  Created by Martin Weber on 17.09.17.
//  Copyright © 2017 Martin Weber. All rights reserved.
//

import Foundation
import UIKit
import Charts


class HistorieDetailViewController: UIViewController {
    
    var pulsDataMeasure: PulsDataMeasureEntity?
    
    @IBOutlet weak var lineChartViewPuls: LineChartView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.navigationItem.setTitle(title: "Detail", subtitle: (pulsDataMeasure?.dateStr)! + " " + (pulsDataMeasure?.timeStr)!)
        
        self.setUpLineChart()
        self.setData()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
         self.lineChartViewPuls.animate(xAxisDuration: 0.3, yAxisDuration: 1.0)
    }
    
    public func setDetailData (pulsDataMeasure: PulsDataMeasureEntity){
        self.pulsDataMeasure = pulsDataMeasure
    }
    
    private func setUpLineChart(){
        let myAppColor = AppColor()
        lineChartViewPuls.chartDescription?.text = ""
        lineChartViewPuls.noDataTextColor = myAppColor.textColorDark
        lineChartViewPuls.tintColor = myAppColor.primaryColor
        
        lineChartViewPuls.dragEnabled = true
        lineChartViewPuls.setScaleEnabled(false)
        
        
        lineChartViewPuls.xAxis.drawLabelsEnabled = false
        lineChartViewPuls.xAxis.drawAxisLineEnabled = false
        lineChartViewPuls.xAxis.drawGridLinesEnabled = false
        
        lineChartViewPuls.leftAxis.axisMinimum = 15
        lineChartViewPuls.leftAxis.axisMaximum = 145
        
        lineChartViewPuls.rightAxis.enabled = false
        
        let chartLimitTop: ChartLimitLine = ChartLimitLine(limit: 80)
        let chartLimitBottom: ChartLimitLine = ChartLimitLine(limit: 60)
        
        lineChartViewPuls.leftAxis.addLimitLine(chartLimitTop)
        lineChartViewPuls.leftAxis.addLimitLine(chartLimitBottom)
    }
    private func setData(){
        
        let pulsData = self.pulsDataMeasure!.pulsData
        let pulsSeries = pulsData.map { puls in
            return ChartDataEntry(x: Double(puls.date.timeIntervalSince1970), y: Double(puls.value))
        } as [ChartDataEntry]
        
        let chartData = LineChartData()
        let chartDataset = self.createLineChartDataset(pulsSeries: pulsSeries)
        
        chartData.addDataSet(chartDataset)
        self.lineChartViewPuls.data = chartData
        
        self.lineChartViewPuls.notifyDataSetChanged()
    }
    
    private func createLineChartDataset(pulsSeries: [ChartDataEntry]) -> LineChartDataSet{
        let charDataSet: LineChartDataSet = LineChartDataSet(values: pulsSeries, label: "Puls")
        charDataSet.axisDependency = .left
        
        let myAppColor = AppColor()
        let gradientColors = [myAppColor.primaryColor.cgColor, myAppColor.primaryColorBg.cgColor] as CFArray
        let colorLocations:[CGFloat] = [1.0, 0.0]
        let gradient = CGGradient.init(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: gradientColors, locations: colorLocations) // GradientObject
        charDataSet.setColor(myAppColor.primaryColor)
        charDataSet.setCircleColor(myAppColor.primaryColorDark)
        charDataSet.fill = Fill.fillWithLinearGradient(gradient!, angle: 90.0) // Set the Gradient
        charDataSet.drawFilledEnabled = true
        
        charDataSet.lineWidth = 2.0
        charDataSet.circleRadius = 2.5
        charDataSet.drawValuesEnabled = false
        
        return charDataSet
    }
}
