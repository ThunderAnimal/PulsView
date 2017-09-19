//
//  ChartHelper.swift
//  PulsView
//
//  Created by Martin Weber on 19.09.17.
//  Copyright © 2017 Martin Weber. All rights reserved.
//

import Foundation
import Charts


class ChartHelper {
    public func setUpLineChart(lineChartView: LineChartView) -> LineChartView{
        let myAppColor = AppColor()
        lineChartView.chartDescription?.text = "Time in s"
        lineChartView.noDataTextColor = myAppColor.textColorDark
        lineChartView.tintColor = myAppColor.primaryColor
        
        lineChartView.legend.enabled = false
        lineChartView.dragEnabled = true
        lineChartView.doubleTapToZoomEnabled = false
        
        //lineChartViewPuls.setScaleEnabled(false)
        
        lineChartView.xAxis.drawLabelsEnabled = true
        lineChartView.xAxis.drawAxisLineEnabled = true
        lineChartView.xAxis.drawGridLinesEnabled = false
        lineChartView.xAxis.labelPosition = XAxis.LabelPosition.bottom
        
        lineChartView.rightAxis.enabled = false
        
        let chartLimitTop: ChartLimitLine = ChartLimitLine(limit: 80)
        let chartLimitBottom: ChartLimitLine = ChartLimitLine(limit: 60)
        lineChartView.leftAxis.addLimitLine(chartLimitTop)
        lineChartView.leftAxis.addLimitLine(chartLimitBottom)
        
        return lineChartView
    }
    
    public func createLineChartDataset(pulsSeries: [ChartDataEntry]) -> LineChartDataSet{
        let charDataSet: LineChartDataSet = LineChartDataSet(values: pulsSeries, label: "Puls")
        charDataSet.axisDependency = .left
        
        let myAppColor = AppColor()
        let gradientColors = [myAppColor.primaryColorLight.cgColor,myAppColor.primaryColor.cgColor, myAppColor.primaryColorBg.cgColor] as CFArray
        let colorLocations:[CGFloat] = [1.0, 0.5, 0.0]
        let gradient = CGGradient.init(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: gradientColors, locations: colorLocations) // GradientObject
        charDataSet.setColor(myAppColor.primaryColor)
        charDataSet.setCircleColor(myAppColor.primaryColor)
        charDataSet.fill = Fill.fillWithLinearGradient(gradient!, angle: 90.0) // Set the Gradient
        charDataSet.drawFilledEnabled = true
        
        charDataSet.lineWidth = 2.0
        charDataSet.circleRadius = 2.5
        charDataSet.drawValuesEnabled = false
        
        return charDataSet
    }
}
