//
//  Category.swift
//  Todoey
//
//  Created by christopher hines on 2018-07-06.
//  Copyright © 2018 christopher hines. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    
    // create the name field for categories
    @objc dynamic var name:String = ""
    
    // create the relationship to Item
    let items = List<Item>()
    
} // *** Category ***

