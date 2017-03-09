//
//  CharacteristicsViewController.swift
//  BLE_Demo
//
//  Created by IQVIS on 05/12/2016.
//  Copyright © 2016 IQVIS. All rights reserved.
//

import UIKit
import CoreBluetooth
class CharacteristicsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, DiscoveryDelegate {
    @IBOutlet weak var characteristicTableView: UITableView!
    var currentPeripheral: CBPeripheral?
    var selectedService: CBService?
    var discoveredCharacteristics: NSArray?
    var discovery: BLEDeviceDiscoverServices?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.characteristicTableView.register(UINib(nibName: "ServiceTableViewCell", bundle: nil), forCellReuseIdentifier: "serviceCell" )
        setServiceNavigation()
        if currentPeripheral != nil && selectedService != nil {
            self.getChracteristicsOfServices(peripheral: currentPeripheral!, service: selectedService!)
        }
        // Do any additional setup after loading the view.
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //Discover characteristics of the selected service
    func getChracteristicsOfServices(peripheral: CBPeripheral, service: CBService) {
        if discovery == nil {
            discovery = BLEDeviceDiscoverServices()
        }
            discovery?.delegate = self
            discovery?.discoverAllCharacteristics(peripheral: currentPeripheral!, service: selectedService!)
    }
    func setServiceNavigation() {
        let rightBarBtn = UIBarButtonItem(title: "Connected", style: .plain, target: self, action: #selector(ServiceViewController.settingAction))
        rightBarBtn.setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.blue], for: .normal)
        //rightBarBtn.tintColor = UIColor.black
        //rightBarBtn.title = "Connected"
        self.navigationItem.rightBarButtonItem = rightBarBtn
        self.navigationItem.title = "CHARACTERISTICS"
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor.white
    }
    func settingAction(sender: UIBarButtonItem) {
        
    }
    // MARK: - Table View
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if discoveredCharacteristics == nil ||  (discoveredCharacteristics?.count)! <= 0 {
            return 0
        }
        return (discoveredCharacteristics?.count)!
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ServiceTableViewCell = (tableView.dequeueReusableCell(withIdentifier: "serviceCell", for: indexPath) as? ServiceTableViewCell)!
        let characteristic: CBCharacteristic? = discoveredCharacteristics?.object(at: indexPath.row) as? CBCharacteristic
        if characteristic != nil {
            cell.serviceNameLbl.text = characteristic?.uuid.uuidString
        }
        return cell
    }
    // MARK: - Characteristics Call Back
    //Discover all characteristcs
    func postDiscoverdCharacteristices(discoveredCharacteristics: NSArray) {
        self.discoveredCharacteristics = NSArray(array: discoveredCharacteristics)
        characteristicTableView.reloadData()
    }
    //Discovery of characteristics failed
    func PostDicoverdCharacteristicesFailed(error: NSError?) {
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
