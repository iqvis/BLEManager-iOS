# BLEManager
`BLEManager` is Bluetooth Low Energy wrapper that scans BLE devices and pair with the BLE device to discover their services, characteristics, and descriptors. It can be used to get RSSI value periodically and scan a specific vendor device by their service UUID.
## Requirements
`BLEManager` works on BLE 4.0 following supported devices.
### iPhone
* iPhone 4s
* iPhone 5
* iPhone 5c
* iPhone 5s
* iPhone 6
* iPhone 6 Plus
* iPhone 6S
* iPhone 6S Plus
* iPhone 7
* iPhone 7 Plus

### iPad

* iPad, 3rd generation
* iPad, 4th generation
* iPad mini
* iPad mini 2
* iPad mini 3
* iPad Air
* iPad Air 2

It depends on following apple framework:

* CoreBluetooth.framework

You will need the latest developer tools (Xcode 8, swift 3) in order to use `BLEManager` . Old Xcode versions might not work due to swift 2.0 version.
## Adding `BLEManager` to your project
### Source Files
`BLEManager` have following files that can be helpul to scan,pair,discover services,characteristics and descriptors.

* `BLEManager`
* `BLEDeviceScan`
* `BLEDeviceConnection`
* `BLEDeviceDiscoverServices`
* `BLEDeviceProperties`
* `BLEDeviceRSSI`

You can directly add the above files or `BLEManager` folder to your project.
 Open your project in Xcode, then drag and drop `BLEManager` folder onto your project (use the "Product Navigator view"). Make sure to select Copy items when asked if you extracted the code archive outside of your project.
