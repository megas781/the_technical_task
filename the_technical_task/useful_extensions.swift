//
//  useful_extensions.swift
//  the_technical_task
//
//  Created by Gleb Kalachev on 11/17/17.
//  Copyright © 2017 Gleb Kalachev. All rights reserved.
//

import Foundation
import UIKit

extension Date {
    
    //Удобное вычисляемое свойство для преопрезования Date в String
    var shortDateString : String {
        var returnValue = ""
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.YYYY"
        returnValue = dateFormatter.string(from: self)
        return returnValue
    }
}

extension String {
    //Вернуть строку с удаленными лишними пробелами
    func withoutExtraSpaces() -> String {
        
        var result = self
        
        while result.contains("  ") {
            result = result.replacingOccurrences(of: "  ", with: " ")
        }
        return result
    }
    
    //Помимо удаления двойных пробелов пробелов также удаляются первый и последний пробел, если они есть
    func searchableString() -> String {
        var returnValue = self.withoutExtraSpaces()
        
        if returnValue.first == " " {
            returnValue.removeFirst()
        }
        if returnValue.last == " " {
            returnValue.removeLast()
        }
        
        return returnValue
    }
}
