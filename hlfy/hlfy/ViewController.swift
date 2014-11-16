//
//  ViewController.swift
//  hlfy
//
//  Created by krzysztofsiejkowski on 15/11/14.
//  Copyright (c) 2014 HLFY. All rights reserved.
//

import UIKit
import HealthKit

class ViewController: UIViewController {
    
    var healthStore: HKHealthStore = HKHealthStore()
    let weightQuantityType = HKQuantityType.quantityTypeForIdentifier(
        HKQuantityTypeIdentifierBodyMass)
    let distanceCountType = HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierDistanceWalkingRunning)
    let sleepCategoryType = HKObjectType.categoryTypeForIdentifier(HKCategoryTypeIdentifierSleepAnalysis)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getHealthKitData()
        self.startObservingChanges()
    }
    
    func dataChangeHandler(query: HKObserverQuery!,
        completionHandler: HKObserverQueryCompletionHandler!,
        error: NSError!){
            
            println("data has changed")
            fetchRecordedWeightsInLastDay()
            fetchRecordedDistanceInLastDay()
            fetchRecordedSleepInLastDay()
            completionHandler()
    }
    
    func makeWeightQuery() -> HKObserverQuery {
        var query: HKObserverQuery = {[weak self] in
            let strongSelf = self!
            return HKObserverQuery(sampleType: strongSelf.weightQuantityType,
                predicate: nil,
                updateHandler: strongSelf.dataChangeHandler)
            }()
        return query
    }
    
    func makeDistanceQuery() -> HKObserverQuery {
        var query: HKObserverQuery = {[weak self] in
            let strongSelf = self!
            return HKObserverQuery(sampleType: strongSelf.distanceCountType,
                predicate: nil,
                updateHandler: strongSelf.dataChangeHandler)
            }()
        return query
    }
    
    func makeSleepQuery() -> HKObserverQuery {
        var query: HKObserverQuery = {[weak self] in
            let strongSelf = self!
            return HKObserverQuery(sampleType: strongSelf.sleepCategoryType,
                predicate: nil,
                updateHandler: strongSelf.dataChangeHandler)
            }()
        return query
    }
    
    
    func makePredicate() -> NSPredicate{
        var predicate: NSPredicate = {
            let now = NSDate()
            let yesterday =
            NSCalendar.currentCalendar().dateByAddingUnit(.DayCalendarUnit,
                value: -1,
                toDate: now,
                options: .WrapComponents)
            return HKQuery.predicateForSamplesWithStartDate(yesterday, endDate: now, options: .StrictEndDate)
            }()
        return predicate;
    }

    
    
    func fetchRecordedWeightsInLastDay(){
    
    let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierEndDate,
      ascending: true)
    
    var query = HKSampleQuery(sampleType: weightQuantityType,
      predicate: self.makePredicate(),
      limit: Int(HKObjectQueryNoLimit),
      sortDescriptors: [sortDescriptor],
      resultsHandler: {[weak self] (query: HKSampleQuery!,
        results: [AnyObject]!,
        error: NSError!) in
        
        if results.count > 0{
          
        var samples: [(Double, Double)] = [];
            
          for sample in results as [HKQuantitySample] {
            
            var weightSample:(Double, Double)
            
            /* Get the weight in kilograms from the quantity */
            let weightInKilograms = sample.quantity.doubleValueForUnit(
              HKUnit.gramUnitWithMetricPrefix(.Kilo))
            
            /* This is the value of "KG", localized in user's language */
            let formatter = NSMassFormatter()
            let kilogramSuffix = formatter.unitStringFromValue(
              weightInKilograms, unit: .Kilogram)
            
            
            samples.append(sample.startDate.timeIntervalSince1970,weightInKilograms)
            
          }
        println("weight sample")
        println(samples)
        
          
        } else {
          print("Could not read the user's weight ")
          println("or no weight data was available")
        }
        
        
      })
    
    healthStore.executeQuery(query)
    
  }
    
    func fetchRecordedDistanceInLastDay(){
        
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierEndDate,
            ascending: true)
        
        var query = HKSampleQuery(sampleType: distanceCountType,
            predicate: self.makePredicate(),
            limit: Int(HKObjectQueryNoLimit),
            sortDescriptors: [sortDescriptor],
            resultsHandler: {[weak self] (query: HKSampleQuery!,
                results: [AnyObject]!,
                error: NSError!) in
                
                if results.count > 0{
                    println("Distance data from change")
                    
                    
                    var samples: [(Double, Double)] = [];
                    for sample in results as [HKQuantitySample] {
                        var distanceSample:(Double, Double)
                        
                        let distance = sample.quantity.doubleValueForUnit(HKUnit.meterUnit())
                        
                        samples.append(sample.startDate.timeIntervalSince1970,distance)
                        
                    }
                    println("distance sample")
                    println(samples)
                    
                    
                    
                } else {
                    print("Could not read the user's distance ")
                    println("or no distance data was available")
                }
                
                
        })
        healthStore.executeQuery(query)
    }
    
    func fetchRecordedSleepInLastDay(){
        
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierEndDate,
            ascending: true)
        
        var query = HKSampleQuery(sampleType: sleepCategoryType,
            predicate: self.makePredicate(),
            limit: Int(HKObjectQueryNoLimit),
            sortDescriptors: [sortDescriptor],
            resultsHandler: {[weak self] (query: HKSampleQuery!,
                results: [AnyObject]!,
                error: NSError!) in
                println("sleep results")
                println(results)
//                if results.count > 0{
//                    println("Distance data from change")
//                    
//                    for sample in results as [HKCategorySample] {
//                        
//                        let sleep = sample.endDate.timeIntervalSince1970 - sample.startDate.timeIntervalSince1970;
//                        
//                        dispatch_async(dispatch_get_main_queue(), {
//                            
//                            let strongSelf = self!
//                            
//                            println("Sleep length has been changed to " + "\(sleep)")
//                            println("Change date = \(sample.startDate)")
//                            
//                        })
//                    }
//                    
//                } else {
//                    print("Could not read the user's sleep ")
//                    println("or no sleep data was available")
//                }
                
                
        })
        healthStore.executeQuery(query)
    }
    
    
    func startObservingChanges(){
        
        healthStore.executeQuery(self.makeWeightQuery())
        healthStore.executeQuery(self.makeDistanceQuery())
        healthStore.executeQuery(self.makeSleepQuery())
        
        healthStore.enableBackgroundDeliveryForType(weightQuantityType,
            frequency: .Immediate,
            withCompletion: {(succeeded: Bool, error: NSError!) in
                if succeeded{
                    println("Enabled background delivery of weight changes")
                } else {
                    if let theError = error{
                        print("Failed to enable background delivery for weight. ")
                        println("Error = \(theError)")
                    }
                }
        })
        
        healthStore.enableBackgroundDeliveryForType(distanceCountType,
            frequency: .Immediate,
            withCompletion: {(succeeded: Bool, error: NSError!) in
                if succeeded{
                    println("Enabled background delivery of distance changes")
                } else {
                    if let theError = error{
                        print("Failed to enable background delivery for distance. ")
                        println("Error = \(theError)")
                    }
                }
        })
        
        healthStore.enableBackgroundDeliveryForType(sleepCategoryType,
            frequency: .Immediate,
            withCompletion: {(succeeded: Bool, error: NSError!) in
                if succeeded{
                    println("Enabled background delivery of sleep changes")
                } else {
                    if let theError = error{
                        print("Failed to enable background delivery for sleep. ")
                        println("Error = \(theError)")
                    }
                }
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Returns the types of data that HLFY wishes to read from HealthKit.
    func dataTypesToRead() -> NSSet {
        let distanceWalkingRunningType: HKObjectType = HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierDistanceWalkingRunning)
        let stepsCountType: HKObjectType = HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierStepCount)
        let dietaryEnergyConsumedType: HKObjectType = HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierDietaryEnergyConsumed)
        let heightType: HKObjectType = HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierHeight)
        let weightType: HKObjectType = HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierBodyMass)
        let birthdayType: HKObjectType = HKObjectType.characteristicTypeForIdentifier(HKCharacteristicTypeIdentifierDateOfBirth)
        let biologicalSexType: HKObjectType = HKObjectType.characteristicTypeForIdentifier(HKCharacteristicTypeIdentifierBiologicalSex)

        return NSSet(objects: distanceWalkingRunningType, stepsCountType, dietaryEnergyConsumedType, heightType, weightType, birthdayType, biologicalSexType)
    }
    
    // Returns the types of data that HLFY wishes to write to HealthKit.
    func dataTypesToWrite() -> NSSet {
        let distanceWalkingRunningType: HKObjectType = HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierDistanceWalkingRunning)
        let stepsCountType: HKObjectType = HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierStepCount)
        let dietaryEnergyConsumedType: HKObjectType = HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierDietaryEnergyConsumed)
        let heightType: HKObjectType = HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierHeight)
        let weightType: HKObjectType = HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierBodyMass)
        
        return NSSet(objects: distanceWalkingRunningType, stepsCountType, dietaryEnergyConsumedType, heightType, weightType)
    }
    
    func getHealthKitData() {
        if (HKHealthStore.isHealthDataAvailable()) {
            healthStore.requestAuthorizationToShareTypes(dataTypesToWrite(), readTypes: dataTypesToRead(), completion: { (success, error) -> Void in
                if(success && error == nil) {
                    // Simulator check
//                    #if arch(i386) || arch(x86_64)
//                        self.mockHealtKitData();
//                    #endif
                }
            })
        }
    }
    
    func mockHealtKitData() {
        let date : NSDate = NSDate();
        
        let distanceWalkingRunningType: HKQuantityType = HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierDistanceWalkingRunning)
        let distanceQuantity = HKQuantity(unit: HKUnit.meterUnit(), doubleValue: 10000)
        let distanceSample: HKQuantitySample = HKQuantitySample(type: distanceWalkingRunningType, quantity: distanceQuantity, startDate: date.dateByAddingTimeInterval(-10000), endDate: date)
        
        let stepsCountType: HKQuantityType = HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierStepCount)
        let stepsQuantity = HKQuantity(unit: HKUnit.countUnit(), doubleValue: 9000)
        let stepsSample: HKQuantitySample = HKQuantitySample(type: stepsCountType, quantity: stepsQuantity, startDate: date.dateByAddingTimeInterval(-10000), endDate: date)
        
        healthStore.saveObjects([distanceSample, stepsSample], withCompletion: { (success, error) -> Void in
            if(success) {
                println("Moar Data!")
            } else {
                println("ZONK!")
            }
        })
    }
}

