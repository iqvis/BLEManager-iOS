//
//  DeviceTableViewCell.swift
//  BLE_Demo
//
//  Created by IQVIS on 05/12/2016.
//  Copyright © 2016 IQVIS. All rights reserved.
//

import UIKit

class DeviceTableViewCell: UITableViewCell {

    @IBOutlet weak var deviceName: UILabel!
    @IBOutlet weak var pairBtn: UIButton!
    override func awakeFromNib() {
        
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
