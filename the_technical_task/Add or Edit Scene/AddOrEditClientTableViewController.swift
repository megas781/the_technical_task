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
    
    @IBOutlet weak var theImagePickerButton: UIButton!
    
    
    @IBOutlet weak var nameInputTextField: UITextField!
    @IBOutlet weak var surnameInputTextField: UITextField!
    @IBOutlet weak var patronymicInputTextField: UITextField!
    @IBOutlet weak var phoneNumberInputTextField: UITextField!
    
    //Также представим все эти TextField'ы в виде коллекции
    @IBOutlet var inputTextFieldCollection: [UITextField]!
    
    
    
    @IBOutlet weak var dobLabel: UILabel!
    @IBOutlet weak var birthdayDatePicker: UIDatePicker!
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    
    //MARK: Properties
    
    //Свойство, показывающее, совершались ли хоть какие-то действия с датой или нет
    var newClientContext: Bool!
    //Свойство, показывающее, указана дата, или нет
    var isDatePicked = false
    //Свойство, показывающие,что нужно сделать: свернуть datePicker или развернуть
    var shouldExpandDatePicker = true {
        didSet {
            DispatchQueue.main.async {
                self.birthdayDatePicker.isHidden = self.shouldExpandDatePicker
            }
            self.tableView.beginUpdates()
            self.tableView.endUpdates()
        }
    }    
    //Свойство, создающее короткий date string
    var dateString : String {
        
        var value = ""
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/YYYY"
        value = dateFormatter.string(from: birthdayDatePicker.date)
        return value
    }
    
    //MARK: LifeCycle
    override func viewDidLoad() {
        
        self.setupUI()
        
        
    }
    
    //MARK: UITableViewDataSource
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        switch indexPath {
        case [0,0]:
            return 120
        case [1,5]:
            //Так как этот метод ничего не меняет, то если "следует развернуть DatePicker", то возвращаем 0, иначе 216
            if self.shouldExpandDatePicker {
                return 0
            } else {
                return 216
            }
        default:
            return 44
        }
        
    }
    
    //MARK: UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("did select row")
        self.tableView.deselectRow(at: indexPath, animated: false)
        
        self.resignAnyFirstResponder()
        
        if indexPath == [1,4] {
            
            if shouldExpandDatePicker{
                self.dobLabel.textColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
            } else {
                self.dobLabel.textColor = #colorLiteral(red: 0.7348261476, green: 0.7317743897, blue: 0.7349107862, alpha: 1)
            }
            
            //Меняем свойство (begin и end Editing методы в наблюдателе свойства)
            self.shouldExpandDatePicker = !self.shouldExpandDatePicker
        }
    }
    
    
    //MARK: IBActions on tap
    
    @IBAction func saveButtonTapped(_ sender: UIBarButtonItem) {
        
        print("SaveButtonTapped")
        
        if self.newClientContext {
            print("Should implement creating new client")
        } else {
            print("non-newClientContext")
        }
        
    }
    
    @IBAction func backButtonTapped(_ sender: UIBarButtonItem) {
        
        print("back button tapped")
        
        self.performSegue(withIdentifier: "unwindFromAddOrEditClientVCToClientListVCIdentifier", sender: self)
        
    }
    
    @IBAction func theImagePickerButtonTapped(_ sender: UIButton) {
        
        //Здесь нужно зумутить ActionSheet с выбором Камера/Библиотека
        
    }
    
    
    
    
    //MARK: IBActions on changing value
    
    //В этом методе будет проверяться правильность заполнения первых двух textField'ов (имя и фамилия) и даты рождения
    @IBAction func aTextFieldValueChanged(_ sender: UITextField) {
        
        self.updateSaveButtonEnability()
                
    }
    
    @IBAction func birthdayDatePickerValueChanged(_ sender: UIDatePicker) {
        
        self.isDatePicked = true
        
        self.updateSaveButtonEnability()
        
        //Здесь нужно обновлять dobLabel с выбранной датой в коротком формате
        self.dobLabel.text = self.dateString
        
    }
    
    
    
    //MARK: Custom funcstions
    
    @objc func resignAnyFirstResponder() {
        for textField in self.inputTextFieldCollection {
            textField.resignFirstResponder()
        }
    }
    
    private func updateSaveButtonEnability() {
        
        //Если в nameInputTextField'e и surnameInputTextField'e хоть что-то написано и была нажата ячейка даты для показа datePicker'a, то можно включить saveButton
        if nameInputTextField.text != "" && nameInputTextField.text != nil, 
            surnameInputTextField.text != "" && surnameInputTextField.text != nil,
            self.isDatePicked {
            self.saveButton.isEnabled = true
        } else {
            self.saveButton.isEnabled = false
        }
        
    }
    
    private func setupUI() {
        self.theImagePickerButton.layer.cornerRadius = self.theImagePickerButton.frame.size.height/2
        self.tableView.tableFooterView = UIView.init(frame: CGRect.zero)
        
//        //При нажатии на ячейки в пустом месте должна убираться клавиатура
//        for self.tableView.cell {
//            
//        }
        
    }
    
}
