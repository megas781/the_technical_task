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

extension UIImage {
    
    //Функция, возвращающая изображение, оптимизированное для рамки данного view
    func optimizeResolution(forView theView: UIView) -> UIImage {
        
        //Просто константа
        let const: CGFloat = 1.5
        
        var newSize: CGSize
        
        let largerViewSide = theView.frame.size.width > theView.frame.size.height ? theView.frame.size.width : theView.frame.size.height
        
        //view должен быть меньше изображения, или ничего оптимизировать не нужно
        guard largerViewSide < (self.size.width > self.size.height ? self.size.width : self.size.height) else {
            return self
        }
        
        if self.size.width < self.size.height {
            newSize = CGSize.init(width: largerViewSide * const, height: largerViewSide * (self.size.height/self.size.width) * const)
        } else {
            newSize = CGSize.init(width: largerViewSide * (self.size.width/self.size.height) * const, height: largerViewSide * const)
        }
        
        /*В любом случае находим большую сторону view. Если */
        
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        self.draw(in:rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return newImage
    }
}
