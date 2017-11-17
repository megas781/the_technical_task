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
        
        
        //Кнопка прибавления
        let positiveTransactionAction = UITableViewRowAction.init(style: .default, title: "  +  ") { (action, indexPath) in
            print("positiveTransactionAction performed")
            
            
            self.performSegue(withIdentifier: "presentModallyIncreasementVCIdentifier", sender: nil)
            
        }
        positiveTransactionAction.backgroundColor = #colorLiteral(red: 0, green: 0.6883943677, blue: 0.003334663808, alpha: 1)
        
        //Кнопка убавления
        let negativeTransactionAction = UITableViewRowAction.init(style: .default, title: "  -  ") { (action, indexPath) in
            print("negativeTransactionAction performed (-1000)")
            
            DataManager.shared.createNewTransactionAndSave(value: -1000, forClient: DataManager.shared.inMemoryClients[indexPath.row])
            
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
        case "presentModallyIncreasementVCIdentifier":
            
            //Показ increasementVC. Ничего, вроде, передавать не нужно
            
            break
            
        default:
            fatalError("Сигвей с неизвесным identifier'ом")
        }
    }
    
    @IBAction func unwindToClientListVC(segue: UIStoryboardSegue) {
        print("unwindToClientListVC performed")
        self.tableView.reloadData()
    }
    
    @IBAction func testButtonTapped(_ sender: UIBarButtonItem) {
        
//        print("firstClient.transactions.count: \(DataManager.shared.inMemoryClients.first!.transactions?.count ?? 0)")
        var indexer = 0
        let m = (DataManager.shared.inMemoryClients.first!.transactions?.array as! [Transaction]).map { (transaction) -> (Int,Int) in
            indexer += 1
            return (indexer, transaction.value)
        }
        
        print("transactions: \(m)")
        print("remainder: \(DataManager.shared.inMemoryClients.first!.remainder)")
        print()
        
    }
    
    
    
}

