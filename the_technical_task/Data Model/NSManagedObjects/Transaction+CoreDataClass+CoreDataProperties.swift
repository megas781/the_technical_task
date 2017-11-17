//
//  Transaction+CoreDataProperties.swift
//  the_technical_task
//
//  Created by Gleb Kalachev on 11/16/17.
//  Copyright © 2017 Gleb Kalachev. All rights reserved.
//
//

import Foundation
import CoreData
import UIKit

@objc(Transaction)
public class Transaction: NSManagedObject {
    private static var context: NSManagedObjectContext { return (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext}
}

extension Transaction {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Transaction> {
        return NSFetchRequest<Transaction>(entityName: "Transaction")
    }

    @NSManaged private var storedDate: NSDate
    @NSManaged private var storedValue: Int32

    @NSManaged public var client: Client?
    
    
    //Convenience properties
    var date: Date {
        get {
            return self.storedDate as Date
        }
        set(newDate) {
            self.storedDate = newDate as NSDate
        }
    }
    var value: Int {
        get {
            return Int(self.storedValue)
        }
        set {
            self.storedValue = Int32(newValue)
        }
    }
    
    //Ты не должен создавать Trnsaction сам по себе
    convenience init(value: Int, date: Date) {
        self.init(context: Transaction.context)
        self.value = value
        self.date = date
    }

}
