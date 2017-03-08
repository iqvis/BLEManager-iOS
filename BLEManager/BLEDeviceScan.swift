//
//  BLEDeviceScan.swift
//
//  Created by IQVIS  on 10/25/16.
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

import UIKit
import CoreBluetooth

// DeviceScannedDelegate Protocol: Implements to get Scanned Device List and Device Connection Status.
@objc protocol DeviceScannedDelegate {
@objc optional  func postScannedDevices(scannedDevices: NSArray)
@objc optional  func postBLEConnectionStatus(status: Int)
}

// DisplayPeripheral: Type of Device will be returned as a scanned device.
struct DisplayPeripheral {
    var peripheral: CBPeripheral?
    var lastRSSI: NSNumber?
    var isConnectable: Bool?
    var localName: String?
}

class BLEDeviceScan: NSObject, DeviceScaningDelegate {
   weak var delegate: DeviceScannedDelegate?
    var peripherals: [DisplayPeripheral] = []
    override init() {
        super.init()
    }
    // To Scan all Devices
    func scanAllDevices() {
        BLEManager.getSharedBLEManager().scaningDelegate = self
        BLEManager.getSharedBLEManager().scanAllDevices()
    }
    // To Scan Devices by Their Services UUIDs
    func scanDeviceByServiceUUID(serviceUUIDs: NSArray?, options: [String : Any]?) {
        BLEManager.getSharedBLEManager().scaningDelegate = self
        BLEManager.getSharedBLEManager().scanDevice(serviceUUIDs: serviceUUIDs, options: options)
    }
    // Stop Scan
    func stopScan() {
        BLEManager.getSharedBLEManager().stopScan()
    }
    // This will be triggered once BLE Device will be discoverd.
    func bleManagerDiscover(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        for (index, foundPeripheral) in peripherals.enumerated() {
            if foundPeripheral.peripheral?.identifier == peripheral.identifier {
                peripherals[index].lastRSSI = RSSI
                return
            }
        }
        let isConnectable = advertisementData["kCBAdvDataIsConnectable"] as? Bool
        let localName = advertisementData["kCBAdvDataLocalName"] as? String
        let displayPeripheral = DisplayPeripheral(peripheral: peripheral, lastRSSI: RSSI, isConnectable: isConnectable, localName: localName)
        peripherals.append(displayPeripheral)
        delegate?.postScannedDevices!(scannedDevices: peripherals as NSArray)
    }
    
    // This will be trigerred once device cinfiguration status will be changed.
    func scanningStatus(status: Int) {
        delegate?.postBLEConnectionStatus!(status: status)
    }
}
