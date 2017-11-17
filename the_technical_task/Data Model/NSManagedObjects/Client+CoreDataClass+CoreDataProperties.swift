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
    @NSManaged public var transactions: NSOrderedSet?
    //    @NSManaged public var uuid: UUID
    
    
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
        if let transactions = self.transactions?.array as? [Transaction] {
            let returnValue = transactions.reduce(0, { (result, transaction) -> Int in
                return result + transaction.value
            })
            return returnValue
        } else {
            return 0
        }
    }
    
    //Свойство, конвертирующее transactions с [Any] в [Transaction]
    var transactionArray: [Transaction] {
        return self.transactions?.array as! [Transaction]
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
        
//        self.uuid = UUID.init()
        
    }
    
    
    

}

// MARK: Generated accessors for transactions
extension Client {

    @objc(insertObject:inTransactionsAtIndex:)
    @NSManaged public func insertIntoTransactions(_ value: Transaction, at idx: Int)

    @objc(removeObjectFromTransactionsAtIndex:)
    @NSManaged public func removeFromTransactions(at idx: Int)

    @objc(insertTransactions:atIndexes:)
    @NSManaged public func insertIntoTransactions(_ values: [Transaction], at indexes: NSIndexSet)

    @objc(removeTransactionsAtIndexes:)
    @NSManaged public func removeFromTransactions(at indexes: NSIndexSet)

    @objc(replaceObjectInTransactionsAtIndex:withObject:)
    @NSManaged public func replaceTransactions(at idx: Int, with value: Transaction)

    @objc(replaceTransactionsAtIndexes:withTransactions:)
    @NSManaged public func replaceTransactions(at indexes: NSIndexSet, with values: [Transaction])

    @objc(addTransactionsObject:)
    @NSManaged public func addToTransactions(_ value: Transaction)

    @objc(removeTransactionsObject:)
    @NSManaged public func removeFromTransactions(_ value: Transaction)

    @objc(addTransactions:)
    @NSManaged public func addToTransactions(_ values: NSOrderedSet)

    @objc(removeTransactions:)
    @NSManaged public func removeFromTransactions(_ values: NSOrderedSet)

}
