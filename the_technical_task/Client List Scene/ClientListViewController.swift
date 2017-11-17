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
    
    
    //MARK: LifeCycle implementation
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupUI()
        
//        DataManager.shared.deleteAllData()
//        
//        print("transactions in initial deletion: \(DataManager.shared.getTransactions())")
//        
//        DataManager.shared.createNewClientAndSave(name: "Gleb", surname: "Haha", birthdayDate: Date())
//        DataManager.shared.createNewTransactionAndSave(value: 1243, forClient: DataManager.shared.inMemoryClients.first!)
//        DataManager.shared.createNewTransactionAndSave(value: 5843, forClient: DataManager.shared.inMemoryClients.first!)
//        
//        //Начальные данные
//        print("did set values")
        print("clients     : \(DataManager.shared.inMemoryClients)")
        print("transactions: \(DataManager.shared.getTransactions())")
//        
//        //Теперь удаляю клиента. Что будет с транзакциями
//        DataManager.shared.deleteClient(DataManager.shared.inMemoryClients.first!)
//        
//        print("transactions in the end: \(DataManager.shared.getTransactions())")
        
        
            
        
        
    }
    
    //MARK: UITableViewDataSource implementation
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DataManager.shared.inMemoryClients.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "ClientListTableViewCellIdentifier", for: indexPath) as! ClientListTableViewCell
        
        cell.setOutletsAndRoundImageView(with: DataManager.shared.inMemoryClients[indexPath.row])
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let positiveTransactionAction = UITableViewRowAction.init(style: .default, title: "  +  ") { (action, indexPath) in
            print("positiveTransactionAction performed")
        }
        positiveTransactionAction.backgroundColor = #colorLiteral(red: 0, green: 0.6883943677, blue: 0.003334663808, alpha: 1)
        
        
        let negativeTransactionAction = UITableViewRowAction.init(style: .default, title: "  -  ") { (action, indexPath) in
            print("negativeTransactionAction performed")
        }
        negativeTransactionAction.backgroundColor = #colorLiteral(red: 0.6911816001, green: 0.007650073618, blue: 0, alpha: 1)
        
        return [positiveTransactionAction, negativeTransactionAction]
    }
    
    
    //MARK: UITableViewDelegate implementation
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: false)
    }
    
    //MARK: IBActions on tap
    
    @IBAction func addClientButtonTapped(_ sender: UIBarButtonItem) {
        
        self.performSegue(withIdentifier: "fromCilentListVCToAddOrEditClientVCIdentifier", sender: self)
        
    }
    
    
    //MARK: Custom functions
    private func setupUI() {
        //Убираем линии
        self.tableView.tableFooterView = UIView.init(frame: CGRect.zero)
        //Чтобы при возвращении к этому viewController'у theSearchBar не был firstResponder'ом
        self.definesPresentationContext = true
    }
    
    
    //MARK: Navigation methods
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else {
            fatalError("Сигвей без identifier'а")
        }
        
        switch identifier {
        case "fromCilentListVCToAddOrEditClientVCIdentifier":
            
            let dvc = (segue.destination as! UINavigationController).viewControllers.first! as! AddOrEditClientViewController
            
//            guard let selectedClientIndex = tableView.indexPathForSelectedRow?.row else {
//                fatalError("Не смог извлечь indexPathForSelectedRow")
//            }
            
            dvc.newClientContext = true
            
            break
            
        default:
            fatalError("Сигвей с неизвесным identifier'ом")
        }
    }
    
    @IBAction func unwindToClientListVC(segue: UIStoryboardSegue) {
        print("unwindToClientListVC performed")
        self.tableView.reloadData()
    }
    
    
    
    
}

