//
//  Client+CoreDataProperties.swift
//  the_technical_task
//
//  Created by Gleb Kalachev on 11/16/17.
//  Copyright © 2017 Gleb Kalachev. All rights reserved.
//
//

import Foundation
import CoreData
import UIKit

@objc(Client)
public class Client: NSManagedObject {
    private static var context: NSManagedObjectContext { return (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext}
}

extension Client {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Client> {
        return NSFetchRequest<Client>(entityName: "Client")
    }

    //Non-optional
    @NSManaged public var name: String
    @NSManaged public var surname: String
    @NSManaged private var storedBirthdayDate: NSDate
    
    //Optional
    @NSManaged private var storedImageData: NSData?
    @NSManaged public var patronymic: String?
    @NSManaged public var phoneNumber: String?
    @NSManaged private var storedTransactions: NSOrderedSet?
    
    
    
    //MARK: Convenience properties
    var image: UIImage? {
        get {
            if let imageData = self.storedImageData as Data? {
                return UIImage.init(data: imageData)
            } else {
                return nil
            }
        }
        set(newImage) {
            if let newImage = newImage {
                self.storedImageData = UIImagePNGRepresentation(newImage) as NSData?
            } else {
                self.storedImageData = nil
            }
        }
    }
    
    var birthdayDate: Date {
        get {
            return self.storedBirthdayDate as Date
        }
        set(newDate) {
            self.storedBirthdayDate = newDate as NSDate
        }
    }
    
    //Вычисляемый остаток
    var remainder: Int {
        if let transactions = self.storedTransactions?.array as? [Transaction] {
            let returnValue = transactions.reduce(0, { (result, transaction) -> Int in
                return result + transaction.value
            })
            return returnValue
        } else {
            return 0
        }
    }
    
    //Свойство, конвертирующее storedTransactions с [Any] в [Transaction]
    var transactions: [Transaction] {
        return ((self.storedTransactions?.array ?? []) as! [Transaction]).sorted(by: { $0.date > $1.date})
    }
    
    
    
    //MARK: Convenience Initializers
    convenience init(name: String, surname: String, patronymic: String? = nil, phoneNumber: String? = nil, birthdayDate: Date, image: UIImage? = nil) {
        
        self.init(context: Client.context)
        
        self.name = name
        self.surname = surname
        
        self.patronymic = patronymic
        self.phoneNumber = phoneNumber
        
        self.birthdayDate = birthdayDate
        self.image = image
        
    }
    
    
    

}

// MARK: Generated accessors for storedTransactoins
extension Client {
    
    @objc(insertObject:inStoredTransactionsAtIndex:)
    @NSManaged public func insertIntoStoredTransactions(_ value: Transaction, at idx: Int)
    
    @objc(removeObjectFromStoredTransactionsAtIndex:)
    @NSManaged public func removeFromStoredTransactions(at idx: Int)
    
    @objc(insertStoredTransactions:atIndexes:)
    @NSManaged public func insertIntoStoredTransactions(_ values: [Transaction], at indexes: NSIndexSet)
    
    @objc(removeStoredTransactionsAtIndexes:)
    @NSManaged public func removeFromStoredTransactions(at indexes: NSIndexSet)
    
    @objc(replaceObjectInStoredTransactionsAtIndex:withObject:)
    @NSManaged public func replaceStoredTransactions(at idx: Int, with value: Transaction)
    
    @objc(replaceStoredTransactionsAtIndexes:withStoredTransactions:)
    @NSManaged public func replaceStoredTransactions(at indexes: NSIndexSet, with values: [Transaction])
    
    @objc(addStoredTransactionsObject:)
    @NSManaged public func addToStoredTransactions(_ value: Transaction)
    
    @objc(removeStoredTransactionsObject:)
    @NSManaged public func removeFromStoredTransactions(_ value: Transaction)
    
    @objc(addStoredTransactions:)
    @NSManaged public func addToStoredTransactions(_ values: NSOrderedSet)
    
    @objc(removeStoredTransactions:)
    @NSManaged public func removeFromStoredTransactions(_ values: NSOrderedSet)
    
}

