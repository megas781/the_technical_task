//
//  ReportViewController.swift
//  the_technical_task
//
//  Created by Gleb Kalachev on 11/16/17.
//  Copyright © 2017 Gleb Kalachev. All rights reserved.
//

import UIKit
import CoreData

class ReportViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var remainderValueLabel: UILabel!
    
    //MARK: Properties
    private let attributeNames = ["Имя", "Фамилия", "Отчество", "Телефон", "Дата рождения"]
    
    //Индекс выбранного клиента
    var selectedClientIndex: Int!
    
    override func viewDidLoad() {
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Информация о клиенте"
        case 1:
            return "Движение средств"
        default:
            fatalError("out of sections")
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 5
        case 1:
            return DataManager.shared.inMemoryClients[self.selectedClientIndex].transactions?.count ?? 0
        default:
            fatalError("out of sections")
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0:
            
            let cell = self.tableView.dequeueReusableCell(withIdentifier: "ClientDataInformationCellIdentifier", for: indexPath) as! AttributeTableViewCell
            
            
            
            return cell
            
        case 1:
            let cell = self.tableView.dequeueReusableCell(withIdentifier: "TransactionCellIdentifier", for: indexPath) as! TransactionTableViewCell
            
            return cell
            
        default:
            fatalError("out of sections")
        }
        
    }
    
    
}
