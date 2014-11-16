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
    
    var weightSamples: [(Double, Double)] = []
    var distanceSamples: [(Double, Double)] = []
    var sleepSamples: [(Double, Double)] = []
    
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
            
            performUpdate(self.weightSamples, self.distanceSamples, self.sleepSamples)
            
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
    
    let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate,
      ascending: true)
    
    var query = HKSampleQuery(sampleType: weightQuantityType,
      predicate: self.makePredicate(),
      limit: Int(HKObjectQueryNoLimit),
      sortDescriptors: [sortDescriptor],
      resultsHandler: {[weak self] (query: HKSampleQuery!,
        results: [AnyObject]!,
        error: NSError!) in
        
        if results?.count > 0 {
          
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
        
        self?.weightSamples = samples
          
        } else {
          print("Could not read the user's weight ")
          println("or no weight data was available")
        }
        
        
      })
    
    healthStore.executeQuery(query)
    
  }
    
    func fetchRecordedDistanceInLastDay(){
        
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate,
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
                    
                    self?.distanceSamples = samples
                    
                } else {
                    print("Could not read the user's distance ")
                    println("or no distance data was available")
                }
                
                
        })
        healthStore.executeQuery(query)
    }
    
    func fetchRecordedSleepInLastDay(){
        
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate,
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
                if results.count > 0{
                    println("Distance data from change")
                    
                    
                    var samples: [(Double, Double)] = [];
                    for sample in results as [HKCategorySample] {
                        
                        let sleep = sample.endDate.timeIntervalSinceNow - sample.startDate.timeIntervalSinceNow;
                        
                        dispatch_async(dispatch_get_main_queue(), {
                            
                            let strongSelf = self!
                            
                            println("Sleep length has been changed to " + "\(sleep)")
                            println("Change date = \(sample.startDate)")
                            
                        })
                        samples.append(sample.startDate.timeIntervalSince1970,sleep)

                    }
                    self?.sleepSamples = samples
                } else {
                    print("Could not read the user's sleep ")
                    println("or no sleep data was available")
                }
                
                
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
    
    // Returns the types of data that HLFY wishes to manipulate.
    func dataTypesToManipulate() -> NSSet {
        let distanceWalkingRunningType: HKObjectType = HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierDistanceWalkingRunning)
        let weightType: HKObjectType = HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierBodyMass)
        let sleepType: HKCategoryType = HKCategoryType.categoryTypeForIdentifier(HKCategoryTypeIdentifierSleepAnalysis)

        return NSSet(objects: distanceWalkingRunningType, weightType, sleepType)
    }
    
    func getHealthKitData() {
        if (HKHealthStore.isHealthDataAvailable()) {
            healthStore.requestAuthorizationToShareTypes(dataTypesToManipulate(), readTypes: dataTypesToManipulate(), completion: { (success, error) -> Void in
                if(success && error == nil) {
                    // Simulator check
//                    #if arch(i386) || arch(x86_64)
                        self.mockHealtKitData();
//                    #endif
                }
            })
        }
    }
    
    func mockHealtKitData() {
                
        let baseDate: NSDate = NSDate()
        let date1: NSDate = baseDate.dateByAddingTimeInterval(-dayInterval * 28)
        let date2: NSDate = baseDate.dateByAddingTimeInterval(-dayInterval * 7)
        let date3: NSDate = baseDate.dateByAddingTimeInterval(-dayInterval * 3)
        let date4: NSDate = baseDate.dateByAddingTimeInterval(-dayInterval * 1)
        
        let distanceSample1: HKQuantitySample = mockWalkingDistanceDataEntry(12, startDate: date1, endDate: date1.dateByAddingTimeInterval(dayInterval))
        let distanceSample2: HKQuantitySample = mockWalkingDistanceDataEntry(15, startDate: date2, endDate: date2.dateByAddingTimeInterval(dayInterval))
        let distanceSample3: HKQuantitySample = mockWalkingDistanceDataEntry(20, startDate: date3, endDate: date3.dateByAddingTimeInterval(dayInterval))
        let distanceSample4: HKQuantitySample = mockWalkingDistanceDataEntry(8, startDate: date4, endDate: date4.dateByAddingTimeInterval(dayInterval))
        
        let weightSample1: HKQuantitySample = mockWeightDataEntry(80, startDate: date1, endDate: date1.dateByAddingTimeInterval(dayInterval))
        let weightSample2: HKQuantitySample = mockWeightDataEntry(76, startDate: date2, endDate: date2.dateByAddingTimeInterval(dayInterval))
        let weightSample3: HKQuantitySample = mockWeightDataEntry(70, startDate: date3, endDate: date3.dateByAddingTimeInterval(dayInterval))
        let weightSample4: HKQuantitySample = mockWeightDataEntry(77, startDate: date4, endDate: date4.dateByAddingTimeInterval(dayInterval))
        
        let sleepSample1: HKCategorySample = mockSleepDataEntry(date1, endDate: date1.dateByAddingTimeInterval(dayInterval/24 * 6))
        let sleepSample2: HKCategorySample = mockSleepDataEntry(date2, endDate: date2.dateByAddingTimeInterval(dayInterval/24 * 7))
        let sleepSample3: HKCategorySample = mockSleepDataEntry(date3, endDate: date3.dateByAddingTimeInterval(dayInterval/24 * 10))
        let sleepSample4: HKCategorySample = mockSleepDataEntry(date4, endDate: date4.dateByAddingTimeInterval(dayInterval/24 * 4))

        let samples = [distanceSample1, distanceSample2, distanceSample3, distanceSample4, weightSample1, weightSample2, weightSample3, weightSample4, sleepSample1, sleepSample2, sleepSample3, sleepSample4]
        
        healthStore.saveObjects(samples, withCompletion: { (success, error) -> Void in
            if(success) {
                println("Moar Data!")
            } else {
                println("ZONK!")
            }
        })
    }
    
    func mockWalkingDistanceDataEntry(kilometers: Double, startDate: NSDate, endDate: NSDate) -> HKQuantitySample {
        let distanceWalkingRunningType: HKQuantityType = HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierDistanceWalkingRunning)
        let distanceQuantity = HKQuantity(unit: HKUnit.meterUnit(), doubleValue: kilometers * 1000)
        
        return HKQuantitySample(type: distanceWalkingRunningType, quantity: distanceQuantity, startDate: startDate, endDate: endDate)
    }
    
    func mockWeightDataEntry(kilograms: Double, startDate: NSDate, endDate: NSDate) -> HKQuantitySample {
        let weightType: HKQuantityType = HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierBodyMass)
        let weightQuantity = HKQuantity(unit: HKUnit.gramUnit(), doubleValue: kilograms * 1000)
        
        return HKQuantitySample(type: weightType, quantity: weightQuantity, startDate: startDate, endDate: endDate)
    }
    
    func mockSleepDataEntry(startDate: NSDate, endDate: NSDate) -> HKCategorySample {
        let sleepType: HKCategoryType = HKCategoryType.categoryTypeForIdentifier(HKCategoryTypeIdentifierSleepAnalysis)
        
        return HKCategorySample(type: sleepType, value: HKCategoryValueSleepAnalysis.Asleep.rawValue, startDate: startDate, endDate: endDate)
    }
}

