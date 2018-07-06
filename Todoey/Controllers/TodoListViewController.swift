//
//  ViewController.swift
//  Todoey
//
//  Created by christopher hines on 2018-05-15.
//  Copyright © 2018 christopher hines. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController {
    // By choosing to use a subclass of UITableViewController - a lot of the code is prewritten for the table view so no delegation is required.
    
    // constant for the filepath to the documents folder
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    // create the item array
    var itemArray = [Item]()
    
    // create the selectedCategory variable to load the items in the selected category
    var selectedCategory : Category? {
        // the loadItems function is only called after the category has been selected
        didSet {
            loadItems()
        } // *** didSet ***
    } // *** selectedCategory ***
    
    // create a singleton to initiate the database
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    // create defaults for persistent data storage
    // let defaults = UserDefaults.standard  // commented out as the method for persisting data will change
    
    
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

    
    //MARK: - TableView Delegate Methods
    // Select table row
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // To delete rows the following lines of code are required.  Note: the order of the code is important. If the item is removed from the array before it is deleted, it will cause runtime errors.
        // these lines are commented out for presentation of the app
         // context.delete(itemArray[indexPath.row])
         // itemArray.remove(at: indexPath.row)
        
        // Check to see if the current cell is checked or not and reverse the status
        itemArray [indexPath.row].done = !itemArray[indexPath.row].done
        
        // save the items to the array after toggling the checkmark
        saveItems()
    
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
            let newItem = Item(context: self.context)
            newItem.title = textField.text!
            newItem.parentCategory = self.selectedCategory
            newItem.done = false
            
            // Append the new item to ItemArray
            self.itemArray.append(newItem)
            
            // save the new items to the array
            self.saveItems()
            
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
    
    func saveItems() {
        // save the itemArray to the defaults
        
        do {
            try context.save()
        } catch {
            print("Error saving context: \(error)")
        } // *** do ... catch ***
        
        // Reload the data in the table to show the appended item
        self.tableView.reloadData()
        
    } // *** saveItems() ***
    
    
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil) {

        // this function is to load the items from the database to the view
        // call the data if there is any there
        // let request:NSFetchRequest<Item> = Item.fetchRequest() - no longer needed as the above is setting a default of all data if there is none specified (as per the request from the viewDidLoad func
        
        // need to filter the database by the category (name must match)
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        //request.predicate = predicate
        
        // if there is a value in the search predicate, it is used in the predicate as a searchable item (from the search bar) and will only load the searched items
        // if the predicate value is nil, then only the category predicate is used which will load all items in the category
        if let additionalPredicate = predicate{
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
        } else {
            request.predicate = categoryPredicate
        } // *** if let additionalPredicate ***
    
    
        do {
            itemArray = try context.fetch(request)
        } catch {
            print("Error fetching data from context \(error)")
        } // *** do ... catch ***
        
        // reload the table
        tableView.reloadData()

    } // *** loadItems() ***
    
    
    

} // *** TodoListViewController ***

//MARK: - searchBar Methods
extension TodoListViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
// This block of code can be made smaller and more succient by rewriting as per the code below the block
        // as some of the code is reusable from func loadItems
//        //set a fetch request
//        let request:NSFetchRequest<Item> = Item.fetchRequest()
//        // in order to search the core data, you need to use a predicate
//        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
//
//        request.predicate = predicate
//
//        // add a sort to the reply
//        let sortDiscriptor = NSSortDescriptor(key: "title", ascending: true)
//
//        request.sortDescriptors = [sortDiscriptor]
//
//        // send the request
//        do {
//            itemArray = try context.fetch(request)
//        } catch {
//            print("Error fetching data from context \(error)")
//        } // *** do ... catch ***
//
//        // reload the tableView
//        tableView.reloadData()
//
        //create a new request
        let request:NSFetchRequest<Item> = Item.fetchRequest()
        
        // in order to search the core data, you need to use a predicate. To do this we modify the request to include a predicate for the query
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        
        // modify the request to add a sort discriptor
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        // pass the request and predicate into the loadItems function
        loadItems(with: request, predicate: predicate)
        
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

