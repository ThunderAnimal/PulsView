//
//  HistorieDetailViewController.swift
//  PulsView
//
//  Created by Martin Weber on 17.09.17.
//  Copyright © 2017 Martin Weber. All rights reserved.
//

import Foundation
import UIKit



class HistorieDetailViewController: UIViewController {
    
    var pulsDataMeasure: PulsDataMeasureEntity?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.navigationItem.setTitle(title: "Detail", subtitle: (pulsDataMeasure?.dateStr)! + " " + (pulsDataMeasure?.timeStr)!)
        self.updateUI()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    public func setDetailData (pulsDataMeasure: PulsDataMeasureEntity){
        self.pulsDataMeasure = pulsDataMeasure
    }
    
    private func updateUI(){
        
        
    }
}
