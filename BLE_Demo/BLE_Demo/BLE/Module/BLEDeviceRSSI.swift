//
//  BLEDeviceRSSI.swift
//
//  Created by IQVIS  on 10/27/16.
//  Copyright © 2016 IQVIS. All rights reserved.
/*
 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at
 
 http://www.apache.org/licenses/LICENSE-2.0
 
 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License. */

import Foundation
import CoreBluetooth

// ReadRSSIDelegate Protocol: Implement to get RSSI Value Success or failure.
protocol ReadRSSIDelegate:class {
    func postRSSIValue(peripheral: CBPeripheral, didReadRSSI RSSI: NSNumber)
    func postRSSIValueFailed(error: Error?)
}
class BLEDeviceRSSI: NSObject, ReadRSSIValueDelegate {
    
    weak var delegate: ReadRSSIDelegate?
    
    override init() {
        super.init()
        BLEManager.getSharedBLEManager().readRSSIdelegate = self
    }
    // Read RSSI Value
    func readRSSI(peripheral: CBPeripheral) {
        BLEManager.getSharedBLEManager().readRSSI(peripheral: peripheral)
    }
    // This Methid will be triggered once RSSI value will be fetched.
    func bleManagerReadRSSIValue(_ peripheral: CBPeripheral, didReadRSSI RSSI: NSNumber, error: Error?) {
        if error != nil {
         delegate?.postRSSIValueFailed(error: error)
        } else {
            delegate?.postRSSIValue(peripheral: peripheral, didReadRSSI: RSSI)
        }
    }
}
