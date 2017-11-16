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
    
    convenience init(name: String, surname: String, patronymic: String, phoneNumber: String, birthday: NSDate = NSDate(), image: UIImage? = nil) {
        
        self.init(context: Client.context)
        
        self.name = name
        self.surname = surname
        self.patronymic = patronymic
        self.phoneNumber = phoneNumber
        self.birthday = birthday
        
        self.imageData = image != nil ? UIImagePNGRepresentation(image!) as NSData? : nil
        self.uuid = UUID.init()
        
    }
    
}

