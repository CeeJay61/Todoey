//
//  ViewController.swift
//  Todoey
//
//  Created by christopher hines on 2018-05-15.
//  Copyright © 2018 christopher hines. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {
    // By choosing to use a subclass of UITableViewController - a lot of the code is prewritten for the table view so no delegation is required.
    
    
    var itemArray = [Item]()
    
    // create defaults for persistent data storage
    let defaults = UserDefaults.standard
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let newItem1 = Item()
        newItem1.title = "Find Mike"
        itemArray.append(newItem1)
        
        let newItem2 = Item()
        newItem2.title = "Buy eggos"
        itemArray.append(newItem2)
        
        let newItem3 = Item()
        newItem3.title = "Destroy Demogorgon"
        itemArray.append(newItem3)
        
        // load the table with the contents of the itemArray list stored in the plist.
        // check to ensure it is not empty
        if let items = defaults.array(forKey: "TodoListArray") as? [Item] {
            itemArray = items
        } // *** if let ***
        
    } // *** viewDidLoad ***
    

    //Mark - Tableview Datasource Methods
    
    // Number of Rows
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    } // *** tableView - numberOfRowsInSection ***
    
    // Choose the data at the selected row
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Create reusable cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        // Create a new constant to represent the itemArray to reduce clutter in the coding
        let item = itemArray[indexPath.row]
        
        // Set the text label
        cell.textLabel?.text = item.title
        
        // Ternary operator ==>
        // value = condition ? valueIfTrue : valueIfFalse
        
        cell.accessoryType = item.done == true ? .checkmark : .none
        // the above statement format replaces the following code
        //        if item.done == true {
        //            cell.accessoryType = .checkmark
        //        } else {
        //            cell.accessoryType = .none
        //        }
        
        return cell
    } // *** tableView - cellForRowAt ***

    
    //MARK - TableView Delegate Methods
    
    // Select table row
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //print(itemArray[indexPath.row])
        
        // Check to see if the current cell is checked or not and reverse the status
        itemArray [indexPath.row].done = !itemArray[indexPath.row].done
        
        // refresh the tableview
        tableView.reloadData()
    
        // Deselect row after clicking - removing the highlight
        tableView.deselectRow(at: indexPath, animated: true)
    
    } // *** tableView - didSelectRowAt ***
    
    //Mark - Add New Items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        // Create a local variable to hold the textfield message outside of the closures below
        var textField = UITextField()
        
        // Create an alert to add item
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            // what will happen once the user clicks the Add Item button on our UIAlert
            
            // create a new item object
            let newItem = Item()
            newItem.title = textField.text!
            
            // Append the new item to ItemArray
            self.itemArray.append(newItem)
            
            // save the itemArray to the defaults
            self.defaults.set(self.itemArray, forKey: "TodoListArray")
            
            // Reload the data in the table to show the appended item
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
    
    

} // *** TodoListViewController ***

