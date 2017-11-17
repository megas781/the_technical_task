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
//    var selectedClientIndex: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.remainderValueLabel.text = "\(DataManager.shared.selectedClient!.remainder)"
        self.tableView.tableFooterView = UIView.init(frame: CGRect.zero)
        
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
            return DataManager.shared.selectedClient!.transactions.count
        default:
            fatalError("out of sections")
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0:
            
            let cell = self.tableView.dequeueReusableCell(withIdentifier: "ClientDataInformationCellIdentifier", for: indexPath) as! AttributeTableViewCell
            
            cell.attributeNameLabel.text = self.attributeNames[indexPath.row]
            switch indexPath.row {
            case 0:
                cell.attributeValueLabel.text = DataManager.shared.selectedClient!.name
            case 1:
                cell.attributeValueLabel.text = DataManager.shared.selectedClient!.surname
            case 2:
                cell.attributeValueLabel.text = DataManager.shared.selectedClient!.patronymic
            case 3:
                cell.attributeValueLabel.text = DataManager.shared.selectedClient!.phoneNumber
            case 4:
                cell.attributeValueLabel.text = DataManager.shared.selectedClient!.birthdayDate.shortDateString
                break
            default:
                fatalError("out of attribute cells")
            }
            
            
            return cell
            
        case 1:
            let cell = self.tableView.dequeueReusableCell(withIdentifier: "TransactionCellIdentifier", for: indexPath) as! TransactionTableViewCell
            
            cell.transactionDateLabel.text = DataManager.shared.selectedClient!.transactions[indexPath.row].date.shortDateString
            cell.transactionValueLabel.text = "\((DataManager.shared.selectedClient!.transactions[indexPath.row].value))"
            
            return cell
            
        default:
            fatalError("out of sections")
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: false)
    }
    
    
}
