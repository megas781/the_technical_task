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

    @NSManaged private var storedBirthday: NSDate
    @NSManaged private var imageData: NSData?
    @NSManaged public var name: String
    @NSManaged public var patronymic: String
    @NSManaged public var phoneNumber: String
    @NSManaged public var surname: String
    @NSManaged public var uuid: UUID
    @NSManaged public var transactions: NSOrderedSet?
    
    
    //MARK: Convenience properties
    var image: UIImage? {
        get {
            if let imageData = self.imageData as Data? {
                return UIImage.init(data: imageData)
            } else {
                return nil
            }
        }
        set(newImage) {
            if let newImage = newImage {
                self.imageData = UIImagePNGRepresentation(newImage) as NSData?
            } else {
                self.imageData = nil
            }
        }
    }
    
    var birthdayDate: Date {
        get {
            return self.storedBirthday as Date
        }
        set(newDate) {
            self.storedBirthday = newDate as NSDate
        }
    }
    
    
    //MARK: Convenience Initializers
    convenience init(name: String, surname: String, patronymic: String, phoneNumber: String, birthday: Date = Date(), image: UIImage? = nil) {
        
        self.init(context: Client.context)
        
        self.name = name
        self.surname = surname
        self.patronymic = patronymic
        self.phoneNumber = phoneNumber
        self.birthdayDate = birthday
        
        self.image = image
        
        self.uuid = UUID.init()
        
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
