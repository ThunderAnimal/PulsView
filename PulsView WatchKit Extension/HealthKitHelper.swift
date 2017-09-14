//
//  HealthKitHelper.swift
//  PulsView
//
//  Created by Martin Weber on 12.09.17.
//  Copyright © 2017 Martin Weber. All rights reserved.
//

import Foundation
import HealthKit


class HealthKitHelper: NSObject, HKWorkoutSessionDelegate{
    
    public static let shared = HealthKitHelper()
    
    
    
    private let healthStore = HKHealthStore()
    private let heartRateUnit = HKUnit(from: "count/min")
    private var workoutSession: HKWorkoutSession?
    private var currenQuery : HKQuery?
    
    private let configuration = HKWorkoutConfiguration()
    
    private override init(){
        configuration.activityType = .crossTraining
        configuration.locationType = .indoor
    }
    
    public func startMeasurePuls(){
        do{
            self.workoutSession = try HKWorkoutSession.init(configuration: configuration)
        } catch{
            print(error)
        }
        self.workoutSession?.delegate = self
        self.healthStore.start(self.workoutSession!)
    }
    
    public func stopMeasurePuls(){
        if let workout = self.workoutSession{
            self.healthStore.end(workout)
        }
    }
    
    func workoutSession(_ workoutSession: HKWorkoutSession, didChangeTo toState: HKWorkoutSessionState, from fromState: HKWorkoutSessionState, date: Date) {
        switch toState {
        case .running:
            self.startQueryOnHealthStore(date)
        case .ended:
            self.stopQueryOnHealthStore(date)
        default:
            print("Unexpected state \(toState)")
        }
    }
    
    func workoutSession(_ workoutSession: HKWorkoutSession, didFailWithError error: Error) {
        // Do nothing for now
        print("Workout error")
    }
    
    
    private func startQueryOnHealthStore(_ date : Date) {
        if let query = createHeartRateStreamingQuery(date) {
            self.currenQuery = query
            healthStore.execute(query)
        } else {
            print("can not start Query for HeartRate")
        }
    }
    
    private func stopQueryOnHealthStore(_ date : Date) {
        healthStore.stop(self.currenQuery!)
    }
    
    private func createHeartRateStreamingQuery(_ workoutStartDate: Date) -> HKQuery? {
        guard let quantityType = HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.heartRate) else { return nil }
        let datePredicate = HKQuery.predicateForSamples(withStart: workoutStartDate, end: nil, options: .strictEndDate )
        let predicate = NSCompoundPredicate(andPredicateWithSubpredicates:[datePredicate])
        
        
        let heartRateQuery = HKAnchoredObjectQuery(type: quantityType, predicate: predicate, anchor: nil, limit: Int(HKObjectQueryNoLimit)) { (query, sampleObjects, deletedObjects, newAnchor, error) -> Void in
            self.updateHeartRate(sampleObjects)
        }
        
        heartRateQuery.updateHandler = {(query, samples, deleteObjects, newAnchor, error) -> Void in
            //self.anchor = newAnchor!
            self.updateHeartRate(samples)
        }
        return heartRateQuery
    }
    
    private func updateHeartRate(_ samples: [HKSample]?) {
        guard let heartRateSamples = samples as? [HKQuantitySample] else {return}
        
        DispatchQueue.main.async {
            guard let sample = heartRateSamples.first else{return}
            let value = Int(sample.quantity.doubleValue(for: self.heartRateUnit))
            
            //Puls zurück liefern
            NotificationCenter.default.post(name: NSNotification.Name(Constants.WatchNotification.newPulsData.key()), object: nil, userInfo: [Constants.Puls.value.key(): value])
            
            SendDataHelper.init().sendPulsData(puls: value)
        }
    }
    
}
