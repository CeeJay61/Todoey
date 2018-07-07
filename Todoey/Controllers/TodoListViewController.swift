//
//  ViewController.swift
//  Todoey
//
//  Created by christopher hines on 2018-05-15.
//  Copyright © 2018 christopher hines. All rights reserved.
//

import UIKit
import RealmSwift

class TodoListViewController: UITableViewController {
    // By choosing to use a subclass of UITableViewController - a lot of the code is prewritten for the table view so no delegation is required.
    
    
    // create the item array
    var todoItems: Results<Item>?
    
    // create a new instance of Realm
    let realm = try! Realm()
    
    // create the selectedCategory variable to load the items in the selected category
    var selectedCategory : Category? {
       
        // the loadItems function is only called after the category has been selected
        didSet {
            loadItems()
            
        } // *** didSet ***
    } // *** selectedCategory ***
    

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // print(dataFilePath)
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
      
        
        // load the table with the contents of the itemArray list stored in the plist.
        // check to ensure it is not empty
//        if let items = defaults.array(forKey: "TodoListArray") as? [Item] {
//            itemArray = items
//        } // *** if let ***
        
    } // *** viewDidLoad ***
    

    //MARK: - Tableview Datasource Methods
    
    // Number of Rows
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    } // *** tableView - numberOfRowsInSection ***
    
    // Choose the data at the selected row
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Create reusable cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        // Create a new constant to represent the todoItems to reduce clutter in the coding
        if let item = todoItems?[indexPath.row] {
        
            // Set the text label
            cell.textLabel?.text = item.title
        
            // Ternary operator ==>
            // value = condition ? valueIfTrue : valueIfFalse
            cell.accessoryType = item.done ? .checkmark : .none
            
        } else {
            cell.textLabel?.text = "No items added"
        } // *** if let ***
        
        return cell
    } // *** tableView - cellForRowAt ***

    
    //MARK: - TableView Delegate Methods
    // Select table row
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = todoItems?[indexPath.row] {
            do {
                try realm.write {
                    item.done = !item.done
                } // *** realm.write ***
            } catch {
                print("Error saving done status, \(error)")
            } // *** do - catch ***
        } // *** if let item ***
    
        // Reload the tableView
        tableView.reloadData()
        
        // Deselect row after clicking - removing the highlight
        tableView.deselectRow(at: indexPath, animated: true)
       
    } // *** tableView - didSelectRowAt ***
    
    
    //MARK: - Add New Items
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        // Create a local variable to hold the textfield message outside of the closures below
        var textField = UITextField()
        
        // Create an alert to add item
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            // what will happen once the user clicks the Add Item button on our UIAlert
            // create a new item object
            if let currentCategory = self.selectedCategory {
                do {
                    try self.realm.write {
                        let newItem = Item()
                        newItem.title = textField.text!
                        newItem.dateCreated = Date()
                        currentCategory.items.append(newItem)
                        } // *** try realm.write ***
                } catch {
                        print("Error saving new items, \(error)")
                    } // *** catch ***
            
            } // *** if let currentCategory ***
            
            // reload the data into the table
            self.tableView.reloadData()
            
        } // *** UIAlertAction ***
        
        // Add a text field to the alert
        alert.addTextField { (alertTextField) in
            // Put a placeholder text in the textfield
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        } // *** alert.addTextField ***
        
        // Perform the alert action
        alert.addAction(action)
        
        // Present the alert
        present(alert, animated: true, completion: nil)
        
    } // *** addButtonPressed ***
    
   
    //MARK: - Model Manupulation Methods
    
    // this saves and deletes data from the database
    
//    func saveItems() {
//        // save the itemArray to the defaults
//
//        do {
//            try context.save()
//        } catch {
//            print("Error saving context: \(error)")
//        } // *** do ... catch ***
//
//        // Reload the data in the table to show the appended item
//        self.tableView.reloadData()
//
  //  } // *** saveItems() ***
    
    
    func loadItems() {

        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)

        
        // reload the table
        tableView.reloadData()

    } // *** loadItems() ***
    
    
    

} // *** TodoListViewController ***


//MARK: - searchBar Methods

extension TodoListViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        // filter the todoItems using the input from the search bar
        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        
        // reload data to the table
        tableView.reloadData()
    } // *** searchBarSearchButtonClicked ***
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            
            // need to dispatch the focus on the search function - changes it to another thread
            DispatchQueue.main.async {
                // release the searchBar from being the first responder
                searchBar.resignFirstResponder()
            } // *** DispatchQueue ***
            
        } else {
            // this else allows the searching to begin as you type your request. (another student suggested this)
            searchBarSearchButtonClicked(searchBar)
        }// *** searchBar ... 0 ***
    } // *** searchBar - textDidChange ***
    
} // *** extension ToDoListViewController ***

