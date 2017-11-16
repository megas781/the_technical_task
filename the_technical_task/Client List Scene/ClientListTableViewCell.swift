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
    
    @IBOutlet weak var clientFullNameLabel: UILabel!
    
    func setOutletsAndRoundImageView(with client: Client) {
        
        self.theImageView.image = client.image ?? UIImage.init(named: "empty_photo_image")
        
        self.clientFullNameLabel.text = "\(client.surname) \(client.name) \(client.patronymic ?? "")"
        
        self.theImageView.layer.cornerRadius = self.theImageView.frame.size.height/2
        
    }
    
}
