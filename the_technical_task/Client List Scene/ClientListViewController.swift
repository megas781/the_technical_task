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
    
    //MARK: LifeCycle implementation
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setup()
        
        DataManager.shared.deleteAllClients()
        
        print("count before: \(DataManager.shared.getClients().count)")
        
        for i in 1...5 {
            DataManager.shared.createNewClientAndSave(name: "Gleb #\(i)", surname: "Kalachev", patronymic: "Романович", phoneNumber: "1-234-56-78")
        }
        
        
        print("count after : \(DataManager.shared.getClients().count)")
        
    }
    
    //MARK: UITableViewDataSource implementation
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DataManager.shared.getClients().count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "ClientListTableViewCellIdentifier", for: indexPath) as! ClientListTableViewCell
        
        cell.setOutletsAndRoundImageView(with: DataManager.shared.getClients()[indexPath.row])
        
        return cell
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
    private func setup() {
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
//            let dvc = segue.destination as! AddOrEditClientViewController
//            guard let selectedClientIndex = tableView.indexPathForSelectedRow?.row else {
//                fatalError("Не смог извлечь indexPathForSelectedRow")
//            }
            
            //Здесь вроде не нужно передавать никаких данных
            
            break
            
        default:
            fatalError("Сигвей с неизвесным identifier'ом")
        }
    }
    
    @IBAction func unwindToClientListVC(segue: UIStoryboardSegue) {
        print("unwindToClientListVC performed")
    }
    
}

