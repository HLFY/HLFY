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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.getHealthKitData()
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
                    #if arch(i386) || arch(x86_64)
                        self.mockHealtKitData();
                    #endif
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

