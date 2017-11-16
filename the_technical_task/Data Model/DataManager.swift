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
        return self.sharedInstance
    }
    private static var sharedInstance: DataManager = DataManager.init()
    
    private let context: NSManagedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    func getContext() -> NSManagedObjectContext { return self.context }
    
    private init() {
        
        
    }
    
    //MARK: Public functionality
    
    func getClients() -> [Client] {
        
        let fetchRequest: NSFetchRequest<Client> = Client.fetchRequest()
        
        do {
            return try self.context.fetch(fetchRequest)
            
        } catch let error as NSError {
            print("fetching error: \(error.localizedDescription)")
            return []
        }
        
    }
    
//    func addClient(_ client: Client) {
//        
//        
//        
//    }
    
    func saveChangesIfNeeded() {
        if self.context.hasChanges {
            do {
                try self.context.save()
            } catch let error as NSError {
                print("saving error: \(error.localizedDescription)")
            }
        }
    }
    
    
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
    
    
    
}

