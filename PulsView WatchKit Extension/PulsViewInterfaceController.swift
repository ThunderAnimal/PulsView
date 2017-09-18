//
//  PulsViewInterface.swift
//  PulsView
//
//  Created by Martin Weber on 12.09.17.
//  Copyright © 2017 Martin Weber. All rights reserved.
//

import Foundation
import WatchKit

class PulsViewInterfaceController: WKInterfaceController {
    
    @IBOutlet var imageHeart: WKInterfaceImage!
    @IBOutlet var labelPuls: WKInterfaceLabel!
    @IBOutlet var btnOk: WKInterfaceButton!
    @IBOutlet var textLang: WKInterfaceLabel!

    
    lazy var notificationCenter: NotificationCenter = {
        return NotificationCenter.default
    }()
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
        
        self.imageHeart.setImageNamed("heart-");
        
        notificationCenter.addObserver(forName: NSNotification.Name(Constants.WatchNotification.newPulsData.key()), object: nil, queue: nil) { (notification) in
            if let puls = notification.userInfo?[Constants.Puls.value.key()] as? Int{
                self.setPuls(puls: puls)
                self.updateUI(puls: puls)
            }
        }
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        
        self.imageHeart.startAnimatingWithImages(in: NSMakeRange(0, 12), duration: 1.5, repeatCount: -1);
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
        
        self.imageHeart.stopAnimating();
    }
    
    override func willDisappear() {
        super.willDisappear()
        
        PulsGenerator.shared.stopGenratePulsData()
        HealthKitHelper.shared.stopMeasurePuls()
        
        PulsMeasureHandler.shared.stopMeasure()
    }
    @IBAction func btnClickOk() {
        self.dismiss()
    }
    
    private func setPuls(puls:Int){
        
       
        let fontSmall = UIFont.systemFont(ofSize: 21.0, weight: UIFontWeightSemibold)
        let fontBig = UIFont.systemFont(ofSize: 25.0, weight: UIFontWeightSemibold)
        let attrStrBig = NSAttributedString(string: String(puls), attributes: [NSFontAttributeName: fontBig])
        let attrStrSmall = NSAttributedString(string: String(puls), attributes: [NSFontAttributeName: fontSmall])
        
        self.animate(withDuration: 0.500) {
            self.labelPuls.setAttributedText(attrStrBig)
        }
        
        DispatchQueue.init(label: "NEWPULS").asyncAfter(wallDeadline: .now() + .milliseconds(600)) {
            self.animate(withDuration: 0.25) {
                self.labelPuls.setAttributedText(attrStrSmall)
            }
        }
    }
    
    private func updateUI(puls:Int){
        
        let text = "Hallo das ist ein langer Text, ich hoffe du kannst ihn lesen. Wenn nicht dann sollter der Text Größer sein"
        
        let minTextSize = 12.0
        let maxTextSize = 20.0
        let minHeightBtn = 25.0
        let maxHeightBtn = 35.0
        let minWidthBtn = 0.5
        let maxWidthBtn = 1.0
        
        var fontSize: Double!
        var btnHeight: Double!
        var btnWidth: Double!
        switch puls {
        case _ where puls < 50:
            print("under 50")
            fontSize = minTextSize
            btnHeight = minHeightBtn
            btnWidth = minWidthBtn
        case _ where puls < 60:
            print("under 60")
            fontSize = 13
            btnHeight = 26
            btnWidth = 0.55

        case _ where puls < 70:
            print("under 70")
            fontSize = 14
            btnHeight = 27
            btnWidth = 0.60
        case _ where puls < 80:
            print("under 80")
            fontSize = 15
            btnHeight = 28
            btnWidth = 0.65
        case _ where puls < 90:
            print("under 90")
            fontSize = 16
            btnHeight = 29
            btnWidth = 0.70
        case _ where puls < 100:
            print("under 100")
            fontSize = 17
            btnHeight = 30
            btnWidth = 0.75
        case _ where puls < 110:
            print("under 110")
            fontSize = 18
            btnHeight = 32
            btnWidth = 0.80
        case _ where puls < 120:
            print("under 120")
            fontSize = 19
            btnHeight = 33
            btnWidth = 0.85
        case _ where puls < 130:
            print("under 130")
            fontSize = maxTextSize
            btnHeight = 34
            btnWidth = 0.9
        case _ where puls < 140:
            print("under 140")
            fontSize = maxTextSize
            btnHeight = maxHeightBtn
            btnWidth = 0.95
            
        default:
            print ("OVER 140")
            fontSize = maxTextSize
            btnHeight = maxHeightBtn
            btnWidth = maxWidthBtn
        }
        self.textLang.setAttributedText(NSAttributedString(string: text, attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: CGFloat(fontSize))]))
        self.btnOk.setHeight(CGFloat(btnHeight))
        self.btnOk.setRelativeWidth(CGFloat(btnWidth), withAdjustment: 0)
    }
    
}
