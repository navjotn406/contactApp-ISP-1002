import Foundation
import UIKit
import CoreData

class ContactDetailsViewController: UIViewController {
    
    @IBOutlet weak var nameInitailLetterView: UIView!
    @IBOutlet weak var phoneContainerView: UIView!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var nameInitailLabel: UILabel!
    
    var contact = NSManagedObject()
    var contactViewControllerRef = ContactsViewController()
    
//    let managedContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let managedContext = (UIApplication.shared.delegate as!AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        let edit = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editTapped))

        navigationItem.rightBarButtonItems = [edit]   // adding edit button
        
        nameInitailLetterView.layer.cornerRadius = self.nameInitailLetterView.frame.size.width / 2
        nameInitailLetterView.clipsToBounds = true
        phoneContainerView.layer.cornerRadius = 8.0
        phoneContainerView.clipsToBounds = true
        
        setData()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        if self.isMovingFromParent {
            contactViewControllerRef.refreshData()       // when going back, refresh data in table
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        setData()
    }
    
    func setData() {
        nameInitailLabel.text = String((contact.value(forKeyPath: "firstName") as! String).prefix(1))
        
        let firstName = contact.value(forKeyPath: "firstName") as! String
        let lastName = contact.value(forKeyPath: "lastName") as! String
        
        nameLabel.text = firstName + " " + lastName
        phoneLabel.text = contact.value(forKeyPath: "phone") as? String
    }
    @objc func editTapped() {
        performSegue(withIdentifier: "editContact", sender: self)
    }
    
    @IBAction func deleteButtonTapped(_ sender: Any) {
        let deleteAlert = UIAlertController(title: "Delete", message: "Do you want to delete this contact?", preferredStyle: UIAlertController.Style.alert)

        deleteAlert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action: UIAlertAction!) in
            
            if (self.deleteContact()) {
                self.navigationController?.popViewController(animated: true)
            }
            else {
                self.showErrorAlert(errorMessage: "Unable to delete contact")
            }
          }))

        deleteAlert.addAction(UIAlertAction(title: "No", style: .cancel, handler: { (action: UIAlertAction!) in
            deleteAlert.dismiss(animated: false)
          }))
        present(deleteAlert, animated: true, completion: nil)
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "editContact" {
//                if let viewController = segue.destination as? AddContactsViewController {
//                    viewController.contactDetailViewControllerRef = self
//                    viewController.editContact = true
//                    viewController.contact = contact
//                    }
//            }
//    }
    func deleteContact() -> Bool {
        self.managedContext.delete(self.contact)
                do {
                    try self.managedContext.save()
                    return true
                    
                } catch _ {
                    return false
                }
        return false
    }
    
    func showErrorAlert(errorMessage: String) {
        let alert = UIAlertController(title: "Error", message: errorMessage, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
