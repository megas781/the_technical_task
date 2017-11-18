//
//  ViewController.swift
//  the_technical_task
//
//  Created by Gleb Kalachev on 11/16/17.
//  Copyright © 2017 Gleb Kalachev. All rights reserved.
//

import UIKit
import CoreData



class ClientListTableViewController: UITableViewController, UISearchBarDelegate {
    
    @IBOutlet weak var theSearchBar: UISearchBar!
    
    //Это свойство детектирует, активна фильтрация или нет
    private var shouldReturnFiltered: Bool {
//        print("\() \() \()")
        if theSearchBar.isFirstResponder && theSearchBar.text != nil && theSearchBar.text?.searchableString() != "" {
            return true
        } else {
            return false
        }
    }
    
    private var properClientArray: [Client] {
        if shouldReturnFiltered {
            return DataManager.shared.ClientsFilteredIfNeeded(withString: theSearchBar.text!)
        } else {
            return DataManager.shared.clients
        }
    }
    
//    private var properClientArray = DataManager.shared.clients
    
    
    
    
    
    //MARK: Properties
    //Свойство-хранилище для передачи индекса ячейки в IncreasementVC, так как здесь его передать не получается. Устанавливаться будет в positiveTransactionAction, а присваиваться nil в prepareForSegue
//    private var editActionTappedCellIndex: Int?
    
    
    
    //MARK: LifeCycle implementation
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupUI()
        
        theSearchBar.delegate = self
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tableView.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.theSearchBar.resignFirstResponder()
        self.theSearchBar.text = ""
    }
    
    //MARK: UITableViewDataSource implementation
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.properClientArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "ClientListTableViewCellIdentifier", for: indexPath) as! ClientListTableViewCell
        
        cell.setOutletsAndRoundImageView(with: self.properClientArray[indexPath.row] )
        
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        //Кнопка убавления
        let negativeTransactionAction = UITableViewRowAction.init(style: .default, title: " - ") { (action, indexPath) in
            print("negativeTransactionAction performed (-1000)")
            
            //Обращаем внимание на клиента (в этом же блоке и удалим selectedClient)
            DataManager.shared.selectClient(self.properClientArray[indexPath.row])
            
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
            
            DataManager.shared.selectClient(self.properClientArray[indexPath.row])
            
            self.performSegue(withIdentifier: "presentModallyIncreasementVCIdentifier", sender: nil)
            
        }
        positiveTransactionAction.backgroundColor = #colorLiteral(red: 0, green: 0.6883943677, blue: 0.003334663808, alpha: 1)
        
        
        return [positiveTransactionAction, negativeTransactionAction]
    }
    
    
    //MARK: UITableViewDelegate implementation
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.performSegue(withIdentifier: "fromClientListVCToReportVCIdentifier", sender: nil)
        
        DataManager.shared.selectClient(self.properClientArray[indexPath.row])
        
        self.tableView.deselectRow(at: indexPath, animated: false)
    }
    
    //MARK: UISearchBarDelegate implementation
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print("textDidChange")
        print(self.shouldReturnFiltered)
        self.tableView.reloadData()
    }
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.resignFirstResponder()
    }
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
    }
    
    
    //MARK: IBActions on tap
    
    @IBAction func addClientButtonTapped(_ sender: UIBarButtonItem) {
        
        self.performSegue(withIdentifier: "fromCilentListVCToAddOrEditClientVCIdentifier", sender: self)
        
    }
    
    
    //MARK: Custom functions
    private func setupUI() {
        //Убираем линии
        self.tableView.tableFooterView = UIView.init(frame: CGRect.zero)
//        Чтобы при возвращении к этому viewController'у theSearchBar не был firstResponder'ом
//        self.definesPresentationContext = true
        
//        self.tableView.tableFooterView!.addGestureRecognizer(UITapGestureRecognizer.init(target: self.theSearchBar, action: #selector(self.theSearchBar.resignFirstResponder)))
        
    }
    
    
    //MARK: Navigation methods
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else {
            fatalError("Сигвей без identifier'а")
        }
        
        switch identifier {
        case "fromCilentListVCToAddOrEditClientVCIdentifier":
            
            let dvc = (segue.destination as! UINavigationController).viewControllers.first! as! AddOrEditClientViewController
            
            //Указываем, в каком контексте мы вызываем AddOrEditClientTableViewController
            dvc.whatToDoContext = .createNewClient
            
            break
        case "presentModallyIncreasementVCIdentifier":
            
            
            
            break
            
        case "fromClientListVCToReportVCIdentifier":
            
            
            
            break
            
        default:
            fatalError("Сигвей с неизвесным identifier'ом")
        }
    }
    
    @IBAction func unwindToClientListVC(segue: UIStoryboardSegue) {
        print("unwindToClientListVC performed")
        self.tableView.reloadData()
    }
    
//    @IBAction func testButtonTapped(_ sender: UIBarButtonItem) {
//        
////        print("firstClient.transactions.count: \(DataManager.shared.inMemoryClients.first!.transactions?.count ?? 0)")
//        var indexer = 0
//        let m = DataManager.shared.clients.last!.transactions.map({ (transaction) -> (Int,Int) in
//            indexer += 1
//            return (indexer, transaction.value)
//        })
//        
//        print("transactions: \(m)")
//        print("remainder: \(DataManager.shared.clients.first!.remainder)")
//        print()
//        
//    }
    
    
    
}