## Usage
The main guideline you need to follow when dealing with `BLEManager` before scanning
add following line of code to initiate `BLEManager` in that respective file where you want to scan BLE device
```javascript
BLEManager.getSharedBLEManager().initCentralManager(queue: DispatchQueue.main, options: nil)
```
### Scanning BLE Device
Create a object of  `BLEDeviceScan` 
```javascript
// Create Object of `BLEDeviceScan`
let scanBleDevice:BLEDeviceScan = BLEDeviceScan()
```
There are following methods available for scanning 
```javascript
// Scan all nearby BLE Devices 
func scanAllDevices()
// Scan Specific Devie by their Service UUIDs
// You can add multiple Services UUIDs in a list and also can pass multiple options 
func scanDeviceByServiceUUID(serviceUUIDs:NSArray?,options:[String : Any]?)
// Stop Scanning
func stopScanning()
```
and implement `DeviceScannedDelegate` protocol. 
`DeviceScannedDelegate` protocol have following methods
```javascript
// To get Bluetooth Connection status
func postBLEConnectionStatus(status:Int)
// Fetch device list 
func postScannedDevices(scannedDevices:NSArray)
```
Just write the following lines and implement the above `DeviceScannedDelegate` to get callbacks:  
```javascript
// Create Object of `BLEDeviceScan`
let scanBleDevice:BLEDeviceScan = BLEDeviceScan()
scanBleDevice.delegate = self
scanBleDevice.scanAllDevices()
```
### Pairing BLE Device
Create a object of  `BLEDeviceConnection` 
```javascript
// Create Object of `BLEDeviceConnection`
let connectBleDevice:BLEDeviceConnection = BLEDeviceConnection()
```
There are following methods available for paring/unpairing 
```javascript
// To pair a device by passing that CBPeripheral object whome you want to pair as param in below method and option which you want
func connectScannedDevice(peripheral:CBPeripheral, options:[String : Any]?)
// To unpair a device by passing that CBPeripheral object whome you want to unpair as param in below method
func disConnectScannedDevice(peripheral:CBPeripheral)
```
and implement `PairUnPairDeviceDelegate` protocol. 
`PairUnPairDeviceDelegate` protocol have following methods
```javascript
// Once device will pair successfully 
func devicePairedSuccessfully(peripheral:CBPeripheral)
// Once device will not be paired due to any reason
func devicePairedFailed(peripheral:CBPeripheral,error:Error?)
// Once device will be unpaired successfully
func deviceUnpairedSuccessfully(peripheral:CBPeripheral,error:Error?)
```
Just write the following lines and implement the above `PairUnPairDeviceDelegate` to get callbacks: 
```javascript
// Create Object of `BLEDeviceConnection`
let connectBleDevice:BLEDeviceConnection = BLEDeviceConnection()
connectBleDevice.delegate = self
connectBleDevice.connectScannedDevice(peripheral:selectedPeripheral, options:nil)
```
### Discover Services,Characteristics And Descriptors
Create a object of  `BLEDeviceDiscoverServices` 
```javascript
// Create Object of `BLEDeviceDiscoverServices`
let discoverBleService:BLEDeviceDiscoverServices = BLEDeviceDiscoverServices()
```
There are following methods available for Discovery 
```javascript
// Discover All Services
func discoverAllServices(peripheral:CBPeripheral)
// Discover Specific Services.
func discoverServiceByUUIDs(servicesUUIDs:NSArray,peripheral:CBPeripheral)
// Discover all Characteristics by any Service.
func discoverAllCharacteristics(peripheral:CBPeripheral,service:CBService)
// Discover Specific Characteristics by any Service.
func discoverCharacteristicsByUUIDs(charUUIds:NSArray,peripheral:CBPeripheral,service:CBService)
// Discover Descriptors By Characteristics.
func discoverDescriptorsByCharacteristic(peripheral:CBPeripheral,characteristic:CBCharacteristic)
```
and implement `DiscoveryDelegate` protocol. 
`DiscoveryDelegate` protocol have following methods
```javascript
// To get discovered Services List
func postDiscoveredServices(discoveredServices:NSArray)
// Once device services discovery failed due to any reason
func postDicoverdServiceFailed(error:NSError?)
// To get discovered Characteristices from respective Service
func postDiscoverdCharacteristices(discoveredCharacteristics:NSArray)
// Once device Characteristices discovery failed due to any reason
func PostDicoverdCharacteristicesFailed(error:NSError?)
// To get discovered Discriptors List from respective Characteristic 
func postDiscoveredDiscriptors(discoveredDiscriptors:NSArray)
// Once device discriptors discovery failed due to any reason
func postDicoverdDiscriptorsFailed(error:NSError?)
```
Just write the following lines and implement the above `DiscoveryDelegate` to get callbacks: 
```javascript
// Create Object of `BLEDeviceDiscoverServices`
let discoverBleService:BLEDeviceDiscoverServices = BLEDeviceDiscoverServices()
discoverBleService.delegate = self
discoverBleService.discoverAllServices(peripheral:selectedPeripheral)
```
### How to Read,Write and Notify Characteristices
Create a object of  `BLEDeviceProperties` 
```javascript
// Create Object of `BLEDeviceProperties`
let bleCharProperties:BLEDeviceProperties = BLEDeviceProperties()
```
There are following methods available for Properties 
```javascript
// Wrie value for any Characteristic.
func writeCharacteristicValue(peripheral:CBPeripheral, data:Data, char:CBCharacteristic, type:CBCharacteristicWriteType)
// Read value for any Characteristic.
func readCharacteristicValue(peripheral:CBPeripheral,char:CBCharacteristic)
// To Set Enable Notify value for any Characteristic.
func setNotifyValue(peripheral:CBPeripheral, enabled: Bool , char:CBCharacteristic)  
// Write Descriptor value for any descriptor.
func writeDescriptorValue(peripheral:CBPeripheral, data:Data, descriptor:CBDescriptor)
// Read Descriptor value for any descriptor.
  func readDescriptorValue(peripheral:CBPeripheral, descriptor:CBDescriptor)
```
and implement `PropertiesDelegate` protocol. 
`PropertiesDelegate` protocol have following methods
```javascript
// Once characteristic value will be written on device
func postWriteCharacteristicValue(peripheral:CBPeripheral,char:CBCharacteristic)
// Once characteristic value will not be written due to nay reason
func postWriteCharacteristicValueFailed(error:Error?)
// Once characteristic value will be read on device
func postReadCharacteristicValue(peripheral:CBPeripheral, char:CBCharacteristic)
// Once characteristic value will not be read due to nay reason
func postReadCharacteristicValueFailed(error:Error?)
// Characteristic value will be notfied once you will enable notify value.
func postNotifyValueUpdate(peripheral:CBPeripheral, char:CBCharacteristic)
// Once characteristic value will not be notfied due to any reason
func postNotifyValueUpdateFailed(error:Error?)
// Once descriptor value will be written on device
func postWriteDescriptorValue(peripheral:CBPeripheral, desc:CBDescriptor)
// Once descriptor value will not be written on device due to any reason
func postWriteDescriptorValueFailed(error:Error?)
// Once descriptor value will be read on device 
func postReadDecriptorValue(peripheral:CBPeripheral, desc:CBDescriptor)
// Once descriptor value will not be read on device due to any reason 
func postReadDecriptorValueFailed(error:Error?)
```
Just write the following lines and implement the above `PropertiesDelegate` to get callbacks: 
```javascript
// Create Object of `BLEDeviceProperties`
let bleCharProperties:BLEDeviceProperties = BLEDeviceProperties()
bleCharProperties.delegate = self
bleCharProperties.writeCharacteristicValue(peripheral:selectedPeripheral, data:dataToBeWriitten, char:selectedChar, type:.WithoutResponse)
```
### How get RSSI value
Create a object of  `BLEDeviceRSSI` 
```javascript
// Create Object of `BLEDeviceRSSI`
let bleRssiValue:BLEDeviceRSSI = BLEDeviceRSSI()
```
There is following method available for RSSI 
```javascript
// Read RSSI value
func readRSSI(peripheral:CBPeripheral)
```
and implement `ReadRSSIDelegate` protocol. 
`ReadRSSIDelegate` protocol have following methods
```javascript
// To get RSSI value
func postRSSIValue(peripheral: CBPeripheral, didReadRSSI RSSI: NSNumber)
// If RSSI value not found due to any reason.
func postRSSIValueFailed(error:Error?)
```
Just write the following lines and implement the above `ReadRSSIDelegate` to get callback: 
```javascript
// Create Object of `BLEDeviceProperties`
let bleRssiValue:BLEDeviceRSSI = BLEDeviceRSSI()
bleRssiValue.delegate = self
bleRssiValue.readRSSI(peripheral:selectedPeriphral)
```
## License 
`BLEManager` is distributed under the terms and conditions of the [Apache License, Version 2.0](http://www.apache.org/licenses/LICENSE-2.0)


