//
//  ClientListTableViewCell.swift
//  the_technical_task
//
//  Created by Gleb Kalachev on 11/16/17.
//  Copyright © 2017 Gleb Kalachev. All rights reserved.
//

import UIKit

class ClientListTableViewCell: UITableViewCell {
    
    @IBOutlet weak var theImageView: UIImageView!
    
    @IBOutlet weak var ClientFullNameLabel: UILabel!
    
    func setOutlets(with client: Client) {
        
//        self.theImageView.image = client.image
        
    }
    
}
