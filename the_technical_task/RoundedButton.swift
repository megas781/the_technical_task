//
//  RoundedButton.swift
//  Civilia_Simulator
//
//  Created by Gleb Kalachev on 9/16/17.
//  Copyright © 2017 Gleb Kalachev. All rights reserved.
//

import UIKit

@IBDesignable class RoundedButton: UIView {

   @IBInspectable var theCornerRadius: CGFloat {
      get {
         return self.layer.cornerRadius
      }
      set {
         self.layer.cornerRadius = newValue
      }
   }

}
