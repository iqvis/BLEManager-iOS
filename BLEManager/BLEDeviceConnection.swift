//
//  BLEDeviceConnection.swift
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

import Foundation
import CoreBluetooth

// PairUnPairDeviceDelegate Protocol: Implement to get Device pairing and unpairing Success and Failure.
@objc protocol PairUnPairDeviceDelegate {
@objc optional    func devicePairedSuccessfully(peripheral: CBPeripheral)
@objc optional    func devicePairedFailed(peripheral: CBPeripheral, error: Error?)
@objc optional    func deviceUnpairedSuccessfully(peripheral: CBPeripheral, error: Error?)
}
class BLEDeviceConnection: NSObject, DeviceConnectionDelegate {
    weak var delegate: PairUnPairDeviceDelegate?
    override init() {
        super.init()
    }
    // Connect Scanned device.
    func connectScannedDevice(peripheral: CBPeripheral, options: [String : Any]?) {
        BLEManager.getSharedBLEManager().connectionDelegate = self
        BLEManager.getSharedBLEManager().connectPeripheralDevice(peripheral: peripheral, options: options)
    }
    // Disconnect Scanned Device
    func disConnectScannedDevice(peripheral: CBPeripheral) {
        BLEManager.getSharedBLEManager().connectionDelegate = self
        BLEManager.getSharedBLEManager().disconnectPeripheralDevice(peripheral: peripheral)
    }
    // This Method will be trigered once device connection will be intrupped or failed to connect due to any reason.
    func bleManagerConnectionFail(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        delegate?.devicePairedFailed!(peripheral: peripheral, error: error)
    }
    // This method will be triggered once device will be connected.
    func bleManagerDidConnect(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        delegate?.devicePairedSuccessfully!(peripheral: peripheral)
    }
    // This method will be triggered once device will be disconnected.
    func bleManagerDisConect(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        delegate?.deviceUnpairedSuccessfully!(peripheral: peripheral, error: error)
    }
}
