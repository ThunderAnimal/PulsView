//
//  PulsViewController.swift
//  PulsView
//
//  Created by Martin Weber on 05.09.17.
//  Copyright © 2017 Martin Weber. All rights reserved.
//

import Foundation
import UIKit

class PulsViewController: UIViewController{
    
    @IBOutlet weak var imageHeart: UIImageView!
    @IBOutlet weak var labelPuls: UILabel!
    
    
    lazy var notificationCenter: NotificationCenter = {
        return NotificationCenter.default
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        
        
        self.updateUI()
        self.setupNotification()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    private func setupNotification(){
        notificationCenter.addObserver(forName: NSNotification.Name(Constants.WatchNotification.newPulsData.key()), object: nil, queue: nil) { _ in
            self.updateUI()
        }
        notificationCenter.addObserver(forName: NSNotification.Name(Constants.WatchNotification.changeMeasureState.key()), object: nil, queue: nil) { _ in
            self.updateUI()
        }
    }
    
    private func updateUI(){
        let userDefauts = UserDefaults()
        
        let isMeasure = userDefauts.bool(forKey: Constants.Puls.isMeasure.key())
        
        if (isMeasure){
            let puls = userDefauts.integer(forKey: Constants.Puls.value.key())
            
            
            DispatchQueue.main.async {
                self.labelPuls.fadeTransition(0.5)
                self.labelPuls.text = String(puls)
                
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
            
            DispatchQueue.main.async {
                self.imageHeart.image = UIImage.init(named: "heart-0")
                self.labelPuls.text = "- -"
            }
            
        }

    }
}
