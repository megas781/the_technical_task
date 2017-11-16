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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Client.init(name: "", surname: "", patronymic: "", phoneNumber: "")
////        print("fetchd objects: \(DataManager().getClients())")
//        
//        print("before: \(DataManager.shared.getContext().hasChanges)")
//        
//        let newClient = Client.init(name: "Gleb", surname: "Kalachev", patronymic: "Романович", phoneNumber: "8-937-539-93-02")
//        
//        print("new client: \(newClient)")
//        
//        print("after : \(DataManager.shared.getContext().hasChanges)")
//        
//        DataManager.shared.saveChanges()
//        
//        print("saved changes")
//        
////        newClient.na += " [changed]"
        
    }

}

