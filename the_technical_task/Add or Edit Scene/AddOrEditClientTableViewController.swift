//
//  AddOrEditClientViewController.swift
//  the_technical_task
//
//  Created by Gleb Kalachev on 11/16/17.
//  Copyright © 2017 Gleb Kalachev. All rights reserved.
//

import UIKit
import CoreData

class AddOrEditClientViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    //MARK: Outlets
    
    @IBOutlet weak var theImagePickerButton: UIButton!
    
    
    @IBOutlet weak var nameInputTextField: UITextField!
    @IBOutlet weak var surnameInputTextField: UITextField!
    @IBOutlet weak var patronymicInputTextField: UITextField!
    @IBOutlet weak var phoneNumberInputTextField: UITextField!
    
    //Также представим все эти TextField'ы в виде коллекции
    @IBOutlet var inputTextFieldCollection: [UITextField]!
    
    //Свойство, хранящее такую широту textField'a, чтобы label'ам не пришлось сжимать контент
    private var smallestTextField: UITextField?
    
    
    @IBOutlet weak var dobLabel: UILabel!
    @IBOutlet weak var birthdayDatePicker: UIDatePicker!
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    
    //MARK: Properties
    
    //Свойство, показывающее, совершались ли хоть какие-то действия с датой или нет
    var newClientContext: Bool!
    //Свойство, показывающее, указана дата, или нет
    private var isDatePicked = false
    //Свойство, показывающие,что нужно сделать: свернуть datePicker или развернуть
    private var shouldExpandDatePicker = true {
        didSet {
            DispatchQueue.main.async {
                self.birthdayDatePicker.isHidden = self.shouldExpandDatePicker
            }
            self.tableView.beginUpdates()
            self.tableView.endUpdates()
        }
    }    
    //Свойство, создающее короткий date string
    private var dateString : String {
        
        var value = ""
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/YYYY"
        value = dateFormatter.string(from: birthdayDatePicker.date)
        return value
    }
    
    
    
    //MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupUI()
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
//        //Добавление всех action'ов для всех textField'ов
//        for textField in self.inputTextFieldCollection {
//            
//            print("smallestWidth: \(self.biggestLabelWidth)")
//            
//            print("will be compared with frame: \(textField.frame)")
//            
//            if self.biggestLabelWidth == nil || self.biggestLabelWidth! > textField.frame.size.width {
//                self.biggestLabelWidth = textField.frame.size.width
//            }
//            
//            print("newWidth: \(self.biggestLabelWidth)")
//            
//            print()
//            
//        }
//        
//        for textField in self.inputTextFieldCollection {
//            textField.widthAnchor.constraint(equalToConstant: self.biggestLabelWidth!).isActive = true
//        }

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
        
        
        if self.newClientContext {
            
            guard let name = self.nameInputTextField.text,
                let surname = self.nameInputTextField.text else {
                    fatalError("Не смог уберечь saveButton от краша")
            }
            
            DataManager.shared.createNewClientAndSave(name: name, surname: surname, patronymic: self.patronymicInputTextField.text, phoneNumber: self.phoneNumberInputTextField.text, birthdayDate: self.birthdayDatePicker.date, image: self.theImagePickerButton.currentBackgroundImage != UIImage.init(named: "empty_photo_tap_to_pick_image") ? self.theImagePickerButton.currentBackgroundImage : nil)
            
            self.performSegue(withIdentifier: "unwindFromAddOrEditClientVCToClientListVCIdentifier", sender: self)
            
        } else {
            print("non-newClientContext error")
        }
        
    }
    
    @IBAction func backButtonTapped(_ sender: UIBarButtonItem) {
        
        print("back button tapped")
        
        self.performSegue(withIdentifier: "unwindFromAddOrEditClientVCToClientListVCIdentifier", sender: self)
        
    }
    
    @IBAction func theImagePickerButtonTapped(_ sender: UIButton) {
        
        //Здесь нужно зумутить ActionSheet с выбором Камера/Библиотека
        
        let ac = UIAlertController.init(title: "Выбирите источник изображения", message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
        
        ac.addAction(UIAlertAction.init(title: "Отменить", style: .cancel, handler: nil))
        
        ac.addAction(UIAlertAction.init(title: "Камера", style: .default, handler: { (_) in
            let imagePicker = UIImagePickerController.init()
            imagePicker.sourceType = .camera
            imagePicker.delegate = self
            self.present(imagePicker, animated: true, completion: nil)
        }))
        
        ac.addAction(UIAlertAction.init(title: "Библиотека", style: .default, handler: { (_) in
            let imagePicker = UIImagePickerController.init()
            imagePicker.sourceType = .photoLibrary
            imagePicker.delegate = self
            self.present(imagePicker, animated: true, completion: nil)
        }))
        
        self.present(ac, animated: true, completion: nil)
        
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        picker.dismiss(animated: true, completion: nil)
        
        guard let image = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            print("coundn't retrieve an image")
            return
        }
        
        self.theImagePickerButton.setBackgroundImage(image, for: .normal)
        
    }
    
    
    
    //MARK: IBActions on changing value
    
    @IBAction func birthdayDatePickerValueChanged(_ sender: UIDatePicker) {
        
        self.isDatePicked = true
        
        self.updateSaveButtonEnability()
        
        //Здесь нужно обновлять dobLabel с выбранной датой в коротком формате
        self.dobLabel.text = self.dateString
        
    }
    
    //MARK: Selectors
    
    //В этом методе будет проверяться правильность заполнения первых двух textField'ов (имя и фамилия) и даты рождения
    @objc func aTextFieldValueChanged(_ sender: UITextField) {
        
        self.updateSaveButtonEnability()
        
    }
    
    //Keyboard primary key tapped
    @objc func aTextFieldPrimaryActionTriggered(_ sender: UITextField) {
        
        switch sender.tag {
        case 1,2,3:
            self.inputTextFieldCollection[sender.tag].becomeFirstResponder()
        case 4:
            sender.resignFirstResponder()
        default:
            fatalError("Ошибка тега sender'a. tag: \(sender.tag)")
        }
        
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
        
        //Добавление всех action'ов для всех textField'ов
        for (index,textField) in self.inputTextFieldCollection.enumerated() {
            
            //Если textField является nameInput или surnameInput
            if [0, 1].contains(index) {
                textField.addTarget(self, action: #selector(self.aTextFieldValueChanged(_:)), for: .valueChanged)
            }
            
            textField.addTarget(self, action: #selector(self.aTextFieldPrimaryActionTriggered(_:)), for: .primaryActionTriggered)
            
//            let relativeLabelWidth = ((textField.superview as! UIStackView).subviews.first! as! UILabel).frame.size.width
            
            if smallestTextField == nil || smallestTextField!.frame.size.width > textField.frame.size.width {
                self.smallestTextField = textField
            }
            
        }
        
        //Здесь мы нашли smallestTextFieldWidth. Так что можно ставить constraint'ы
        
        
    }
    
    
}
