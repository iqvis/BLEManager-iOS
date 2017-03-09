//
//  ServiceTableViewCell.swift
//  BLE_Demo
//
//  Created by IQVIS on 06/12/2016.
//  Copyright © 2016 IQVIS. All rights reserved.
//

import UIKit

class ServiceTableViewCell: UITableViewCell {
    @IBOutlet weak var serviceNameLbl: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
