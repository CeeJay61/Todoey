//
//  Item.swift
//  Todoey
//
//  Created by christopher hines on 2018-07-06.
//  Copyright © 2018 christopher hines. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    
    //create the attributes of the class
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    @objc dynamic var dateCreated: Date?
    
    // create the inverse relationship to Category
    // Category becomes the type by pointing to self - "items" points to the list of items
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
    
} // *** Item ***
