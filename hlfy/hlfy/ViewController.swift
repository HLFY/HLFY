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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.getHealthKitData()
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
        var healthStore: HKHealthStore = HKHealthStore()
        if (HKHealthStore.isHealthDataAvailable()) {
            
            healthStore.requestAuthorizationToShareTypes(nil, readTypes: self.dataTypesToRead(), completion:
                { (bool, error) -> Void in
                    var err: NSError?
                    println(healthStore.dateOfBirthWithError(&err))
                })
        }

    }


}

