//
//  ViewController.swift
//  BLE_Demo
//
//  Created by IQVIS on 05/12/2016.
//  Copyright © 2016 IQVIS. All rights reserved.
//

import UIKit
import CoreBluetooth

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, DeviceScannedDelegate, PairUnPairDeviceDelegate {
    
    @IBOutlet weak var bleDeviceTV: UITableView!
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    var connectedPeripheral: CBPeripheral?
    var scanController: BLEDeviceScan?
    var pairController: BLEDeviceConnection?
    var sameDevice: Bool? = false
    var deviceArray: NSArray?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.bleDeviceTV.register(UINib(nibName: "DeviceTableViewCell", bundle: nil), forCellReuseIdentifier: "bleCell" )
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = .gray
        activityIndicator.transform = CGAffineTransform(scaleX: 2.5, y: 2.5)
        view.addSubview(activityIndicator)
        
        bleDeviceTV.isHidden = true
        self.setServiceNavigation()
        
        //Setting DeviceScannedDelegate
        scanController = nil
        if scanController == nil {
            scanController = BLEDeviceScan()
        }
        scanController?.delegate = self
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if deviceArray == nil ||  (deviceArray?.count)! <= 0 {
            return 0
        }
        return (deviceArray?.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: DeviceTableViewCell = (tableView.dequeueReusableCell(withIdentifier: "bleCell", for: indexPath) as? DeviceTableViewCell)!
        
        //TAGGING AND ADDING ACTION METHOD TO THE CUSTOM CELL BUTTON
        cell.pairBtn.tag = indexPath.row
        cell.pairBtn.addTarget(self, action: #selector(ViewController.pairingAction(_:)), for:UIControlEvents.touchUpInside)
        let deviceData: DisplayPeripheral? = deviceArray?.object(at: indexPath.row) as? DisplayPeripheral
        if deviceData?.peripheral != nil {
            //If device is paired
            if deviceData?.peripheral?.state.rawValue == 2 {
                cell.pairBtn.backgroundColor = UIColor(colorLiteralRed: 255.0/255.0, green: 109.0/255.0, blue: 0.0/255.0, alpha: 1)
                cell.pairBtn.setTitle("UNPAIR", for: UIControlState.normal)
            } else {
                cell.pairBtn.backgroundColor = UIColor(colorLiteralRed: 168.0/255.0, green: 168.0/255.0, blue: 168.0/255.0, alpha: 1)
                cell.pairBtn.setTitle("PAIR", for: UIControlState.normal)
            }
            if deviceData?.peripheral?.name == nil {
                cell.deviceName.text = "UNKNOWN DEVICE" + String(indexPath.row)
            } else {
                cell.deviceName.text = deviceData?.peripheral?.name?.uppercased()
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let pairedPeripheralStruct = deviceArray?.object(at: indexPath.row) as? DisplayPeripheral
        let selectedperipheral = (pairedPeripheralStruct?.peripheral!)! as CBPeripheral
        
        //Push to ServiceViewController for only paired devices
        if selectedperipheral.state.rawValue == 2 { // 2
            let story = UIStoryboard(name: "Main", bundle: nil)
            let nextVC = story.instantiateViewController(withIdentifier: "ServiceViewController") as? ServiceViewController
            nextVC?.currentPeripheral = self.getCurrentConnectedPeripheral()
            if (navigationController?.viewControllers.contains(nextVC!))! {
            } else {
                navigationController?.pushViewController(nextVC!, animated: true)
            }
        }

    }
    
     func pairingAction(_ sender: AnyObject) {
        self.view.isUserInteractionEnabled = false
        self.activityIndicator.startAnimating()
        let pairTag: Int? = sender.tag
        //UserDefaults.standard.integer(forKey: TAG)
        if pairTag != nil {
            let pairedPeripheralStruct = deviceArray?.object(at: pairTag!) as? DisplayPeripheral
            let selectedPeripheral = (pairedPeripheralStruct?.peripheral!)! as CBPeripheral
            
            if pairController == nil {
                pairController = BLEDeviceConnection()
            }
            pairController?.delegate = self
            if selectedPeripheral.state.rawValue == 0 {
                //Disconnecting Connected Device and connecting to another
                let connectedPeripheral = self.getCurrentConnectedPeripheral()
                if connectedPeripheral != nil {
                    sameDevice = false
                    pairController?.disConnectScannedDevice(peripheral: connectedPeripheral!)
                }
                pairController?.connectScannedDevice(peripheral: selectedPeripheral, options: nil)
            } else if selectedPeripheral.state.rawValue == 1 {
                //Connecting to a device
                pairController?.connectScannedDevice(peripheral: selectedPeripheral, options: nil)
            } else if selectedPeripheral.state.rawValue == 2 {
                //Disconnecting device
                sameDevice = true
                pairController?.disConnectScannedDevice(peripheral: selectedPeripheral)
            }
        }
    }
    //Set current connected perpheral
    func setCurrentConnectedPeripherel(connectedPeripheral: CBPeripheral?) {
        self.connectedPeripheral = connectedPeripheral
    }
    //Get current connected perpheral
    func getCurrentConnectedPeripheral() -> CBPeripheral? {
        return self.connectedPeripheral
    }
    func setServiceNavigation() {
         navigationController!.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont(name: "Helvetica Neue", size: 12.0)!, NSForegroundColorAttributeName: UIColor.black]
    }

    //Scan for devices
    @IBAction func scanDevicesAction(_ sender: Any) {
        self.view.isUserInteractionEnabled = true
        self.activityIndicator.startAnimating()
        scanController = nil
        if scanController == nil {
            scanController = BLEDeviceScan()
        }
        scanController?.delegate = self

        scanController?.scanDeviceByServiceUUID(serviceUUIDs: nil, options: [CBCentralManagerScanOptionAllowDuplicatesKey: true])
    }
    
    //Call back with found scanned devies
    func postScannedDevices(scannedDevices: NSArray) {
        self.activityIndicator.stopAnimating()
        deviceArray = NSArray(array: scannedDevices)
        if deviceArray != nil && (deviceArray?.count)! > 0 {
            bleDeviceTV.isHidden = false
            bleDeviceTV.reloadData()
        }
    }
    //Call back for the device bluetooth status
    func postBLEConnectionStatus(status: Int) {
        if status == Int(4) { //OFF 4
            scanController = nil
            if scanController == nil {
                scanController = BLEDeviceScan()
            }
            scanController?.delegate = self
            
            scanController?.scanDeviceByServiceUUID(serviceUUIDs: nil, options: [CBCentralManagerScanOptionAllowDuplicatesKey: true])
            bleDeviceTV.reloadData()
        } else if status == Int(5) {
            self.activityIndicator.startAnimating()
            if scanController == nil {
                scanController = BLEDeviceScan()
            }
            scanController?.delegate = self
            scanController?.scanDeviceByServiceUUID(serviceUUIDs: nil, options: [CBCentralManagerScanOptionAllowDuplicatesKey: true])
            bleDeviceTV.reloadData()
        }
    }
    
    //Call back if the device is paired successfully
    func devicePairedSuccessfully(peripheral: CBPeripheral) {
        self.activityIndicator.stopAnimating()
        self.view.isUserInteractionEnabled = true
        bleDeviceTV.reloadData()
        self.setCurrentConnectedPeripherel(connectedPeripheral: peripheral)
        let board = UIStoryboard(name: "Main", bundle: nil)
        let nextVC: ServiceViewController = (board.instantiateViewController(withIdentifier: "ServiceViewController") as? ServiceViewController)!
        //Setting peripheral for the ServiceViewController to get services
        nextVC.currentPeripheral = peripheral
        navigationController?.pushViewController(nextVC, animated: true)
    }
    //If device pairing failed
    func devicePairedFailed(peripheral: CBPeripheral, error: Error?) {
        bleDeviceTV.reloadData()
        self.view.isUserInteractionEnabled = true
        self.activityIndicator.stopAnimating()
    }
    //If connected device is unpiared successfully
    func deviceUnpairedSuccessfully(peripheral: CBPeripheral, error: Error?) {
        if sameDevice == true {
            self.activityIndicator.stopAnimating()
            sameDevice = false
            let alert = UIAlertController(title: "Unpaired", message: "Device Unpaired Successfully",
                                          preferredStyle: UIAlertControllerStyle.alert)
            let okAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { action in
                self.view.isUserInteractionEnabled = true
            })
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
        }
        bleDeviceTV.reloadData()
    }
}
