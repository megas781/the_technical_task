//
//  RoundedButton.swift
//  Civilia_Simulator
//
//  Created by Gleb Kalachev on 9/16/17.
//  Copyright © 2017 Gleb Kalachev. All rights reserved.
//

import UIKit

@IBDesignable class RoundedView: UIView {

   @IBInspectable var theCornerRadius: CGFloat {
      get {
         return self.layer.cornerRadius
      }
      set {
         self.layer.cornerRadius = newValue
      }
   }

}
@IBDesignable class RoundedButton: UIButton {
    
    @IBInspectable var theCornerRadius: CGFloat {
        get {
            return self.layer.cornerRadius
        }
        set {
            self.layer.cornerRadius = newValue
        }
    }
    
}
