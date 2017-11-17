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
    @IBOutlet weak var clientNameLabel: UILabel!
    @IBOutlet weak var inputTextField: UITextField!
    
    
    var selectedClientIndex: Int!
    
    //MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Чтобы при нажатии на темную область этот VC исчезал
        self.dimView.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(self.customDismiss)))
        self.theImageView.layer.cornerRadius = self.theImageView.frame.size.height/2
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //Установка значений outlet'ов
        let properClient = DataManager.shared.inMemoryClients[selectedClientIndex]
        self.theImageView.image = properClient.image
        self.clientNameLabel.text = "\(properClient.name) \(properClient.surname)"
        
        
        self.dimView.alpha = 0
        self.contentView.alpha = 0
        
        self.inputTextField.becomeFirstResponder()
        UIView.animate(withDuration: 0.15 , animations: { 
            self.dimView.alpha = 0.3
            self.contentView.alpha = 1
        })
    }
    
    //MARK: IBActions
    @IBAction func saveButtonTapped(_ sender: UIButton) {
        
        
        
        //Data Logic
        guard let newTransactionValue = Int((self.inputTextField.text ?? "0")) else {
            fatalError("Не смог ковертировать String в Int")
        }
        
        DataManager.shared.createNewTransactionAndSave(value: newTransactionValue, forClient: DataManager.shared.inMemoryClients[self.selectedClientIndex])
        
        
        //Animation
        self.customDismiss()
        
    }
    
    //MARK: Selectors
    
    
    
    
    //MARK: Custom Functions
    @objc func customDismiss() {
        
        //При исчезновении обязательно должна убираться клавиатура
        self.inputTextField.resignFirstResponder()
        
        //Анимация исчезновения
        UIView.animate(withDuration: 0.15, animations: { 
            self.dimView.alpha = 0
            self.contentView.alpha = 0
        }) { (_) in
            self.dismiss(animated: false, completion: nil)
        }
        
    }
    
    
    
}
