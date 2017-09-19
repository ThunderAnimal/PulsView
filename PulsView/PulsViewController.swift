//
//  PulsViewController.swift
//  PulsView
//
//  Created by Martin Weber on 05.09.17.
//  Copyright © 2017 Martin Weber. All rights reserved.
//

import Foundation
import UIKit
import Charts
import RealmSwift
import Realm

class PulsViewController: UIViewController{
    
    @IBOutlet weak var imageHeart: UIImageView!
    @IBOutlet weak var labelPuls: UILabel!
    @IBOutlet weak var lineGraphViewPuls: LineChartView!
    
    
    lazy var notificationCenter: NotificationCenter = {
        return NotificationCenter.default
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.setupNotification()
        
        let chartHelper = ChartHelper()
        self.lineGraphViewPuls = chartHelper.setUpLineChart(lineChartView: self.lineGraphViewPuls)
        self.lineGraphViewPuls.leftAxis.axisMinimum = 40
        self.lineGraphViewPuls.leftAxis.axisMaximum = 145
        self.lineGraphViewPuls.animate(xAxisDuration: 1.0, yAxisDuration: 0.5)
        
        self.setUpUI()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    private func setupNotification(){
        notificationCenter.addObserver(forName: NSNotification.Name(Constants.WatchNotification.newPulsData.key()), object: nil, queue: nil) { _ in
            self.newPuls()
        }
        notificationCenter.addObserver(forName: NSNotification.Name(Constants.WatchNotification.changeMeasureState.key()), object: nil, queue: nil) { _ in
            self.setUpUI()
        }
    }
    
    private func setUpUI(){
        let userDefauts = UserDefaults()
        
        let isMeasure = userDefauts.bool(forKey: Constants.Puls.isMeasure.key())
        if (isMeasure){
            
            self.loadData()
            
            DispatchQueue.main.async {
                self.imageHeart.image = UIImage.animatedImage(with: [
                    UIImage.init(named: "heart-0")!,
                    UIImage.init(named: "heart-1")!,
                    UIImage.init(named: "heart-2")!,
                    UIImage.init(named: "heart-3")!,
                    UIImage.init(named: "heart-4")!,
                    UIImage.init(named: "heart-5")!,
                    UIImage.init(named: "heart-6")!,
                    UIImage.init(named: "heart-7")!,
                    UIImage.init(named: "heart-8")!,
                    UIImage.init(named: "heart-9")!,
                    UIImage.init(named: "heart-10")!,
                    UIImage.init(named: "heart-11")!], duration: 1.5)
            }
            
        }else{
            self.cleanData()
            
            DispatchQueue.main.async {
                self.imageHeart.image = UIImage.init(named: "heart-0")
                
                
            }
            
        }

    }
    
    private func loadData(){
        let chartHelper = ChartHelper()
        let userDefaults = UserDefaults()
        
        let realm = try! Realm()
        let startMeasureDate = userDefaults.value(forKey: Constants.Puls.measureStartTime.key()) as? Date
        let predicate = NSPredicate(format: "date == %@", startMeasureDate! as CVarArg)
        let results = realm.objects(PulsDataMeasureEntity.self).filter(predicate)
        
        guard let pulsData = results.first?.pulsData else{
            self.cleanData()
            return
        }
        
        let pulsSeries = pulsData.map{ puls in
            return ChartDataEntry(x: Double(puls.date.timeIntervalSince1970) - Double((startMeasureDate?.timeIntervalSince1970)!), y: Double(puls.value))
            } as [ChartDataEntry]
        
        let chartData = LineChartData()
        let chartDataset = chartHelper.createLineChartDataset(pulsSeries: pulsSeries)
        
        chartData.addDataSet(chartDataset)
        self.lineGraphViewPuls.data = chartData
        
        
        self.lineGraphViewPuls.setVisibleXRangeMaximum(59) //59 seconds
        self.lineGraphViewPuls.moveViewToX((pulsSeries.max(by: { (entry1, entry2) -> Bool in
            return (entry1.x > entry2.x)
        })?.x)!)
        self.lineGraphViewPuls.notifyDataSetChanged()
    }
    
    private func cleanData(){
        let chartHelper = ChartHelper()
        
        let chartData = LineChartData()
        let chartDataset = chartHelper.createLineChartDataset(pulsSeries: [])
        
        chartData.addDataSet(chartDataset)
        
        DispatchQueue.main.async {
            self.lineGraphViewPuls.data = chartData
            
            self.lineGraphViewPuls.notifyDataSetChanged()
            self.labelPuls.text = "- -"
        }
    }
    
    private func newPuls(){
        let chartHelper = ChartHelper()
        let userDefaults = UserDefaults()
        
        let startMeasureDate = userDefaults.value(forKey: Constants.Puls.measureStartTime.key()) as? Date
        let pulsValue = userDefaults.value(forKey: Constants.Puls.value.key()) as? Int
        let pulsTime = userDefaults.value(forKey: Constants.Puls.pulsTime.key()) as? Date
        
        let data = self.lineGraphViewPuls.data
        if(data == nil){
            return
        }
        
        var set = data?.getDataSetByIndex(0)
        
        if(set == nil){
            set = chartHelper.createLineChartDataset(pulsSeries: [] as [ChartDataEntry])
            data?.addDataSet(set)
        }
        
        let timeIntervallFromMeasure = Double((pulsTime?.timeIntervalSince1970)! - (startMeasureDate?.timeIntervalSince1970)!)
        data?.addEntry(ChartDataEntry(x: timeIntervallFromMeasure, y: Double(pulsValue!)), dataSetIndex: 0)
        data?.notifyDataChanged()
        
        DispatchQueue.main.async {
            self.lineGraphViewPuls.notifyDataSetChanged()
        
            self.lineGraphViewPuls.setVisibleXRangeMinimum(59.0)
            self.lineGraphViewPuls.setVisibleXRangeMaximum(59.0)
        
            if (timeIntervallFromMeasure > 59){
                self.lineGraphViewPuls.moveViewToX(timeIntervallFromMeasure)
            }
        
            self.labelPuls.fadeTransition(0.5)
            self.labelPuls.text = String(pulsValue!)
        }
    }
}
