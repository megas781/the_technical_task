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
        
        //        print("fetched: \(DataManager.shared.getClients())")
        
        self.clients = DataManager.shared.getClients()
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.clients.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "", for: indexPath) as! ClientListTableViewCell
        
        
        
        return cell
    }
    
    
}

