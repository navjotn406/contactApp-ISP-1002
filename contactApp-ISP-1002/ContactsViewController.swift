//
//  ViewController.swift
//  contactApp-ISP-1002
//
//  Created by Navjot Singh on 2022-12-08.

import UIKit
import Foundation
import CoreData

class ContactsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    let managedContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var contactsArray: [NSManagedObject] = []
    var filteredContactsArray: [NSManagedObject] = [] // For displaying search results
    var isInSearchMode = false
    let cellReuseIdentifier = "cell"
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var addContactButton: UIButton!
    @IBOutlet weak var containerView: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.backgroundImage = UIImage()
        searchBar.delegate = self
        
        let tap = UITapGestureRecognizer(target: self, action: #selector
                                         (UIInputViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        containerView.addGestureRecognizer(tap)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refreshData()
    }
    func dismissKeyboard() {
        searchBar.text = ""
        isInSearchMode = false
        view.endEditing(true)
        tableView.reloadData()
    }
    
<<<<<<< Updated upstream



func refreshData() {
    let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Contact")
    
    do {
       let temp = try managedContext.fetch(fetchRequest)
        contactsArray = temp.reversed()
    } catch let error as NSError {
      print("Could not fetch. \(error), \(error.userInfo)")
=======
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addContact" {
            if let viewController = segue.destination as? AddContactsViewController {
                viewController.contactViewControllerRef = self
                viewController.editContact = false
            }
        }
>>>>>>> Stashed changes
    }
    
    
    
    func refreshData() {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Contact")
        
        do {
            let temp = try managedContext.fetch(fetchRequest)
            contactsArray = temp.reversed()
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
        tableView.reloadData()
    }
    
    @IBAction func addContactButtonTapped(_ sender: Any) {
        performSegue(withIdentifier: "addContact", sender: self)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isInSearchMode {          // if user has searched then only show search results. otherwise show all
            return filteredContactsArray.count
        }
        return contactsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:ContactsCustomCell = self.tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as! ContactsCustomCell
        var contact = contactsArray[indexPath.row]
        if isInSearchMode {
            contact = filteredContactsArray[indexPath.row]
        }
        
        let firstName = contact.value(forKeyPath: "firstName") as! String
        let lastName = contact.value(forKeyPath: "lastName") as! String
        cell.nameLabel.text = firstName + " " + lastName
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let contactDetailsViewController = storyBoard.instantiateViewController(withIdentifier: "ContactDetailsViewController") as! ContactDetailsViewController
        
        let contact = contactsArray[indexPath.row]
        contactDetailsViewController.contactViewControllerRef = self
        contactDetailsViewController.contact = contact
        
        self.navigationController?.pushViewController(contactDetailsViewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        isInSearchMode = true        // searching has started.
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        filteredContactsArray = []       // find all the contacts having searhing query.
        for contact in contactsArray {
            let searchQuery = searchBar.text ?? ""
            let firstName = contact.value(forKeyPath: "firstName") as! String
            let lastName = contact.value(forKeyPath: "lastName") as! String
            
            if(firstName.contains(searchQuery) || (lastName.contains(searchQuery))) {
                filteredContactsArray.append(contact)
            }
        }
        tableView.reloadData()
    }
}
