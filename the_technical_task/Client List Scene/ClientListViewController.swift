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
    
    
    //MARK: Properties
    //Свойство-хранилище для передачи индекса ячейки в IncreasementVC, так как здесь его передать не получается. Устанавливаться будет в positiveTransactionAction, а присваиваться nil в prepareForSegue
//    private var editActionTappedCellIndex: Int?
    
    
    
    //MARK: LifeCycle implementation
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupUI()
        
        
    }
    
    //MARK: UITableViewDataSource implementation
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DataManager.shared.clients.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "ClientListTableViewCellIdentifier", for: indexPath) as! ClientListTableViewCell
        
        cell.setOutletsAndRoundImageView(with: DataManager.shared.clients[indexPath.row])
        
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        //Кнопка убавления
        let negativeTransactionAction = UITableViewRowAction.init(style: .default, title: " - ") { (action, indexPath) in
            print("negativeTransactionAction performed (-1000)")
            
            //Обращаем внимание на клиента (в этом же блоке и удалим selectedClient)
            DataManager.shared.selectClient(withIndex: indexPath.row)
            
            //Если на счете достаточно средств, то отнимаем
            if DataManager.shared.clients[indexPath.row].remainder >= 1000 {
                
                DataManager.shared.createNewTransactionAndSave(value: -1000, forClient: DataManager.shared.selectedClient!)
                
                //Сразу убираем выделение
                DataManager.shared.deselectClient()
                
            } else {
                //В противном случае покажем AlertController, говорящий о том, что не достаточно средств
                let ac = UIAlertController.init(title: "Не достаточно средств", message: "На счете \(DataManager.shared.clients[indexPath.row].remainder)", preferredStyle: .alert)
                ac.addAction(UIAlertAction.init(title: "ОК", style: .cancel, handler: nil))
                
                self.present(ac, animated: true, completion: {
                    //После показа AlertController'a убираем выделение
                    DataManager.shared.deselectClient()
                })
            }
            
            
        }
        negativeTransactionAction.backgroundColor = #colorLiteral(red: 0.6911816001, green: 0.007650073618, blue: 0, alpha: 1)
        
        
        //Кнопка прибавления
        let positiveTransactionAction = UITableViewRowAction.init(style: .default, title: " + ") { (action, indexPath) in
            print("positiveTransactionAction performed")
            
            DataManager.shared.selectClient(withIndex: indexPath.row)
            
            self.performSegue(withIdentifier: "presentModallyIncreasementVCIdentifier", sender: nil)
            
        }
        positiveTransactionAction.backgroundColor = #colorLiteral(red: 0, green: 0.6883943677, blue: 0.003334663808, alpha: 1)
        
        
        return [positiveTransactionAction, negativeTransactionAction]
    }
    
    
    //MARK: UITableViewDelegate implementation
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.performSegue(withIdentifier: "fromClientListVCToReportVCIdentifier", sender: nil)
        
        guard let index = tableView.indexPathForSelectedRow?.row else {
            fatalError("Не смог извлечь selectedIndex")
        }
        DataManager.shared.selectClient(withIndex: index)
        
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
            
            //Указываем, в каком контексте мы вызываем AddOrEditClientTableViewController
            dvc.whatToDoContext = .createNewClient
            
            break
        case "presentModallyIncreasementVCIdentifier":
            
            //Вспоминаем, какой editAction какой ячейки мы нажали?
//            guard let index = self.editActionTappedCellIndex else {
//                fatalError("Coundn't retrieve indexPathForSelectedRow?.row")
//            }
//            
//            //Здесь забываем это значение, так как теперь его держать будет IncreasementVC
//            self.editActionTappedCellIndex = nil
//            
//            let dvc = segue.destination as! IncreasementViewController
//            
//            //Передаю индекс клиента, на не самого клиента, потому что не хочу, чтобы viewController связывался с Client
//            dvc.selectedClientIndex = index
            
            break
            
        case "fromClientListVCToReportVCIdentifier":
            
//            let dvc = segue.destination as! ReportViewController
//            
////            print(self.tableView.indexPathForSelectedRow)
//            
//            guard let selectedCellIndex = self.tableView.indexPathForSelectedRow?.row else {
//                fatalError("не смог извлечь indexPathForSelectedRow")
//            }
//            
//            dvc.selectedClientIndex = selectedCellIndex
            
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
        let m = DataManager.shared.clients.last!.transactions.map({ (transaction) -> (Int,Int) in
            indexer += 1
            return (indexer, transaction.value)
        })
        
        print("transactions: \(m)")
        print("remainder: \(DataManager.shared.clients.first!.remainder)")
        print()
        
    }
    
    
    
}

