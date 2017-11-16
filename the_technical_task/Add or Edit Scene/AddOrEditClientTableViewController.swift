//
//  AddOrEditClientViewController.swift
//  the_technical_task
//
//  Created by Gleb Kalachev on 11/16/17.
//  Copyright © 2017 Gleb Kalachev. All rights reserved.
//

import UIKit
import CoreData

class AddOrEditClientViewController: UITableViewController {
    
    //MARK: Outlets
    
    @IBOutlet weak var theImageView: UIImageView!
    
    @IBOutlet weak var nameInputTextField: UITextField!
    @IBOutlet weak var surnameInputTextField: UITextField!
    @IBOutlet weak var patronymicInputTextField: UITextField!
    @IBOutlet weak var phoneNumberInputTextField: UITextField!
    
    
    @IBOutlet weak var dobLabel: UILabel!
    @IBOutlet weak var birthdayDatePicker: UIDatePicker!
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    
    //MARK: Properties
    
    //Свойство, показывающее, совершались ли хоть какие-то действия с датой или нет
    var isDatePicked = false 
    
    //MARK: LifeCycle
    override func viewDidLoad() {
        
        
        
    }
    
    
    //MARK: IBActions on tap
    
    @IBAction func saveButtonTapped(_ sender: UIBarButtonItem) {
        
        print("SaveButtonTapped")
        
    }
    
    @IBAction func backButtonTapped(_ sender: UIBarButtonItem) {
        
        print("back button tapped" )
        
        self.performSegue(withIdentifier: "unwindFromAddOrEditClientVCToClientListVCIdentifier", sender: self)
        
    }
    
    
    
    //MARK: IBActions on changing value
    
    //В этом методе будет проверяться правильность заполнения textField'ов и даты рождения
    @IBAction func aTextFieldValueChanged(_ sender: UITextField) {
        
        //Если в nameInputTextField'e и surnameInputTextField'e хоть что-то написано и была нажата ячейка даты для показа datePicker'a, то можно включить saveButton
        if nameInputTextField.text != "" && nameInputTextField.text != nil, 
            surnameInputTextField.text != "" && surnameInputTextField.text != nil,
            self.isDatePicked {
                self.saveButton.isEnabled = true
        } else {
            self.saveButton.isEnabled = false
        }
        
    }
    
    //MARK: Custom funcstions
    
    private func setupUI() {
        self.theImageView.layer.cornerRadius = self.theImageView.frame.size.height/2
    }
    
}
