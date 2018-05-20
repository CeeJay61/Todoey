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
    
    
    var itemArray = ["Find Mike", "Buy eggos", "Destroy Demogorgon"]
    
    // create defaults for persistent data storage
    let defaults = UserDefaults.standard
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // load the table with the contents of the itemArray list stored in the plist.
        // check to ensure it is not empty
        if let items = defaults.array(forKey: "TodoListArray") as? [String] {
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
        
        // Set the text label
        cell.textLabel?.text = itemArray[indexPath.row]
        
        return cell
    } // *** tableView - cellForRowAt ***

    
    //MARK - TableView Delegate Methods
    
    // Select table row
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //print(itemArray[indexPath.row])
        
        // Check to see if the current cell already has a checkmark and delete checkmark
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        } else {
            // Add a checkmark if the cell is selected
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        } // tableView... - .checkmark ***
        
    
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
            
            // Append the new item to ItemArray
            self.itemArray.append(textField.text!)
            
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

