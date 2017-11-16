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
        self.inMemoryClients = self.getClients()
    }
    
    
    //MARK: Fetching data
    
    //Массив для загрузки данных с оперативой памяти. Такой подход вроде уменьшит ресурсопотребление. Массив обновляется либо вручную, либо сделаю, чтобы при любом изменении объектов
    var inMemoryClients: [Client] = []
    
    //Для удобного ручного обновления массива inMemoryClients
    func updateInMemoryClients() {
        self.inMemoryClients = self.getClients()
    }
    
    //Загрузка данных с диска
    func getClients() -> [Client] {
        
        do {
            return try self.context.fetch(Client.fetchRequest())
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
                print("saving error: \(error.localizedDescription)")
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
    
    func deleteAllClients(shouldSaveAfterDeletion: Bool = true) {
        
        for client in self.getClients() {
            self.context.delete(client)
        }
        
        if shouldSaveAfterDeletion {
            self.saveChangesIfNeeded()
        }
    }
    
    //Может изменю на другую архитектуру
    func createNewClientAndSave(name: String, surname: String, patronymic: String, phoneNumber: String, birthdayDate: Date = Date(), image: UIImage? = nil) {
        let _ = Client.init(name: name, surname: surname, patronymic: patronymic, phoneNumber: phoneNumber, birthdayDate: birthdayDate, image: image)
        self.saveChangesIfNeeded()
    }
    
    
}

