//
//  AddContactViewController.swift
//  contactApp-ISP-1002
//
//  Created by Toshly Tomy on 2022-12-15.
//

import Foundation
import UIKit
import CoreData

class AddContactsViewController: UIViewController, UITextFieldDelegate{
    
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var headerLabel: UILabel!
    
    let managedContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var contactViewControllerRef = ContactsViewController()  // for refreshing state when user moves back and forth
    var contactDetailViewControllerRef = ContactDetailsViewController()
    var editContact = false
    var contact = NSManagedObject()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        firstNameTextField.borderStyle = .none
        lastNameTextField.borderStyle = .none
        phoneTextField.borderStyle = .none
        
        firstNameTextField.addTarget(self, action: #selector(textFieldDidChange(_:)),
                                  for: .editingChanged)
        lastNameTextField.addTarget(self, action: #selector(textFieldDidChange(_:)),
                                  for: .editingChanged)
        phoneTextField.addTarget(self, action: #selector(textFieldDidChange(_:)),
                                  for: .editingChanged)
        
        firstNameTextField.delegate = self
        lastNameTextField.delegate = self
        phoneTextField.delegate = self
        
        doneButton.isEnabled = false
        firstNameTextField.becomeFirstResponder()
        
        if (editContact) {        // user is editing a previous contact, not adding a new one.
            headerLabel.text = "Edit Contact"
            firstNameTextField.text = contact.value(forKeyPath: "firstName") as? String
            lastNameTextField.text = contact.value(forKeyPath: "lastName") as? String
            phoneTextField.text = contact.value(forKeyPath: "phone") as? String
        }
        else {
            headerLabel.text = "New Contact"
        }
        
    }
    @objc func textFieldDidChange(_ textField: UITextField) {
        if ((firstNameTextField.text != "") && (lastNameTextField.text != "") && (phoneTextField.text != "")) {
            doneButton.isEnabled = true      // all fields are mandatory. user cant store if any one is empty.
        }
        else {
            doneButton.isEnabled = false
        }
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func doneButtonTapped(_ sender: Any) {
        let saveContactSuccess = saveContact(firstName: firstNameTextField.text!, lastName: lastNameTextField.text!, phone: phoneTextField.text!)
        if (saveContactSuccess) {
            if (editContact == false) {
                contactViewControllerRef.refreshData()
            }
            else {
                contactDetailViewControllerRef.contact = contact
                contactDetailViewControllerRef.setData()
            }
            self.dismiss(animated: true)
        }
        else {
            showErrorAlert(errorMessage: "Error saving contact. Please try again later")
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // move to nextfield when user taps return and hide keyboard if its the last field.
        if let nextField = textField.superview?.viewWithTag(textField.tag + 1) as? UITextField {nextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return false
    }
    
    func saveContact(firstName: String, lastName: String, phone: String) -> Bool {
        let entity = NSEntityDescription.entity(forEntityName: "Contact", in: managedContext)!
        
        if (editContact) { // if editing then overwrite data
            contact.setValue(firstName, forKey: "firstName")
            contact.setValue(lastName, forKey: "lastName")
            contact.setValue(phone, forKey: "phone")
        }
        else { // if adding then create new contact
            let contact = NSManagedObject(entity: entity, insertInto: managedContext)
            contact.setValue(firstName, forKey: "firstName")
            contact.setValue(lastName, forKey: "lastName")
            contact.setValue(phone, forKey: "phone")
        }
        
        do {
          try managedContext.save()
        } catch {
            return false
        }
        return true
    }
    
    func showErrorAlert(errorMessage: String) {
        let alert = UIAlertController(title: "Error", message: errorMessage, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

