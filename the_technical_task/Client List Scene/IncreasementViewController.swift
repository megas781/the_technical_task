//
//  IncreasementViewController.swift
//  the_technical_task
//
//  Created by Gleb Kalachev on 11/16/17.
//  Copyright © 2017 Gleb Kalachev. All rights reserved.
//

import UIKit

class IncreasementViewController: UIViewController {
    
    @IBOutlet weak var dimView: UIView!
    
    
    
    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet weak var theImageView: UIImageView!
    @IBOutlet weak var ClientNameLabel: UILabel!
    @IBOutlet weak var inputTextField: UITextField!
    
    
    //MARK: LifeCycle
    override func viewDidLoad() {
        
        //Чтобы при нажатии на темную область этот VC исчезал
        self.dimView.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(self.customDismiss)))
        
        self.theImageView.layer.cornerRadius = self.theImageView.frame.size.height/2
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.dimView.alpha = 0
        self.contentView.alpha = 0
        
        UIView.animate(withDuration: 0.2 , animations: { 
            self.dimView.alpha = 0.3
            self.contentView.alpha = 1
        })
    }
    
    //MARK: IBActions
    @IBAction func saveButtonTapped(_ sender: UIButton) {
        
        //Data Logic
        
        
        
        //Animation
        self.customDismiss()
        
    }
    
    //MARK: Selectors
    
    
    
    
    //MARK: Custom Functions
    @objc func customDismiss() {
        
        //При исчезновении обязательно должна убираться клавиатура
        self.inputTextField.resignFirstResponder()
        
        //Анимация исчезновения
        UIView.animate(withDuration: 0.2, animations: { 
            self.dimView.alpha = 0
            self.contentView.alpha = 0
        }) { (_) in
            self.dismiss(animated: false, completion: nil)
        }
        
    }
    
    
    
}
