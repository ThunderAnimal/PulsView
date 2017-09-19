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
import Realm
import RealmSwift

class HistorieDetailViewController: UIViewController, ChartViewDelegate {
    
    var pulsDataMeasure: PulsDataMeasureEntity?
    
    @IBOutlet weak var labelPuls: UILabel!
    @IBOutlet weak var labelPulsTime: UILabel!
    @IBOutlet weak var lineChartViewPuls: LineChartView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.navigationItem.setTitle(title: "Detail", subtitle: (pulsDataMeasure?.dateStr)! + " " + (pulsDataMeasure?.timeStr)!)
        
        let chartHelper = ChartHelper()
        self.lineChartViewPuls = chartHelper.setUpLineChart(lineChartView: self.lineChartViewPuls)
        
        self.lineChartViewPuls.leftAxis.axisMinimum = 20
        self.lineChartViewPuls.leftAxis.axisMaximum = 180
        
        self.lineChartViewPuls.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.setData()
        self.lineChartViewPuls.animate(xAxisDuration: 0.3, yAxisDuration: 1.0)
    }
    
    
    public func setDetailData (pulsDataMeasure: PulsDataMeasureEntity){
        self.pulsDataMeasure = pulsDataMeasure
    }
    
    private func setData(){
        let chartHelper = ChartHelper()
        
        let pulsData = self.pulsDataMeasure!.pulsData
        let pulsSeries = pulsData.map { puls in
            return ChartDataEntry(x: Double(puls.date.timeIntervalSince1970) - Double((pulsDataMeasure?.date.timeIntervalSince1970)!), y: Double(puls.value))
        } as [ChartDataEntry]
        
        let chartData = LineChartData()
        let chartDataset = chartHelper.createLineChartDataset(pulsSeries: pulsSeries)
        
        chartData.addDataSet(chartDataset)
        self.lineChartViewPuls.data = chartData
        

        self.lineChartViewPuls.setVisibleXRangeMaximum(59) //59 seconds
        self.lineChartViewPuls.moveViewToX(0)
        self.lineChartViewPuls.notifyDataSetChanged()
    }
    
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "mm:ss"
        
        self.labelPuls.fadeTransition(0.5)
        self.labelPuls.text = String(entry.y)
        
        self.labelPulsTime.fadeTransition(0.5)
        self.labelPulsTime.text = "Zeitpunkt: " + dateFormat.string(from: Date(timeIntervalSince1970: entry.x))
        
    }
}
