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
    
    @IBOutlet weak var theImagePickerImageView: UIImageView!
    
    
    @IBOutlet weak var nameInputTextField: UITextField!
    @IBOutlet weak var surnameInputTextField: UITextField!
    @IBOutlet weak var patronymicInputTextField: UITextField!
    @IBOutlet weak var phoneNumberInputTextField: UITextField!
    
    //Также представим все эти TextField'ы в виде коллекции
    @IBOutlet var inputTextFieldCollection: [UITextField]!
    
    //Свойство, хранящее самый узкий textField. Все textField'ы ровняются на меньший.
//    private var smallestTextField: UITextField?
    
    
    @IBOutlet weak var dobLabel: UILabel!
    @IBOutlet weak var birthdayDatePicker: UIDatePicker!
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    
    //MARK: Properties
    
    //Свойство, показывающее, совершались ли хоть какие-то действия с датой или нет
    
    enum WhatToDoContext {
        case createNewClient, editExistingClient
    }
    
    var whatToDoContext: WhatToDoContext!
    
    //Свойство, показывающее, указана дата, или нет
    private var isDatePicked = false
    //Свойство, показывающие,что нужно сделать: свернуть datePicker или развернуть
    private var isDatePickerHidden = true {
        didSet {

            DispatchQueue.main.async {
                self.birthdayDatePicker.isHidden = self.isDatePickerHidden
            }
        
            if isDatePickerHidden {
                self.dobLabel.textColor = #colorLiteral(red: 0.7348261476, green: 0.7317743897, blue: 0.7349107862, alpha: 1)
            } else {
                self.dobLabel.textColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
            }
            
            
            
            
            if !isDatePickerHidden {
                
                //Появление DatePicker'а
                
                self.tableView.beginUpdates()
                self.tableView.endUpdates()
                
                self.tableView.scrollToRow(at: IndexPath.init(row: 5, section: 1), at: UITableViewScrollPosition.bottom, animated: true)
            } else {
                
                //Спрятать DatePicker
                
//                self.tableView.beginUpdates()
                self.tableView.scrollToRow(at: IndexPath.init(row: 4, section: 1), at: UITableViewScrollPosition.bottom, animated: true)
                
            }
        }
    }    
    
    
    
    
    //MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupUI()
        
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        //Эта строчка для того, анимация ичезновения клавиатуры была одновременна с анимацие исчезновения vc
        self.resignAnyFirstResponder()
    }
    
    
    //MARK: UITableViewDataSource
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        switch indexPath {
        case [0,0]:
            return 120
        case [1,5]:
            //Так как этот метод ничего не меняет, то если "следует развернуть DatePicker", то возвращаем 0, иначе 216
            if self.isDatePickerHidden {
                return 0
            } else {
                return 216
            }
        default:
            
            //В условии исключаем ячейку выбора даты
//            if indexPath != [1, 4] {
//                print("self.smallestTextField: \(self.smallestTextField)")
//                self.inputTextFieldCollection[indexPath.row].frame.size.width = self.smallestTextField!.frame.size.width
//            }
            
            return 44
        }
        
    }
    
    
    
    //MARK: UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        print("did select row")
        self.tableView.deselectRow(at: indexPath, animated: false)
        
        self.resignAnyFirstResponder()
        
        if indexPath == [1,4] {
            
            self.isDatePickerHidden = !self.isDatePickerHidden
            
            
            //(begin и end Editing методы в наблюдателе свойства)
        }
    }
    
    
    //MARK: IBActions on tap
    
    @IBAction func saveButtonTapped(_ sender: UIBarButtonItem) {
        
        guard let name = self.nameInputTextField.text,
            let surname = self.surnameInputTextField.text else {
                fatalError("Не смог уберечь saveButton от краша")
        }
        
        switch self.whatToDoContext! {
        case .createNewClient:
            
            
            DataManager.shared.createNewClientAndSave(name: name, surname: surname, patronymic: self.patronymicInputTextField.text, phoneNumber: self.phoneNumberInputTextField.text, birthdayDate: self.birthdayDatePicker.date, image: self.theImagePickerImageView.image != UIImage.init(named: "empty_photo_tap_to_pick_image") ? self.theImagePickerImageView.image : nil)
            
            self.performSegue(withIdentifier: "unwindFromAddOrEditClientVCToClientListVCIdentifier", sender: self)
            
            
        case .editExistingClient:
            
            //Здесь нужно обновить данные. Делаем проверку на идентичность, чтобы в случае чего не делать лишней работы и перезаписывать одно и то же
            
            DataManager.shared.selectedClient!.name = name
            DataManager.shared.selectedClient!.surname = surname
            DataManager.shared.selectedClient!.patronymic = self.patronymicInputTextField.text
            DataManager.shared.selectedClient!.phoneNumber = self.phoneNumberInputTextField.text
            DataManager.shared.selectedClient!.birthdayDate = self.birthdayDatePicker.date
            
            //Перезапись изображения на диск значительно больше ресурсов, так что сперва делаем проверку на идентичность
            if DataManager.shared.selectedClient!.image != self.theImagePickerImageView.image {
                DataManager.shared.selectedClient!.image = self.theImagePickerImageView.image
            }
            
            self.performSegue(withIdentifier: "unwindFromAddOrEditVCToReportVCIdentifier", sender: self)
            
            break
        }
        
        
    }
    
    @IBAction func backButtonTapped(_ sender: UIBarButtonItem) {
        
//        print("back button tapped")
        
        switch self.whatToDoContext! {
        case .createNewClient:
            self.performSegue(withIdentifier: "unwindFromAddOrEditClientVCToClientListVCIdentifier", sender: self)
        case .editExistingClient:
            
            self.performSegue(withIdentifier: "unwindFromAddOrEditVCToReportVCIdentifier", sender: self)
        }
        
        
        
        
    }
    
    @objc func theImagePickerViewTapped(_ sender: UIImageView) {
        
        //Здесь нужно создать ActionSheet с выбором Камера/Библиотека
        
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
        
        self.theImagePickerImageView.image = image.optimizeResolution(forView: self.theImagePickerImageView)
            
        self.updateSaveButtonEnability()
        
        
    }
    
    
    
    //MARK: IBActions on changing value
    
    @IBAction func birthdayDatePickerValueChanged(_ sender: UIDatePicker) {
        
        self.isDatePicked = true
        
        self.updateSaveButtonEnability()
        
        //Здесь нужно обновлять dobLabel с выбранной датой в коротком формате
        self.dobLabel.text = self.birthdayDatePicker.date.shortDateString
        
    }
    
    //MARK: Selectors
    
    //В этом методе будет проверяться правильность заполнения первых двух textField'ов (имя и фамилия) и даты рождения
    @objc func aTextFieldValueChanged(_ sender: UITextField) {
        
//        print("a textField value changed. textField.text: \(sender.text)")
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
        
        //Добавление action'ов
        self.theImagePickerImageView.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(self.theImagePickerViewTapped(_:))))
        
        for textField in self.inputTextFieldCollection {
            
            textField.addTarget(self, action: #selector(self.aTextFieldValueChanged(_:)), for: .editingChanged)
            textField.addTarget(self, action: #selector(self.aTextFieldPrimaryActionTriggered(_:)), for: .primaryActionTriggered)
            
        }
        
        //Настройки theImagePickerImageView
        self.theImagePickerImageView.layer.cornerRadius = self.theImagePickerImageView.frame.size.height/2
        self.theImagePickerImageView.layer.borderColor = #colorLiteral(red: 0.3525935914, green: 0.3525935914, blue: 0.3525935914, alpha: 1)
        self.theImagePickerImageView.layer.borderWidth = 0.5
        
        
        self.tableView.tableFooterView = UIView.init(frame: CGRect.zero)
        
        
        //Настройки зависящие от контекста
        switch self.whatToDoContext! {
        case .createNewClient:
            self.title = "Новый клиент"
            self.navigationItem.leftBarButtonItem!.title = "Назад"
            self.navigationItem.rightBarButtonItem!.title = "Создать"
        case .editExistingClient:
            self.title = "" //Ставлю пустоту, так как в противном случае будет сжатие текста
            self.navigationItem.leftBarButtonItem!.title = "Отменить"
            self.navigationItem.rightBarButtonItem!.title = " Сохранить"
        }
        
        switch self.whatToDoContext! {
        
        case .createNewClient:
            
            var dateComponents = Calendar.init(identifier: Calendar.Identifier.gregorian).dateComponents([.year], from: Date())
            dateComponents.calendar = Calendar.init(identifier: Calendar.Identifier.gregorian)
//            dateComponents.hour = 12
            dateComponents.day = 15
            dateComponents.month = 1
            dateComponents.year! -= 18
            self.birthdayDatePicker.date = dateComponents.date!
            
            //этот метод в данном контексте заблокирует saveButton
            self.updateSaveButtonEnability()
            break
            
            
        case .editExistingClient:
            
//            print(DataManager.shared.selectedClient)
            
            self.theImagePickerImageView.image = DataManager.shared.selectedClient!.image ?? UIImage.init(named: "empty_photo_tap_to_pick_image")
            
            self.nameInputTextField.text = DataManager.shared.selectedClient!.name
            self.surnameInputTextField.text = DataManager.shared.selectedClient!.surname
            self.patronymicInputTextField.text = DataManager.shared.selectedClient!.patronymic
            self.phoneNumberInputTextField.text = DataManager.shared.selectedClient!.phoneNumber
            
            
            self.birthdayDatePicker.date = DataManager.shared.selectedClient!.birthdayDate
            self.dobLabel.text = DataManager.shared.selectedClient!.birthdayDate.shortDateString
            
            
            self.isDatePicked = true
            self.saveButton.isEnabled = false
            
            break
            
        }
        
    }
    
    
    
    
}
