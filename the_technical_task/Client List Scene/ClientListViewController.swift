//
//  ViewController.swift
//  the_technical_task
//
//  Created by Gleb Kalachev on 11/16/17.
//  Copyright © 2017 Gleb Kalachev. All rights reserved.
//

import UIKit
import CoreData



class ClientListTableViewController: UITableViewController {
    
    @IBOutlet weak var theSearchBar: UISearchBar!
    
    //Скорее всего не буду это использовать
//    var clients: [Client] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DataManager.shared.deleteAllClients()
        
        print("count before: \(DataManager.shared.getClients().count)")
        
        for i in 1...5 {
            DataManager.shared.createNewClientAndSave(name: "Gleb #\(i)", surname: "Kalachev", patronymic: "Романович", phoneNumber: "1-234-56-78")
        }
        
        
        print("count after : \(DataManager.shared.getClients().count)")
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DataManager.shared.getClients().count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "ClientListTableViewCellIdentifier", for: indexPath) as! ClientListTableViewCell
        
        cell.setOutletsAndRoundImageView(with: DataManager.shared.getClients()[indexPath.row])
        
        return cell
    }
    
    
}

