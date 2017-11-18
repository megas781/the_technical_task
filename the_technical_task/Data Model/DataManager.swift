//
//  DataManager.swift
//  the_technical_task
//
//  Created by Gleb Kalachev on 11/16/17.
//  Copyright © 2017 Gleb Kalachev. All rights reserved.
//

import Foundation
import CoreData
import UIKit

//Выполнил singleton'ом
class DataManager {
    
    static var shared: DataManager {
        return self.sharedInstanceHolder
    }
    private static var sharedInstanceHolder: DataManager = DataManager.init()
    
    //Ссылка на контекст
    private let context: NSManagedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    //convenience метод (потому уберу)
    func getContext() -> NSManagedObjectContext { return self.context }
    
    private init() {
        //При инициализации shared нужно установить inMemoryClients
        self.updateInMemoryClients()
    }
    
    
    
    
    
    //MARK: Fetching data
    
    //Здесь будет храниться своеборазный FirstResponder клиент, на который направлено внимание программы
    var selectedClient: Client?
    
    //Методы для установки selectedClient
    func selectClient(_ client: Client) {
        self.selectedClient = client
    }
    
    func deselectClient() {
        self.selectedClient = nil
    }
    
    //Массив для загрузки данных с оперативой памяти. Такой подход вроде уменьшит ресурсопотребление. Массив обновляется либо вручную, либо сделаю, чтобы при любом изменении объектов
    var clients: [Client] = []
    
    //Фильтрация по формату или фамилия, или имя, или отчество или  ФИО через один пробел
    func ClientsFilteredIfNeeded(withString filterString: String) -> [Client] {
        
        //Копируем параметр для дальнейшего изменения
        
        if filterString.contains(" ") {
            
            //Здесь фильтрация по формату ФИО
            
            
            return DataManager.shared.clients.filter({ (client) -> Bool in
                return "\(client.surname) \(client.name) \(client.patronymic ?? "")".contains(filterString)
            })
            
        } else {
            
            
            //Здесь фильтрация по одному слову
            return DataManager.shared.clients.filter({ (client) -> Bool in
                return client.name.contains(filterString) || client.surname.contains(filterString) || (client.patronymic ?? "").contains(filterString)
            })
            
        }
        
        
    }
    
    //Для удобного ручного обновления массива inMemoryClients
    private func updateInMemoryClients() {
        self.clients = self.getClients()
    }
    
    //Загрузка данных с диска
    private func getClients() -> [Client] {
        
        do {
            return try self.context.fetch(Client.fetchRequest())
        } catch let error as NSError {
            print("fetching error: \(error.localizedDescription)")
            return []
        }
        
    }
    
    /*private*/ func getTransactions() -> [Transaction] {
        do {
            return try self.context.fetch(Transaction.fetchRequest())
        } catch let error as NSError {
            print("fetching error: \(error.localizedDescription)")
            return []
        }
    }
    
    
    //MARK: Managing data
    
    //Сохранение данных
    func saveChangesIfNeeded() {
        if self.context.hasChanges {
            do {
                try self.context.save()
                self.updateInMemoryClients()
            } catch let error as NSError {
                print("saving error : \(error.localizedDescription)")
                //                print("failureReason: \(error.localizedFailureReason)")
                //                print("suggestion   : \(error.localizedRecoveryOptions)")
            }
        }
    }
    
    //Удаление конкретного клиента (для разработки. В конечном проекте использоваться не будет)
    func deleteClient(_ client: Client, shouldSaveAfterDeletion: Bool = true) {
        
        self.context.delete(client)
        
        if shouldSaveAfterDeletion {
            self.saveChangesIfNeeded()
        }
        
    }
    
    //В финальном проекте использоваться не будет
    func deleteAllClients(shouldSaveAfterDeletion: Bool = true) {
        
        for client in self.getClients() {
            self.context.delete(client)
        }
        
        if shouldSaveAfterDeletion {
            self.saveChangesIfNeeded()
        }
    }
    
    //В финальном проекте использоваться не будет
    func deleteAllData() {
        
        for client in self.getClients() {
            self.context.delete(client)
        }
        
        for transaction in self.getTransactions() {
            self.context.delete(transaction)
        }
        
        self.saveChangesIfNeeded()
        
    }
    
    //Может изменю на другую архитектуру
    func createNewClientAndSave(name: String, surname: String, patronymic: String? = nil, phoneNumber: String? = nil, birthdayDate: Date, image: UIImage? = nil) {
        let _ = Client.init(name: name, surname: surname, patronymic: patronymic, phoneNumber: phoneNumber, birthdayDate: birthdayDate, image: image)
        self.saveChangesIfNeeded()
    }
    
    
    //Создать транзакцию и сохранить
    func createNewTransactionAndSave(value: Int, forClient client: Client) {
        
        client.addToStoredTransactions(Transaction.init(value: value, date: Date()))
        
        self.saveChangesIfNeeded()
        
    }
    
    
}

//extension Array<Client> {
//    func selectClient(withIndex index: Int) {
//        DataManager.selectedClient = self[index]
//    }
//}

