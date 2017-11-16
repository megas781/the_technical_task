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
    
    var clients: [Client] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DataManager.shared.deleteAllClients()
        
        
//        var newClient = Client.init(name: "Gleb", surname: "Kalachev", patronymic: "Романович", phoneNumber: "8-937-539-73-02")
        var newClient = Client.init(context: DataManager.shared.getContext())
        
        
        
        
        
        guard DataManager.shared.getContext().hasChanges else {
            fatalError("doesn't have any changes")
        }
        DataManager.shared.saveChangesIfNeeded()
        
        self.clients = DataManager.shared.getClients()
        
        print("fetchedArray.countBeforeDeletion: \(DataManager.shared.getClients().count)")
        print("     vcArray.countBeforeDeletion: \(self.clients.count)")
        
        DataManager.shared.deleteClient(self.clients.first!)
        
        
        print("fetchedArray.countafterDeletion : \(DataManager.shared.getClients().count)")
        print("     vcArray.countAfterDeletion : \(self.clients.count)")
        
        
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.clients.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "ClientListTableViewCellIdentifier", for: indexPath) as! ClientListTableViewCell
        
        
        
        return cell
    }
    
    
}

