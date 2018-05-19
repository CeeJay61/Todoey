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
    
    
    let itemArray = ["Find Mike", "Buy eggos", "Destroy Demogorgon"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
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
    }

    
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
    
    }
    

} // *** TodoListViewController ***

