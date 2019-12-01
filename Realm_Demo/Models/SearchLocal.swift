//
//  SearchLocal.swift
//  Realm_Demo
//
//  Created by Sky on 12/1/19.
//  Copyright © 2019 Andy. All rights reserved.
//

import Foundation
import RealmSwift
import Realm

class SearchLocal: Object {
    @objc dynamic var date: Date = Date()
    @objc dynamic var keyword: String = ""
    
    override class func primaryKey() -> String? {
        return "keyword"
    }
}
