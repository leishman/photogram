//
//  Address+CoreDataProperties.swift
//  photogram
//
//  Created by Alexander Leishman on 12/1/15.
//  Copyright © 2015 Alexander Leishman. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Address {

    @NSManaged var city: String?
    @NSManaged var country: String?
    @NSManaged var postal_code: String?
    @NSManaged var state: String?
    @NSManaged var street: String?
    @NSManaged var postcards: NSSet?

}
