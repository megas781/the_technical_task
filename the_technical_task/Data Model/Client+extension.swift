//
//  Client+extension.swift
//  the_technical_task
//
//  Created by Gleb Kalachev on 11/16/17.
//  Copyright © 2017 Gleb Kalachev. All rights reserved.
//

import Foundation
import UIKit
import CoreData

extension Client {
    
    private static var context: NSManagedObjectContext { return (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext}
    
    
    
    convenience init(name: String, surname: String, patronymic: String, phoneNumber: String, birthday: Date = Date(), image: UIImage? = nil) {
        
        self.init(context: Client.context)
        
        self.name = name
        self.surname = surname
        self.patronymic = patronymic
        self.phoneNumber = phoneNumber
        self.birthday = birthday
        self.image = image != nil ? UIImagePNGRepresentation(image!) : nil
        self.uuid = UUID.init()
        
    }
    
}

