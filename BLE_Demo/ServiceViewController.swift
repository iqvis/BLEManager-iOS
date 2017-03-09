//
//  ServiceViewController.swift
//  BLE_Demo
//
//  Created by IQVIS on 05/12/2016.
//  Copyright © 2016 IQVIS. All rights reserved.
//

import UIKit
import CoreBluetooth
class ServiceViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, DiscoveryDelegate {

    @IBOutlet weak var serviceTableView: UITableView!
    var currentPeripheral: CBPeripheral?
    var services: NSArray?
    var discovery: BLEDeviceDiscoverServices?
    override func viewDidLoad() {
        super.viewDidLoad()
        if currentPeripheral != nil {
            self.discoverServices(peripheral: currentPeripheral!)
        }
        self.serviceTableView.register(UINib(nibName: "ServiceTableViewCell", bundle: nil), forCellReuseIdentifier: "serviceCell" )
        setServiceNavigation()
        // Do any additional setup after loading the view.
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func setServiceNavigation() {
        let rightBarBtn = UIBarButtonItem(title: "Connected", style: .plain, target: self, action: #selector(ServiceViewController.settingAction))
        rightBarBtn.setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.blue], for: .normal)
        self.navigationItem.rightBarButtonItem = rightBarBtn
        self.navigationItem.title = "SERVICES"
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor.white
    }
    func settingAction(sender: UIBarButtonItem) {
    
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if services == nil ||  (services?.count)! <= 0 {
            return 0
        }
        return (services?.count)!
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ServiceTableViewCell = (tableView.dequeueReusableCell(withIdentifier: "serviceCell", for: indexPath) as? ServiceTableViewCell)!
        
        let service: CBService? = services?.object(at: indexPath.row) as? CBService
        if service != nil {
            cell.serviceNameLbl.text = service?.uuid.uuidString
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let board = UIStoryboard(name: "Main", bundle: nil)
        let nextVC: CharacteristicsViewController = (board.instantiateViewController(withIdentifier: "CharacteristicsViewController") as?CharacteristicsViewController)!
        //Setting peripheral and service to get characteristics
        nextVC.currentPeripheral = self.currentPeripheral
        nextVC.selectedService = (services?.object(at: indexPath.row) as? CBService?)!
        navigationController?.pushViewController(nextVC, animated: true)
    }
    //If Services call is failed
    func postDicoverdServiceFailed(error: NSError?) {
    }
    //Discover all the services of the connected device
    func discoverServices(peripheral: CBPeripheral) {
        if discovery == nil {
            discovery = BLEDeviceDiscoverServices()
        }
        
        discovery?.delegate = self
        discovery?.discoverAllServices(peripheral: peripheral)
    }
    //If services are discovered successfully call back
    func postDiscoveredServices(discoveredServices: NSArray) {
        services = NSArray(array: discoveredServices)
        serviceTableView.reloadData()
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
