//
//  CategoryViewController.swift
//  Todoey
//
//  Created by christopher hines on 2018-07-05.
//  Copyright © 2018 christopher hines. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {
    
    // create an array to hold the categories
    var categories = [Category]()
    
    // create a singleton to initiate the database
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()

        // load the categories into the array
        loadCategories()
      
    } // *** viewDidLoad ***

    
//Mark: - TableView Datasource Methods
    
    // Number of Rows
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    } // *** tableView - numberOfRowsInSection ***
    
    // Choose the data at the selected row
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Create reusable cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        // Set the text label
        cell.textLabel?.text = categories[indexPath.row].name
        
        // return the cell
        return cell
        } // *** tableView - cellForRowAt ***
    

//Mark: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // when the row is selected, the items list pops up for the category
        performSegue(withIdentifier: "goToItems", sender: self)
        } // *** tableView - didSelectRowAt ***
    
        // prepare the segue for going to the category
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            // new constant that references the destination view controller
            let destinationVC = segue.destination as! TodoListViewController
            
            if let indexPath = tableView.indexPathForSelectedRow {
                destinationVC.selectedCategory = categories[indexPath.row]
                
            } // *** if let ***
            
        } // *** prepare ***
        
    
    
    
//Mark: - Data Manipulation Methods
    
    // this saves and deletes data from the database
    func saveCategories() {
        
        // save the categoryArray to the defaults
        do {
            try context.save()
        } catch {
            print("Error saving category: \(error)")
        } // *** do ... catch ***
        
        // Reload the data in the table to show the appended item
        self.tableView.reloadData()
        
    } // *** saveCategory() ***
    
    
    func loadCategories(with request: NSFetchRequest<Category> = Category.fetchRequest()) {
        
        // this function is to load the categories from the database to the view
        // call the data if there is any there
        let request: NSFetchRequest<Category> = Category.fetchRequest()
        
        do {
            categories = try context.fetch(request)
        } catch {
            print("Error loading categories \(error)")
        } // *** do ... catch ***
        
        // reload the database
        tableView.reloadData()
        
    } // *** loadCategory() ***
    
//Mark: - Add New Categories

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        // Create a local variable to hold the textfield message outside of the closures below
        var textField = UITextField()
        
        // Create an alert to add item
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            
            // what will happen once the user clicks the Add Item button on our UIAlert
            // create a new item object
            let newCategory = Category(context: self.context)
            newCategory.name = textField.text!
            
            // Append the new item to ItemArray
            self.categories.append(newCategory)
            
            // save the new items to the array
            self.saveCategories()
            
        } // *** UIAlertAction ***
        
        // Add a text field to the alert
        alert.addTextField { (field) in
            // Put a placeholder text in the textfield
            textField.placeholder = "Create new category"
            textField = field
        } // *** alert.addTextField ***
        
        // Perform the alert action
        alert.addAction(action)
        
        // Present the alert
        present(alert, animated: true, completion: nil)
    } // *** addButtonPressed ***
    
    
    
    
    
    
} // *** CategoryViewController ***
