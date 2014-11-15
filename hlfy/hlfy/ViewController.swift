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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        
        self.getHealthKitData()
        self.startObservingWeightChanges()
    }
    
    lazy var query: HKObserverQuery = {[weak self] in
        let strongSelf = self!
        return HKObserverQuery(sampleType: strongSelf.weightQuantityType,
            predicate: strongSelf.predicate,
            updateHandler: strongSelf.weightChangeHandler)
        }()
    
    func weightChangeHandler(query: HKObserverQuery!,
        completionHandler: HKObserverQueryCompletionHandler!,
        error: NSError!){
            
            /* Be careful, we are not on the UI thread */
            println("data has changed")
            
            completionHandler()
            
    }
    
    lazy var predicate: NSPredicate = {
        let now = NSDate()
        let yesterday =
        NSCalendar.currentCalendar().dateByAddingUnit(.DayCalendarUnit,
            value: -1,
            toDate: now,
            options: .WrapComponents)
        return HKQuery.predicateForSamplesWithStartDate(yesterday, endDate: now, options: .StrictEndDate)
    }()
    
    func startObservingWeightChanges(){
        
        healthStore.executeQuery(query)
        
        healthStore.enableBackgroundDeliveryForType(weightQuantityType,
            frequency: .Immediate,
            withCompletion: {(succeeded: Bool, error: NSError!) in
                if succeeded{
                    println("Enabled background delivery of weight changes")
                } else {
                    if let theError = error{
                        print("Failed to enable background delivery. ")
                        println("Error = \(theError)")
                    }
                }
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Returns the types of data that Fit wishes to read from HealthKit.
    func dataTypesToRead() -> NSSet {
        let dietaryCalorieEnergyType: HKObjectType = HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierDietaryEnergyConsumed);
        let activeEnergyBurnType: HKObjectType = HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierActiveEnergyBurned);
        let heightType: HKObjectType = HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierHeight);
        let weightType: HKObjectType = HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierBodyMass);
        let birthdayType: HKObjectType = HKObjectType.characteristicTypeForIdentifier(HKCharacteristicTypeIdentifierDateOfBirth);
        let biologicalSexType: HKObjectType = HKObjectType.characteristicTypeForIdentifier(HKCharacteristicTypeIdentifierBiologicalSex);

        return NSSet(objects: dietaryCalorieEnergyType, activeEnergyBurnType, heightType, weightType, birthdayType, biologicalSexType);
    }
    
    func getHealthKitData() {
        if (HKHealthStore.isHealthDataAvailable()) {
            
            healthStore.requestAuthorizationToShareTypes(nil, readTypes: self.dataTypesToRead(), completion:
                { (bool, error) -> Void in
                    var err: NSError?
                    println(self.healthStore.dateOfBirthWithError(&err))
                })
        }

    }


}

