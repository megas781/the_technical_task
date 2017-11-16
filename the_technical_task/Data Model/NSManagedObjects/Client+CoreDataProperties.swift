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


extension Client {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Client> {
        return NSFetchRequest<Client>(entityName: "Client")
    }

    @NSManaged public var birthday: NSDate?
    @NSManaged public var imageData: NSData?
    @NSManaged public var name: String
    @NSManaged public var patronymic: String
    @NSManaged public var phoneNumber: String
    @NSManaged public var surname: String
    @NSManaged public var uuid: UUID
    @NSManaged public var transactions: NSOrderedSet?

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
